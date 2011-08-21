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

#ifndef BUTACAHELPER_H
#define BUTACAHELPER_H

#include <QObject>

class QWebView;
class TheaterListModel;

class ButacaHelper : public QObject
{
    Q_OBJECT
public:
    explicit ButacaHelper(QObject *parent = 0);
    ~ButacaHelper();

public slots:

    //! Opens an URL with the appropriate web browser
    //! \param url The URL to open
    void openUrl(QString url);

    //! Shares content with the share-ui interface
    //! \param title The title of the content to be shared
    //! \param url The URL of the content to be shared
    void share(QString title, QString url);

    void fetchTheaters(QString location = QString());

    QString formatCurrency(QString value);

signals:
    void theatersFetched(TheaterListModel *model);

private slots:
    void onLoadFinished(bool ok);

private:
    QWebView *m_webView;
};

#endif // BUTACAHELPER_H
