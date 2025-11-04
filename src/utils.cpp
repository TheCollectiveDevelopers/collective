#include "src/utils.h"
#include <QMimeDatabase>
#include <QUrl>
#include <QMimeType>
#include <QFile>
#include <QDir>
#include <QStandardPaths>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QEventLoop>
#include <QFileInfo>
#include <QJsonArray>
#include <QCryptographicHash>
#include <QDateTime>

bool Utils::allowDropFile(QUrl fileUrl) const {
    QMimeDatabase db;
    QMimeType mime = db.mimeTypeForUrl(fileUrl);

    return (mime.name().startsWith("image/") || mime.name().startsWith("audio/"));
}

Utils::AssetTypes Utils::detectFileType(QUrl fileUrl) const{
    QMimeDatabase db;
    QMimeType mime = db.mimeTypeForUrl(fileUrl);
    if(mime.name().startsWith("image/")){
        return Utils::AssetTypes::Image;
    }else if(mime.name().startsWith("audio/")){
        return Utils::AssetTypes::Music;
    }else if(mime.name().compare("application/pdf") == 0){
        return Utils::AssetTypes::PDF;
    }else if(mime.name().startsWith("video/")){
        return Utils::AssetTypes::Video;
    }else if(mime.name().compare("text/uri-list")){
        return Utils::AssetTypes::URL;
    }else{
        return Utils::AssetTypes::Other;
    }
}

void Utils::saveImage(QUrl url) const {
    saveAsset(url);
}

void Utils::saveSettings(QJsonObject settings) const {
    QString homePath = QStandardPaths::writableLocation(QStandardPaths::HomeLocation);
    QString settingsDir = homePath + "/.collective";
    QString settingsPath = settingsDir + "/settings.json";

    QDir dir;
    if (!dir.exists(settingsDir)) {
        dir.mkpath(settingsDir);
    }

    QFile file(settingsPath);
    if (file.open(QIODevice::WriteOnly)) {
        QJsonDocument doc(settings);
        file.write(doc.toJson());
        file.close();
    }
}

QJsonObject Utils::loadSettings() const {
    QString homePath = QStandardPaths::writableLocation(QStandardPaths::HomeLocation);
    QString settingsPath = homePath + "/.collective/settings.json";

    QFile file(settingsPath);
    if (file.open(QIODevice::ReadOnly)) {
        QByteArray data = file.readAll();
        file.close();
        QJsonDocument doc = QJsonDocument::fromJson(data);
        return doc.object();
    }

    return QJsonObject();
}

