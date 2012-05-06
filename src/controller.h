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

class QDeclarativeContext;
class TheaterShowtimesFetcher;
class TheaterListModel;
class SortFilterModel;

//! \class Controller
//! \brief Class exposing core functionality to the QML context
//!
//! This class exposes several methods, not available in pure QML, to the
//! context, such as sharing using the share-ui interface, retrieving movie
//! showtimes, accessing the current location, formatting a currency, saving
//! images or opening Nokia Store links in the Nokia Store client
class Controller : public QObject
{
    Q_OBJECT
public:
    //! Constructor
    explicit Controller(QDeclarativeContext *context);

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
    void fetchTheaters(QString location = QString());

    //! Retrieves the location currently used
    //! \return Location currently used
    QString currentLocation();

    //! Formats the given value as a currency
    //! \param value Value to be formatted
    //! \return Formatted value
    QString formatCurrency(QString value);

    //! Saves a QML image to the device, so it can be shown in the
    //! built-in Gallery
    //! \param item The item containing the QML image, as a QObject pointer
    //! \param remoteSource The url pointing to the image
    void saveImage(QObject* item, const QString& remoteSource);

    //! Opens a link in the Nokia Store client
    //! \param link The link to open in the Nokia Store client
    void openStoreClient(const QString& url) const;

signals:
    //! Emitted when the theater showtimes have been fetched
    //! \param ok Tells whether the theater showtimes were successfully fetched
    void theatersFetched(bool ok);

private slots:
    void onTheatersFetched(int count);

private:
    QDeclarativeContext* m_declarativeContext;
    TheaterShowtimesFetcher* m_showtimesFetcher;
    TheaterListModel* m_theaterListModel;
    SortFilterModel* m_sortFilterModel;
    QString m_location;
};

#endif // CONTROLLER_H
