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

#include "butacahelper.h"
#include "theaterlistmodel.h"
#include "movie.h"

#include <QWebView>
#include <QWebPage>
#include <QWebFrame>
#include <QWebElement>

#include <QDesktopServices>
#include <QUrl>
#include <maemo-meegotouch-interfaces/shareuiinterface.h>
#include <MDataUri>

ButacaHelper::ButacaHelper(QObject *parent) :
    QObject(parent),
    m_webView(new QWebView)
{
}

ButacaHelper::~ButacaHelper()
{
    delete m_webView;
}

void ButacaHelper::openUrl(QString url)
{
    QUrl videoUrl(url);
    QDesktopServices::openUrl(videoUrl);
}

void ButacaHelper::share(QString title, QString url)
{
    // See https://meego.gitorious.org/meego-sharing-framework/share-ui/blobs/master/examples/link-share/page.cpp
    // and http://forum.meego.com/showthread.php?t=3768
    MDataUri dataUri;
    dataUri.setMimeType("text/x-url");
    dataUri.setTextData(url);
    dataUri.setAttribute("title", title);
    dataUri.setAttribute("description", "Shared with #Butaca");

    QStringList items;
    items << dataUri.toString();
    ShareUiInterface shareIf("com.nokia.ShareUi");
    if (shareIf.isValid()) {
        shareIf.share(items);
    } else {
        qCritical() << "Invalid interface";
    }
}

void ButacaHelper::fetchTheaters(QString location)
{
    QUrl showtimesUrl("http://www.google.com/movies");
    if (!location.isEmpty()) {
        showtimesUrl.addQueryItem("near", location);
    }

    connect(m_webView, SIGNAL(loadFinished(bool)),
            this, SLOT(onLoadFinished(bool)));
    m_webView->load(showtimesUrl);
}

void ButacaHelper::onLoadFinished(bool ok)
{
    if (ok) {
        TheaterListModel *theaterListModel = new TheaterListModel;

        QWebElement document = m_webView->page()->mainFrame()->documentElement();

        QWebElementCollection theaters = document.findAll("div.theater");

        Q_FOREACH(QWebElement theaterElement, theaters) {

            QString theaterName = theaterElement.findFirst("div.desc h2").toPlainText();
            QString theaterInfo = theaterElement.findFirst("div.desc div").toPlainText();

            Q_FOREACH(QWebElement movieElement, theaterElement.findAll("div.movie")) {

                Movie *movie = new Movie();
                movie->setMovieName(movieElement.findFirst("div.name a").toPlainText());
                movie->setMovieTimes(movieElement.findFirst("div.times").toPlainText());
                movie->setTheaterName(theaterName);
                movie->setTheaterInfo(theaterInfo);

                theaterListModel->addMovie(movie);
            }
        }

        emit theatersFetched(theaterListModel);
    } else {
        qCritical() << Q_FUNC_INFO << "Loading error";
    }
}

QString ButacaHelper::formatCurrency(QString value)
{
    double doubleValue = value.toDouble();
    return QString("$%L1").arg(doubleValue, 0, 'f', 0);
}
