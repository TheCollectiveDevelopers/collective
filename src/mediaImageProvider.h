#pragma once
#include <QQuickImageProvider>
#include <QString>
#include <QtQml>
#include <QMap>

class MediaImageProvider : public QQuickImageProvider {
private:
    QMap<QString, QImage> albumArt;
public:
    MediaImageProvider();
    void setImage(const QImage &image, const QString &id);
    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize);
    bool hasImage(const QString &id) const;
};
