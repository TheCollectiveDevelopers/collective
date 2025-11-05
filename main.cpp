#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QHotkey>
#include <QKeySequence>
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

    QHotkey toggleVisibilityHotKey(QKeySequence("Alt+C"), true, &app);
    QHotkey closeWindowsHotKey(QKeySequence("Alt+W"), true, &app);
    QHotkey closeUnfocusedHotKey(QKeySequence("Alt+X"), true, &app);

    QObject::connect(&toggleVisibilityHotKey, &QHotkey::activated, qApp, [&](){
        utils.toggleVisible();
	});

    QObject::connect(&closeWindowsHotKey, &QHotkey::activated, qApp, [&](){
        utils.closeAllPreviewWindows();
	});

    QObject::connect(&closeUnfocusedHotKey, &QHotkey::activated, qApp, [&](){
        qDebug() << "unfocused hotket";
        utils.closeAllUnfocusedWindows();
	});

    return app.exec();
}
