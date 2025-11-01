#include "mediaImageProvider.h"
#include <QQuickImageProvider>
#include <QtLogging>

MediaImageProvider::MediaImageProvider(): QQuickImageProvider(QQuickImageProvider::ImageType::Image) {}

void MediaImageProvider::setImage(const QImage &image, const QString &id) {
    qDebug() << "Set image" << id << image;
    this->albumArt.insert(id, image);
}

QImage MediaImageProvider::requestImage(const QString &id, QSize *size, const QSize &requestedSize) {
    QImage image = this->albumArt.value(id);

    if (image.isNull()) {
        image = QImage(1, 1, QImage::Format_ARGB32);
        image.fill(Qt::transparent);
    }

    if(size->width() > 0 && size->height() > 0){
        return image.scaled(QSize(
            requestedSize.width() > 0 ? requestedSize.width() : size->width(),
            requestedSize.height() > 0 ? requestedSize.height() : size->height()
        ));
    }

    return image;
}

bool MediaImageProvider::hasImage(const QString &id) const {
    qDebug() << "Has Image" << this->albumArt << id << this->albumArt.contains(id);
    return this->albumArt.contains(id);
}
