#include "mediaPlayer.h"
#include "mediaImageProvider.h"
#include <QMediaPlayer>
#include <QMediaMetaData>
#include <QQuickImageProvider>
#include <QSize>
#include <QUrl>
#include <QUuid>
#include <QtLogging>
#include <QColor>

MediaImageProvider *CollectiveMediaPlayer::imageProvider = nullptr;

CollectiveMediaPlayer::CollectiveMediaPlayer(QObject *parent) : QMediaPlayer(parent), instanceId(QUuid::createUuid().toString(QUuid::WithoutBraces)), m_majorColor(QColor(Qt::white)) {
    qDebug() << this->instanceId;
    connect(this, &QMediaPlayer::metaDataChanged, this, &CollectiveMediaPlayer::onMetaDataChanged);
}

void CollectiveMediaPlayer::setImageProvider(MediaImageProvider *provider) {
    imageProvider = provider;
}

void CollectiveMediaPlayer::onMetaDataChanged() {
    if (imageProvider) {
        QImage coverArt = metaData().value(QMediaMetaData::ThumbnailImage).value<QImage>();
        if (!coverArt.isNull()) {
            qDebug("Found thumbnail");
            imageProvider->setImage(coverArt, this->instanceId);
            emit coverArtUrlChanged();
        }else{
            coverArt = metaData().value(QMediaMetaData::CoverArtImage).value<QImage>();
            if(!coverArt.isNull()){
                qDebug("Found cover art");
                imageProvider->setImage(coverArt, this->instanceId);
                emit coverArtUrlChanged();
            }else{
                qDebug("Did not find cover art");
                emit coverArtUrlChanged();
            }
        }

        // Return white if no image found
        if (coverArt.isNull()) {
            this->m_majorColor = QColor(Qt::white);
            emit majorColorChanged();
            return;
        }

        // Scale down the image for faster processing
        QImage scaledImage = coverArt.scaled(100, 100, Qt::KeepAspectRatio, Qt::FastTransformation);

        // Calculate the dominant color using color histogram
        QMap<QRgb, int> colorCount;
        int maxCount = 0;
        QRgb dominantColor = qRgb(255, 255, 255);

        for (int y = 0; y < scaledImage.height(); ++y) {
            for (int x = 0; x < scaledImage.width(); ++x) {
                QRgb pixel = scaledImage.pixel(x, y);

                // Skip very dark and very light pixels (likely black borders or white backgrounds)
                QColor color(pixel);
                int brightness = (color.red() + color.green() + color.blue()) / 3;
                if (brightness < 20 || brightness > 235) {
                    continue;
                }

                // Quantize colors to reduce variation (group similar colors)
                int r = (color.red() / 32) * 32;
                int g = (color.green() / 32) * 32;
                int b = (color.blue() / 32) * 32;
                QRgb quantizedColor = qRgb(r, g, b);

                colorCount[quantizedColor]++;
                if (colorCount[quantizedColor] > maxCount) {
                    maxCount = colorCount[quantizedColor];
                    dominantColor = quantizedColor;
                }
            }
        }
        this->m_majorColor = QColor(dominantColor);
        emit majorColorChanged();
    }else{
        qDebug() << "imageProvider doesn't exist";
    }
}

QUrl CollectiveMediaPlayer::coverArtUrl() const {
    qDebug() << "Cover Art url: " << this->instanceId;
    if (imageProvider && imageProvider->hasImage(this->instanceId)) {
        return QUrl("image://albumArt/" + this->instanceId);
    }
    return QUrl("qrc:/qt/qml/collective/assets/music-player.gif");
}

QColor CollectiveMediaPlayer::majorColor() const {
    return this->m_majorColor;
}
