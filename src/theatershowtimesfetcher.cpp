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

#include "theatershowtimesfetcher.h"
#include "theaterlistmodel.h"

#include <QWebPage>
#include <QWebFrame>
#include <QWebElement>
#include <QLocale>

#include <QDebug>

TheaterShowtimesFetcher::TheaterShowtimesFetcher(TheaterListModel* model) :
    m_webPage(new QWebPage),
    m_theaterListModel(model)
{
    connect(m_webPage, SIGNAL(loadFinished(bool)),
            this, SLOT(onLoadFinished(bool)), Qt::UniqueConnection);
}

TheaterShowtimesFetcher::~TheaterShowtimesFetcher()
{
    delete m_webPage;
}

void TheaterShowtimesFetcher::fetchTheaters(QString location, QString daysAhead)
{
    // TODO: This is currently hardcoded to Google Showtimes. It would be
    // better if several services could be used.
    m_showtimesBaseUrl = QUrl("http://www.google.com/movies");
    #if (QT_VERSION < QT_VERSION_CHECK(5,0,0))
    m_showtimesQuery = m_showtimesBaseUrl;
    #endif
    m_cinemas.clear();
    m_parsedPages = 0;

    QString locale(QLocale::system().name());
    // The country code is ignored by the movies API
    m_showtimesQuery.addQueryItem("hl", locale.left(locale.indexOf("_")));

    if (!location.isEmpty()) {
        m_showtimesQuery.addQueryItem("near", location);
    }
    m_showtimesQuery.addQueryItem("date", daysAhead);

    #if (QT_VERSION >= QT_VERSION_CHECK(5,0,0))
    m_showtimesBaseUrl.setQuery(m_showtimesQuery);
    #endif

    m_webPage->mainFrame()->load(m_showtimesBaseUrl);
}

void TheaterShowtimesFetcher::onLoadFinished(bool ok)
{
    if (ok) {
        m_parsedPages ++;
        QWebElement document = m_webPage->mainFrame()->documentElement();

        // in case we need more pages loaded. "div.n" is the navigation bar. if it's present
        // we know there's more than 1 page. only need to do this once
        if (m_parsedPages == 1)
        {
            if (document.findAll("div.n").count() == 1) {
                m_numPages = document.findAll("div.n a").count() ;
            } else {
                m_numPages = 1;
            }
        }

        QWebElementCollection theaters = document.findAll("div.theater");

        if (theaters.count() > 0) {
            Q_FOREACH(QWebElement theaterElement, theaters) {

                Cinema cinema(theaterElement.findFirst("div.desc h2").toPlainText(),
                              theaterElement.findFirst("div.desc div").toPlainText());

                QList<Movie> moviesPlaying;

                Q_FOREACH(QWebElement movieElement, theaterElement.findAll("div.movie")) {

                    Movie movie;
                    QWebElement movieAnchor = movieElement.findFirst("div.name a");
                    QUrl anchorUrl(movieAnchor.attribute("href"));
                    #if (QT_VERSION >= QT_VERSION_CHECK(5,0,0))
                    QUrlQuery query(anchorUrl.query());
                    QString midValue = query.queryItemValue("mid");
                    #else
                    QString midValue = anchorUrl.queryItemValue("mid");
                    #endif
                    movie.setId(midValue);
                    QString movieInfo(movieElement.findFirst("span.info").toInnerXml());
                    QRegExp imdbUrl("http://www\\.imdb\\.com/title/(tt\\d*)");
                    if (movieInfo.contains(imdbUrl)) {
                        movie.setImdbId(imdbUrl.cap(1));
                    }
                    movie.setInfo(movieInfo.remove(QRegExp(" - (<.*)?$")));
                    movie.setName(movieAnchor.toPlainText());
                    movie.setShowtimes(movieElement.findFirst("div.times").toPlainText());

                    moviesPlaying << movie;
                }

                cinema.setMovies(moviesPlaying);
                m_cinemas << cinema;
            }
        }

        if (m_numPages == m_parsedPages) {
            m_theaterListModel->setCinemaList(m_cinemas);
            emit theatersFetched(m_cinemas.count());
        } else {
            if (m_showtimesQuery.hasQueryItem("start"))
                m_showtimesQuery.removeQueryItem("start");
            // tell google to load page with offset numcalled * 10. this loads numcalled+1th page
            m_showtimesQuery.addQueryItem("start", QString::number((m_parsedPages) * 10));

            #if (QT_VERSION >= QT_VERSION_CHECK(5,0,0))
            m_showtimesBaseUrl.setQuery(m_showtimesQuery);
            #else
            m_showtimesBaseUrl = m_showtimesQuery;
            #endif

            m_webPage->mainFrame()->load(m_showtimesBaseUrl);
        }

    } else {
        qCritical() << Q_FUNC_INFO << "Loading error";
        emit theatersFetched(0);
    }
}
