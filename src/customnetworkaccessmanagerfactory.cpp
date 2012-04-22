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

#include "customnetworkaccessmanagerfactory.h"

#include <QtNetwork/QNetworkProxy>
#include <QtNetwork/QNetworkAccessManager>
#include <QRegExp>

// Follow
// http://doc.qt.nokia.com/4.7-snapshot/declarative-cppextensions-networkaccessmanagerfactory.html
// and
// http://blog.mrcongwang.com/2009/07/21/applying-system-proxy-settings-to-qt-application/
// for details on adding proxy support to Qt Quick applications

QNetworkAccessManager* CustomNetworkAccessManagerFactory::create(QObject *parent)
{
    QNetworkAccessManager* networkAccessManager =
            new QNetworkAccessManager(parent);

    const QString httpProxyEnvVar(qgetenv("http_proxy"));
    const QRegExp regExp("(http://)?(.*):(\\d*)/?");
    const int pos = regExp.indexIn(httpProxyEnvVar);

    if (pos > -1) {
        QString host = regExp.cap(2);
        int port = regExp.cap(3).toInt();

        QNetworkProxy proxy(QNetworkProxy::HttpCachingProxy, host, port);
        networkAccessManager->setProxy(proxy);
    }

    return networkAccessManager;
}
