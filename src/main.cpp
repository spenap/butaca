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

#include "butacahelper.h"

#include <QtGui/QApplication>
#include <QtDeclarative>
#include <QDeclarativeContext>
#include <applauncherd/mdeclarativecache.h>

static QApplication* app;
static QDeclarativeView* view;

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    app = MDeclarativeCache::qApplication(argc, argv);
    view = MDeclarativeCache::qDeclarativeView();
    QDeclarativeContext* context = view->rootContext();
    ButacaHelper* butacaHelper = new ButacaHelper();

    context->setContextProperty("helper", butacaHelper);

    view->setSource(QUrl("qrc:/qml/main.qml"));
    view->showFullScreen();

    int result = app->exec();

    delete context;
    delete butacaHelper;

    return result;
}
