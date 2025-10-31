#include "mediaPlayer.h"
#include "mediaImageProvider.h"
#include <QMediaPlayer>
#include <QMediaMetaData>
#include <QQuickImageProvider>
#include <QSize>
#include <QUrl>
#include <QUuid>
#include <qlogging.h>
#include <qmediametadata.h>

MediaImageProvider *CollectiveMediaPlayer::imageProvider = nullptr;

CollectiveMediaPlayer::CollectiveMediaPlayer(QObject *parent) : QMediaPlayer(parent), instanceId(QUuid::createUuid().toString(QUuid::WithoutBraces)) {
    connect(this, &QMediaPlayer::metaDataChanged, this, &CollectiveMediaPlayer::onMetaDataChanged);
}

void CollectiveMediaPlayer::setImageProvider(MediaImageProvider *provider) {
    imageProvider = provider;
}

void CollectiveMediaPlayer::onMetaDataChanged() {
    if (imageProvider) {
        QImage coverArt = metaData().value(QMediaMetaData::ThumbnailImage).value<QImage>();
        if (!coverArt.isNull()) {
            qDebug("Found cover art");
            imageProvider->setImage(coverArt, this->instanceId);
        }else{
            coverArt = metaData().value(QMediaMetaData::CoverArtImage).value<QImage>();
            if(!coverArt.isNull()){
                qDebug("Found cover art");
                imageProvider->setImage(coverArt, this->instanceId);
            }else{
                qDebug("Did not find cover art");
            }
        }
    }
}

QUrl CollectiveMediaPlayer::coverArtUrl() const {
    return QUrl("image://albumArt/" + this->instanceId);
}
