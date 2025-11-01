#pragma once
#include <QList>
#include <QMimeData>
#include <QObject>
#include <QUrl>
#include <qtmetamacros.h>

class Utils : public QObject {
    Q_OBJECT
public:
    enum AssetTypes { Image, Music, PDF, Video, Other, URL };
    Q_ENUM(AssetTypes)
    Q_INVOKABLE bool allowDropFile(QUrl fileUrl) const;
    Q_INVOKABLE AssetTypes detectFileType(QUrl fileUrl) const;
};
