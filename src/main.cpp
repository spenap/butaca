/**************************************************************************
 *   Butaca
 *   Copyright (C) 2011 - 2012 Simon Pena <spena@igalia.com>
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 **************************************************************************/

#include <QTranslator>
#include <QLocale>

#if (QT_VERSION < QT_VERSION_CHECK(5, 0, 0))
#include <QtGui/QApplication>
#include <QtDeclarative>
#include <QDeclarativeContext>
#include <QTextCodec>
#include <QDesktopServices>
#define QMLVIEW QDeclarativeView
#define QMLCONTEXT QDeclarativeContext
#else
#include <QtWidgets/QApplication>
#include <QtQuick/QQuickView>
#include <QtQml/QQmlContext>
#include <QtQml/QQmlEngine>
#include <QtCore/QStandardPaths>
#define QMLVIEW QQuickView
#define QMLCONTEXT QQmlContext
#endif


#ifdef BUILD_FOR_HARMATTAN
    #include <MDeclarativeCache>
#endif

#ifdef BUILD_FOR_SAILFISH
    #include <sailfishapp.h>
#endif

#include "controller.h"
#include "customnetworkaccessmanagerfactory.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
#ifdef BUILD_FOR_HARMATTAN
    QApplication *app = MDeclarativeCache::qApplication(argc, argv);
#else
    QGuiApplication *app = SailfishApp::application(argc, argv);
    QQuickView::setDefaultAlphaBuffer(true);
#endif
    app->setApplicationName("Butaca");
    app->setOrganizationDomain("com.simonpena");
    app->setOrganizationName("simonpena");

#if (QT_VERSION < QT_VERSION_CHECK(5, 0, 0))
    // In Qt5 this assumptions holds by default.
    // Assume that strings in source files are UTF-8
    QTextCodec::setCodecForTr(QTextCodec::codecForName("utf8"));
#endif

    QString locale(QLocale::system().name());
    QTranslator translator;

    if (translator.load("l10n/butaca." + locale, ":/")) {
        app->installTranslator(&translator);
    } else {
        translator.load("l10n/butaca.en.qm", ":/");
        app->installTranslator(&translator);
    }

    QMLVIEW *view;

#ifdef BUILD_FOR_HARMATTAN
    view = MDeclarativeCache::qDeclarativeView();
#else
    view = SailfishApp::createView();
#endif

    QString storageLocation;
#if (QT_VERSION < QT_VERSION_CHECK(5, 0, 0))
    storageLocation = QDesktopServices::storageLocation(QDesktopServices::DataLocation);
#else
    storageLocation = QStandardPaths::writableLocation(QStandardPaths::DataLocation);
#endif

    view->engine()->setOfflineStoragePath(storageLocation);

    QMLCONTEXT *context = view->rootContext();

    // The Movie Database uses "-" as the divider between language and country code
    context->setContextProperty("appLocale", locale.left(locale.indexOf("_")));
    Controller *controller = new Controller(context);

    view->engine()->setNetworkAccessManagerFactory(new CustomNetworkAccessManagerFactory);

#ifdef BUILD_FOR_SAILFISH
    view->setSource(QUrl("qrc:/qml/sailfish/main.qml"));
    view->show();
#else
    view->setSource(QUrl("qrc:/qml/main.qml"));
    view->showFullScreen();
#endif

    int result = app->exec();

    delete controller;
    delete view;
    delete app;

    return result;
}
