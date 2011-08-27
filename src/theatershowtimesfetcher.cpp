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

#include "theatershowtimesfetcher.h"
#include "theaterlistmodel.h"
#include "movie.h"

#include <QWebView>
#include <QWebPage>
#include <QWebFrame>
#include <QWebElement>
#include <QUrl>

#include <QDebug>

TheaterShowtimesFetcher::TheaterShowtimesFetcher(TheaterListModel *model) :
    m_webView(new QWebView),
    m_theaterListModel(model)
{
    connect(m_webView, SIGNAL(loadFinished(bool)),
            this, SLOT(onLoadFinished(bool)), Qt::UniqueConnection);
}

TheaterShowtimesFetcher::~TheaterShowtimesFetcher()
{
    delete m_webView;
}

void TheaterShowtimesFetcher::fetchTheaters(QString location)
{
    QUrl showtimesUrl("http://www.google.com/movies");

    if (!location.isEmpty()) {
        showtimesUrl.addQueryItem("near", location);
    }

    m_webView->load(showtimesUrl);
}

void TheaterShowtimesFetcher::onLoadFinished(bool ok)
{
    if (ok) {
        QList<Movie*> movies;
        QWebElement document = m_webView->page()->mainFrame()->documentElement();
        QWebElementCollection theaters = document.findAll("div.theater");

        if (theaters.count() > 0) {
            Q_FOREACH(QWebElement theaterElement, theaters) {

                QString theaterName = theaterElement.findFirst("div.desc h2").toPlainText();
                QString theaterInfo = theaterElement.findFirst("div.desc div").toPlainText();

                Q_FOREACH(QWebElement movieElement, theaterElement.findAll("div.movie")) {

                    Movie *movie = new Movie;
                    movie->setMovieName(movieElement.findFirst("div.name a").toPlainText());
                    movie->setMovieTimes(movieElement.findFirst("div.times").toPlainText());
                    movie->setTheaterName(theaterName);
                    movie->setTheaterInfo(theaterInfo);

                    movies << movie;
                }
            }
        }

        m_theaterListModel->setMovieShowtimes(movies);

        emit theatersFetched(movies.count());
    } else {
        qCritical() << Q_FUNC_INFO << "Loading error";
        emit theatersFetched(0);
    }
}
