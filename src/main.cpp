/**************************************************************************
 *    Butaca
 *    Copyright (C) 2011 Simon Pena <spena@igalia.com>
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

#include "controller.h"
#include "customnetworkaccessmanagerfactory.h"

#include <QtGui/QApplication>
#include <QtDeclarative>
#include <QDeclarativeContext>
#ifndef QT_SIMULATOR
    #include <MDeclarativeCache>
#endif
#include <QTranslator>
#include <QTextCodec>
#include <QLocale>

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QApplication *app;
#ifdef QT_SIMULATOR
    app = new QApplication(argc, argv);
#else
    app = MDeclarativeCache::qApplication(argc, argv);
#endif
    app->setApplicationName("Butaca");
    app->setOrganizationDomain("com.simonpena");
    app->setOrganizationName("simonpena");

    // Assume that strings in source files are UTF-8
    QTextCodec::setCodecForTr(QTextCodec::codecForName("utf8"));

    QString locale(QLocale::system().name());
    QTranslator translator;

    if (translator.load("l10n/butaca." + locale, ":/")) {
        app->installTranslator(&translator);
    } else {
        translator.load("l10n/butaca.en.qm", ":/");
        app->installTranslator(&translator);
    }

    QDeclarativeView *view;
#ifdef QT_SIMULATOR
    view = new QDeclarativeView();
#else
    view = MDeclarativeCache::qDeclarativeView();
#endif

    QDeclarativeContext *context = view->rootContext();

    // The Movie Database uses "-" as the divider between language and country code
    context->setContextProperty("appLocale", locale.left(locale.indexOf("_")));
    Controller *controller = new Controller(context);

    view->engine()->setNetworkAccessManagerFactory(new CustomNetworkAccessManagerFactory);
    view->setSource(QUrl("qrc:/qml/main.qml"));
    view->showFullScreen();

    int result = app->exec();

    delete controller;
    delete view;
    delete app;

    return result;
}
