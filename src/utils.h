#pragma once
#include <QList>
#include <QMimeData>
#include <QObject>
#include <QUrl>

class Utils : public QObject {
    Q_OBJECT
public:
    enum AssetTypes { Image, Music, PDF, Video, Other };
    Q_ENUM(AssetTypes)
    Q_INVOKABLE bool allowDropFile(QUrl fileUrl) const;
    Q_INVOKABLE AssetTypes detectFileType(QUrl fileUrl) const;
};
