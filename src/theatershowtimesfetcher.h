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

#ifndef THEATERSHOWTIMESFETCHER_H
#define THEATERSHOWTIMESFETCHER_H

#include <QObject>
#include <QUrl>
#if (QT_VERSION >= QT_VERSION_CHECK(5,0,0))
#   include <QUrlQuery>
#endif
#include "movie.h"
#include "cinema.h"

class QWebPage;
class TheaterListModel;

//! \class TheaterShowtimesFetcher
//! \brief Class for fetching cinemas and showtimes for a given location
//!
//! This class provides cinemas around a given location, and showtimes for the
//! movies playing there
class TheaterShowtimesFetcher : public QObject
{
    Q_OBJECT
public:
    //! Constructor
    //! \param model TheaterListModel to be populated
    explicit TheaterShowtimesFetcher(TheaterListModel* model);

    //! Destructor
    ~TheaterShowtimesFetcher();

public slots:
    //! Fetches cinemas playing around a given location. An empty location tries
    //! automatic location
    //! \param location The location to search for cinemas, will try automatically
    //! if empty
    //! \param daysAhead Offset from the current date
    void fetchTheaters(QString location = QString(), QString daysAhead = QString("0"));

signals:
    //! Signal notifying that the cinemas have been fetched, and their number
    //! \param count The number of cinemas fetched
    void theatersFetched(int count);

private slots:
    void onLoadFinished(bool ok);

private:
    QWebPage *m_webPage;
    TheaterListModel *m_theaterListModel;
    QUrl m_showtimesBaseUrl;
#if (QT_VERSION < QT_VERSION_CHECK(5,0,0))
    QUrl m_showtimesQuery;
#else
    QUrlQuery m_showtimesQuery;
#endif
    int m_numPages;
    int m_parsedPages;
    QList<Cinema> m_cinemas;
};

#endif // THEATERSHOWTIMESFETCHER_H
