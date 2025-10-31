#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <qqml.h>
#include "src/utils.h"

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    Utils utils;

    qmlRegisterUncreatableType<Utils>("collective", 1, 0, "Utils", "Utils is not creatable");

    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreationFailed, &app,
        []() { QCoreApplication::exit(-1); }, Qt::QueuedConnection);

    engine.rootContext()->setContextProperty("utils", &utils);
    engine.loadFromModule("collective", "Main");

    return app.exec();
}
