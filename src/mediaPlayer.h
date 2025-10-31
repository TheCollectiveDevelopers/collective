#pragma once
#include <QImage>
#include <QMediaPlayer>
#include <QObject>
#include <QtQml>
#include <qqmlregistration.h>
#include "mediaImageProvider.h"

class CollectiveMediaPlayer : public QMediaPlayer {
    Q_OBJECT
    Q_PROPERTY(QUrl coverArtUrl READ coverArtUrl)
    QML_ELEMENT
private:
    static MediaImageProvider *imageProvider;
    QString instanceId;
    void onMetaDataChanged();
public:
    CollectiveMediaPlayer(QObject *parent = nullptr);
    QUrl coverArtUrl() const;
    static void setImageProvider(MediaImageProvider *provider);
};
