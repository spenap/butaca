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

#ifndef CONTROLLER_H
#define CONTROLLER_H

#include <QObject>

#if (QT_VERSION < QT_VERSION_CHECK(5, 0, 0))
class QDeclarativeContext;
#else
class QQmlContext;
#endif
class TheaterShowtimesFetcher;
class TheaterListModel;
class SortFilterModel;

//! \class Controller
//! \brief Class exposing core functionality to the QML context
//!
//! This class exposes several methods, not available in pure QML, to the
//! context, such as sharing using the share-ui interface, retrieving movie
//! showtimes, accessing the current location, formatting a currency or saving
//! images
//!
//! \mainpage
//! Butaca is a movie database application
//! It provides:
//!
//! \li All details about a movie: overview, cast & crew, trailer...
//! \li All details about a celebrity: biography, filmography...
//! \li Whether a movie has extra content during or after the credits
//! \li Showtimes -when available- for cinemas around you
//!
//! You can also share links to a movie or celebrity, save them as favorites,
//! save movies to your watchlist, and save pictures into your phone's gallery.
class Controller : public QObject
{
    Q_OBJECT
public:
    //! Constructor
    #if (QT_VERSION < QT_VERSION_CHECK(5, 0, 0))
    explicit Controller(QDeclarativeContext *context);
    #else
    explicit Controller(QQmlContext *context);
    #endif

    //! Destructor
    ~Controller();

public slots:
    //! Shares content with the share-ui interface
    //! \param title The title of the content to be shared
    //! \param url The URL of the content to be shared
    void share(QString title, QString url);

    //! Fetches theater showtimes for the given location.
    //! tries to autoresolve it when it is empty
    //! \param location Specific location to fetch theater showtimes
    //! \param daysAhead Offset from the current date
    void fetchTheaters(QString location = QString(), QString daysAhead = QString("0"));

    //! Retrieves the location currently used
    //! \return Location currently used
    QString currentLocation();

    //! Retrieves the days ahead currently used
    //! \return Days ahead currently used
    QString currentDaysAhead();

    //! Formats the given value as a currency
    //! \param value Value to be formatted
    //! \return Formatted value
    QString formatCurrency(QString value);

    //! Saves a QML image to the device, so it can be shown in the
    //! built-in Gallery
    //! \param item The item containing the QML image, as a QObject pointer
    //! \param remoteSource The url pointing to the image
    void saveImage(QObject* item, const QString& remoteSource);

signals:
    //! Emitted when the theater showtimes have been fetched
    //! \param ok Tells whether the theater showtimes were successfully fetched
    void theatersFetched(bool ok);

private slots:
    void onTheatersFetched(int count);

private:
#if (QT_VERSION < QT_VERSION_CHECK(5, 0, 0))
    QDeclarativeContext* m_declarativeContext;
#else
    QQmlContext* m_declarativeContext;
#endif

    TheaterShowtimesFetcher* m_showtimesFetcher;
    TheaterListModel* m_theaterListModel;
    SortFilterModel* m_sortFilterModel;
    QString m_location;
    QString m_daysAhead;
    QString m_packageVersion;
};

#endif // CONTROLLER_H
