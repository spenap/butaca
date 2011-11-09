#ifndef CUSTOMNETWORKACCESSMANAGERFACTORY_H
#define CUSTOMNETWORKACCESSMANAGERFACTORY_H

#include <QDeclarativeNetworkAccessManagerFactory>

class CustomNetworkAccessManagerFactory : public QDeclarativeNetworkAccessManagerFactory
{
public:
    virtual QNetworkAccessManager* create(QObject *parent);
};

#endif // CUSTOMNETWORKACCESSMANAGERFACTORY_H
