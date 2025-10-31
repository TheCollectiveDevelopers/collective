#include "src/utils.h"
#include <QMimeDatabase>
#include <QUrl>
#include <QMimeType>

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
    }else{
        return Utils::AssetTypes::Other;
    }
}
