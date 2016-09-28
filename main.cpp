
#include <QtWidgets/QApplication>
#include <QtQuick/QQuickView>
#include <QtCore/QDir>
#include <QtQml/QQmlEngine>
#include <QQmlContext>
#include <QTranslator>
#include "ganalytics.h"

int main(int argc, char *argv[])
{
    // Qt Charts uses Qt Graphics View Framework for drawing, therefore QApplication must be used.
    QApplication app(argc, argv);

    QQuickView viewer;
    // The following are needed to make examples run without having to install the module
    // in desktop environments.
#ifdef Q_OS_WIN
    QString extraImportPath(QStringLiteral("%1/../../../../%2"));
#else
    QString extraImportPath(QStringLiteral("%1/../../../%2"));
#endif
    viewer.engine()->addImportPath(extraImportPath.arg(QGuiApplication::applicationDirPath(),
                                      QString::fromLatin1("qml")));
    GoogleAnalytics ganalytics;
    ganalytics.initTracker();
    viewer.rootContext()->setContextProperty("gAnalytics", &ganalytics);
    
    QObject::connect(viewer.engine(), &QQmlEngine::quit, &viewer, &QWindow::close);
    QTranslator qtTranslator;
    qtTranslator.load("esood_" + QLocale::system().name(), ":/");
    //qtTranslator.load("esood_en", ":/"); // to test english
    app.installTranslator(&qtTranslator);

    viewer.setTitle(QStringLiteral("QML Chart"));

    viewer.setSource(QUrl("qrc:///esood.qml"));
    viewer.setResizeMode(QQuickView::SizeRootObjectToView);
    viewer.show();

    return app.exec();
}
