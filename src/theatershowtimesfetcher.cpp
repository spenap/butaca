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

#include <QWebView>
#include <QWebPage>
#include <QWebFrame>
#include <QWebElement>
#include <QLocale>

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
    m_showtimesBaseUrl = QUrl("http://www.google.com/movies");
    m_movies.clear();
    m_parsedPages = 0;

    QString locale(QLocale::system().name());
    // The country code is ignored by the movies API
    m_showtimesBaseUrl.addQueryItem("hl", locale.left(locale.indexOf("_")));

    if (!location.isEmpty()) {
        m_showtimesBaseUrl.addQueryItem("near", location);
    }

    m_webView->load(m_showtimesBaseUrl);
}

void TheaterShowtimesFetcher::onLoadFinished(bool ok)
{
    if (ok) {
        m_parsedPages ++;
        QWebElement document = m_webView->page()->mainFrame()->documentElement();

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

                QString theaterName = theaterElement.findFirst("div.desc h2").toPlainText();
                QString theaterInfo = theaterElement.findFirst("div.desc div").toPlainText();

                Q_FOREACH(QWebElement movieElement, theaterElement.findAll("div.movie")) {

                    Movie movie;
                    QWebElement movieAnchor = movieElement.findFirst("div.name a");
                    QUrl anchorUrl(movieAnchor.attribute("href"));
                    movie.setMovieId(anchorUrl.queryItemValue("mid"));
                    QString movieInfo(movieElement.findFirst("span.info").toInnerXml());
                    QRegExp imdbUrl("http://www\.imdb\.com/title/\(tt[0-9]*\)");
                    if (movieInfo.contains(imdbUrl)) {
                        movie.setMovieImdbId(imdbUrl.cap(1));
                    }
                    movie.setMovieInfo(movieInfo.remove(QRegExp(" - (<.*)?$")));
                    movie.setMovieName(movieAnchor.toPlainText());
                    movie.setMovieTimes(movieElement.findFirst("div.times").toPlainText());
                    movie.setTheaterName(theaterName);
                    movie.setTheaterInfo(theaterInfo);

                    m_movies << movie;
                }
            }
        }

        if (m_numPages == m_parsedPages) {
            m_theaterListModel->setMovieShowtimes(m_movies);
            emit theatersFetched(m_movies.count());
        } else {
            if (m_showtimesBaseUrl.hasQueryItem("start"))
                m_showtimesBaseUrl.removeQueryItem("start");
            // tell google to load page with offset numcalled * 10. this loads numcalled+1th page
            m_showtimesBaseUrl.addQueryItem("start", QString::number((m_parsedPages) * 10));
            m_webView->load(m_showtimesBaseUrl);
        }

    } else {
        qCritical() << Q_FUNC_INFO << "Loading error";
        emit theatersFetched(0);
    }
}