QString Utils::saveAsset(QUrl url) const {
    QString homePath = QStandardPaths::writableLocation(QStandardPaths::HomeLocation);
    QString assetsDir = homePath + "/.collective/assets";

    QDir dir;
    if (!dir.exists(assetsDir)) {
        dir.mkpath(assetsDir);
    }

    if (url.isLocalFile()) {
        QString sourcePath = url.toLocalFile();
        QFileInfo fileInfo(sourcePath);

        // Read file contents for hash
        QFile sourceFile(sourcePath);
        if (!sourceFile.open(QIODevice::ReadOnly)) {
            return QString();
        }
        QByteArray fileData = sourceFile.readAll();
        sourceFile.close();

        QCryptographicHash hash(QCryptographicHash::Md5);
        hash.addData(fileData);
        QString fileName = hash.result().toHex() + "." + fileInfo.suffix();
        QString destPath = assetsDir + "/" + fileName;

        // Only copy if file doesn't already exist
        if (!QFile::exists(destPath)) {
            QFile::copy(sourcePath, destPath);
        }
        return destPath;
    } else {
        QNetworkAccessManager manager;
        QNetworkRequest request(url);
        QNetworkReply *reply = manager.get(request);

        QEventLoop loop;
        QObject::connect(reply, &QNetworkReply::finished, &loop, &QEventLoop::quit);
        loop.exec();

        if (reply->error() == QNetworkReply::NoError) {
            QByteArray data = reply->readAll();

            QString contentType = reply->header(QNetworkRequest::ContentTypeHeader).toString();
            QString extension = "bin";

            if (contentType.startsWith("image/")) {
                QMimeDatabase db;
                QMimeType mime = db.mimeTypeForName(contentType);
                if (!mime.suffixes().isEmpty()) {
                    extension = mime.suffixes().first();
                }
            } else if (contentType.startsWith("audio/")) {
                QMimeDatabase db;
                QMimeType mime = db.mimeTypeForName(contentType);
                if (!mime.suffixes().isEmpty()) {
                    extension = mime.suffixes().first();
                }
            } else if (contentType.startsWith("video/")) {
                QMimeDatabase db;
                QMimeType mime = db.mimeTypeForName(contentType);
                if (!mime.suffixes().isEmpty()) {
                    extension = mime.suffixes().first();
                }
            } else if (contentType == "application/pdf") {
                extension = "pdf";
            }

            QCryptographicHash hash(QCryptographicHash::Md5);
            hash.addData(data);
            QString fileName = hash.result().toHex() + "." + extension;
            QString destPath = assetsDir + "/" + fileName;

            // Only write if file doesn't already exist
            if (!QFile::exists(destPath)) {
                QFile file(destPath);
                if (file.open(QIODevice::WriteOnly)) {
                    file.write(data);
                    file.close();
                }
            }

            reply->deleteLater();
            return destPath;
        }

        reply->deleteLater();
        return QString();
    }
}

void Utils::deleteAsset(QUrl url) const{
    QString filePath;

    if (url.isLocalFile()) {
        filePath = url.toLocalFile();
    } else {
        filePath = url.toString();
    }

    QFile file(filePath);
    if (file.exists()) {
        file.remove();
    }
}

void Utils::saveCollections(QJsonArray collections) const {
    QString homePath = QStandardPaths::writableLocation(QStandardPaths::HomeLocation);
    QString collectionsDir = homePath + "/.collective";
    QString collectionsPath = collectionsDir + "/collections.json";

    QDir dir;
    if (!dir.exists(collectionsDir)) {
        dir.mkpath(collectionsDir);
    }

    QJsonObject root;
    root["collections"] = collections;

    QFile file(collectionsPath);
    if (file.open(QIODevice::WriteOnly)) {
        QJsonDocument doc(root);
        file.write(doc.toJson());
        file.close();
    }
}

QJsonArray Utils::loadCollections() const {
    QString homePath = QStandardPaths::writableLocation(QStandardPaths::HomeLocation);
    QString collectionsPath = homePath + "/.collective/collections.json";

    QFile file(collectionsPath);
    if (file.open(QIODevice::ReadOnly)) {
        QByteArray data = file.readAll();
        file.close();
        QJsonDocument doc = QJsonDocument::fromJson(data);
        QJsonObject root = doc.object();
        return root["collections"].toArray();
    }

    return QJsonArray();
}

QJsonArray Utils::getCollectionAssets(int key) const {
    QJsonArray collections = loadCollections();

    for (int i = 0; i < collections.size(); ++i) {
        QJsonObject collection = collections[i].toObject();
        if (collection["key"].toInteger() == key) {
            qDebug() << collection << key;
            return collection["assets"].toArray();
        }
    }

    return QJsonArray();
}

QString Utils::normalizeFileUrl(const QString& path) const {
    QUrl url(path);
    
    // If it's already a valid local file URL, return it as-is
    if (url.isLocalFile()) {
        return url.toString();
    }
    
    // If it's just a path, convert to proper file URL
    // QUrl::fromLocalFile handles Windows/Unix differences automatically
    return QUrl::fromLocalFile(path).toString();
}

QString Utils::urlToLocalPath(const QString& url) const {
    QUrl qurl(url);
    
    // Qt's toLocalFile() handles all platform differences automatically
    // Returns proper path format for Windows (C:\path) or Unix (/path)
    return qurl.toLocalFile();
}
