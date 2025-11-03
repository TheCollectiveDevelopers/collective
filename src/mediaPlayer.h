#pragma once
#include <QImage>
#include <QMediaPlayer>
#include <QObject>
#include <QtQml>

#include "mediaImageProvider.h"

class CollectiveMediaPlayer : public QMediaPlayer {
    Q_OBJECT
    Q_PROPERTY(QUrl coverArtUrl READ coverArtUrl NOTIFY coverArtUrlChanged)
    Q_PROPERTY(QColor majorColor READ majorColor NOTIFY majorColorChanged)
    QML_ELEMENT
private:
    static MediaImageProvider *imageProvider;
    QString instanceId;
    QColor m_majorColor;
    void onMetaDataChanged();
public:
    CollectiveMediaPlayer(QObject *parent = nullptr);
    QUrl coverArtUrl() const;
    QColor majorColor() const;
    static void setImageProvider(MediaImageProvider *provider);

signals:
    void coverArtUrlChanged();
    void majorColorChanged();

};
