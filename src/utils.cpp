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
#include <QDrag>
#include <QMimeData>
#include <QPixmap>
#include <QQuickItem>
#include <QQuickItemGrabResult>
#include <QGuiApplication>
#include <QImageReader>
#include <QProcess>
#include <QCoreApplication>
#include <qnamespace.h>
#include <QtSystemDetection>

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
    if (url.isLocalFile()) {
        return url.toString();
    }
    return QUrl::fromLocalFile(path).toString();
}

QString Utils::urlToLocalPath(const QString& url) const {
    QUrl qurl(url);
    return qurl.toLocalFile();
}

void Utils::startDrag(const QString& fileUrl, const QString& imageUrl, QQuickItem* source) const{
    if (!source) {
        return;
    }

    QDrag* drag = new QDrag(source);

    QMimeData* mimeData = new QMimeData();
    QUrl url(fileUrl);
    QList<QUrl> urls;
    urls.append(url);
    mimeData->setUrls(urls);

    if (!imageUrl.isEmpty()) {
        QUrl imgUrl(imageUrl);
        QString imagePath = imgUrl.toLocalFile();

        if (!imagePath.isEmpty() && QFile::exists(imagePath)) {
            QImageReader reader(imagePath);

            if (reader.canRead()) {
                QSize imageSize = reader.size();
                if (imageSize.width() > 200) {
                    imageSize.scale(200, 200, Qt::KeepAspectRatio);
                    reader.setScaledSize(imageSize);
                }

                // Load the scaled image
                QImage image = reader.read();

                if (!image.isNull()) {
                    QPixmap pixmap = QPixmap::fromImage(image);
                    drag->setPixmap(pixmap);
                    drag->setHotSpot(QPoint(pixmap.width() / 2, pixmap.height() / 2));
                }
            }
        }
    }

    drag->setMimeData(mimeData);
    Qt::DropAction dropAction = drag->exec(Qt::CopyAction | Qt::LinkAction | Qt::MoveAction, Qt::CopyAction);
}

bool Utils::checkUpdates() const{
    #ifdef Q_OS_WIN
    QString appDir = QCoreApplication::applicationDirPath();
    QString maintenanceToolPath = appDir + "/maintenancetool.exe";

    QFileInfo toolInfo(maintenanceToolPath);
    if (!toolInfo.exists()) {
        qDebug() << "Maintenance tool not found at:" << maintenanceToolPath;
        return false;
    }

    QProcess process;
    process.start(maintenanceToolPath, QStringList() << "--checkupdates");

    if (!process.waitForStarted()) {
        qDebug() << "Failed to start maintenance tool";
        return false;
    }

    if (!process.waitForFinished(30000)) { // 30 second timeout
        qDebug() << "Maintenance tool timed out";
        process.kill();
        return false;
    }

    QString output = process.readAllStandardOutput();
    QString errorOutput = process.readAllStandardError();

    qDebug() << "Update check output:" << output;
    qDebug() << "Update check errors:" << errorOutput;

    // Check if updates are available based on exit code
    // Exit code 0 typically means updates available, 1 means no updates
    return process.exitCode() == 0;
    #endif

    #ifdef Q_OS_LINUX

    #endif

    return false;
}

void Utils::performUpdate() const{
    #ifdef Q_OS_WIN
    QString appDir = QCoreApplication::applicationDirPath();
    QString maintenanceToolPath = appDir + "/maintenancetool.exe";

    QFileInfo toolInfo(maintenanceToolPath);
    if (!toolInfo.exists()) {
        qDebug() << "Maintenance tool not found at:" << maintenanceToolPath;
        return;
    }

    // Start the maintenance tool in updater mode (non-blocking)
    QProcess::startDetached(maintenanceToolPath, QStringList() << "--updater");
    #endif

    #ifdef Q_OS_LINUX
    #endif
}
