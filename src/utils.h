#pragma once
#include <QList>
#include <QMimeData>
#include <QObject>
#include <QUrl>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QQuickItem>
#include <qtmetamacros.h>

class Utils : public QObject {
    Q_OBJECT
public:
    enum AssetTypes { Image, Music, PDF, Video, Other, URL };
    Q_ENUM(AssetTypes)
    Q_INVOKABLE bool isTrialOver() const;
    Q_INVOKABLE bool allowDropFile(QUrl fileUrl) const;
    Q_INVOKABLE AssetTypes detectFileType(QUrl fileUrl) const;
    Q_INVOKABLE void saveImage(QUrl url) const;
    Q_INVOKABLE void saveSettings(QJsonObject settings) const;
    Q_INVOKABLE QJsonObject loadSettings() const;
    Q_INVOKABLE QString saveAsset(QUrl url) const;
    Q_INVOKABLE void deleteAsset(QUrl url) const;
    Q_INVOKABLE void saveCollections(QJsonArray collections) const;
    Q_INVOKABLE QJsonArray loadCollections() const;
    Q_INVOKABLE QJsonArray getCollectionAssets(int key) const;
    Q_INVOKABLE QString normalizeFileUrl(const QString& path) const;
    Q_INVOKABLE QString urlToLocalPath(const QString& url) const;
    Q_INVOKABLE void startDrag(const QString& fileUrl, const QString& imageUrl, QQuickItem* source) const;
    Q_INVOKABLE bool checkUpdates() const;
    Q_INVOKABLE void performUpdate() const;
    Q_INVOKABLE void addFileToClipboard(const QString &fileUrl) const;
signals:
    void toggleVisible();
    void closeAllPreviewWindows();
    void closeAllUnfocusedWindows();
};
