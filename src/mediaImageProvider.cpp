#include "mediaImageProvider.h"
#include <QQuickImageProvider>
#include <QtLogging>
#include <qlogging.h>

MediaImageProvider::MediaImageProvider(): QQuickImageProvider(QQuickImageProvider::ImageType::Image) {}

void MediaImageProvider::setImage(const QImage &image, const QString &id) {
    this->albumArt.insert(id, image);
}

QImage MediaImageProvider::requestImage(const QString &id, QSize *size, const QSize &requestedSize) {

    if(size->width() > 0 && size->height() > 0){
        return this->albumArt.value(id).scaled(QSize(
            requestedSize.width() > 0 ? requestedSize.width() : size->width(),
            requestedSize.height() > 0 ? requestedSize.height() : size->height()
        ));
    }

    return this->albumArt.value(id);
}
