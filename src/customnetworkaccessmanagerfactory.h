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

#ifndef CUSTOMNETWORKACCESSMANAGERFACTORY_H
#define CUSTOMNETWORKACCESSMANAGERFACTORY_H

#include <QtGlobal>
#if (QT_VERSION < QT_VERSION_CHECK(5, 0, 0))
#include <QDeclarativeNetworkAccessManagerFactory>
#else
#include <QtQml/QQmlNetworkAccessManagerFactory>
#endif

//! \class CustomNetworkAccessManagerFactory
//! \brief Custom NetworkAccessManagerFactory to allow creating custom QNetworkAccessManagers
//!
//! In order to use a custom QNetworkAccessManager (which can use proxy settings),
//! a custom NetworkAccessManagerFactory must be provided, and the create method,
//! reimplemented
class CustomNetworkAccessManagerFactory :
        #if (QT_VERSION < QT_VERSION_CHECK(5, 0, 0))
        public QDeclarativeNetworkAccessManagerFactory
        #else
        public QQmlNetworkAccessManagerFactory
        #endif
{
public:
    //! \reimp
    virtual QNetworkAccessManager* create(QObject* parent);
};

#endif // CUSTOMNETWORKACCESSMANAGERFACTORY_H
