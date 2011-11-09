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
