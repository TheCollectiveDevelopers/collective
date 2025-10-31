#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <qqml.h>
#include "src/utils.h"
#include "src/mediaPlayer.h"
#include "src/mediaImageProvider.h"

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    Utils utils;

    qmlRegisterType<CollectiveMediaPlayer>("collective", 1, 0, "CollectiveMediaPlayer");
    qmlRegisterUncreatableType<Utils>("collective", 1, 0, "Utils", "Utils is not creatable");

    MediaImageProvider *imageProvider = new MediaImageProvider();
    CollectiveMediaPlayer::setImageProvider(imageProvider);
    engine.addImageProvider("albumArt", imageProvider);

    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreationFailed, &app,
        []() { QCoreApplication::exit(-1); }, Qt::QueuedConnection);

    engine.rootContext()->setContextProperty("utils", &utils);
    engine.loadFromModule("collective", "Main");

    return app.exec();
}
