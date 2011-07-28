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

#include <QDesktopServices>
#include <QUrl>
#include <maemo-meegotouch-interfaces/shareuiinterface.h>
#include <MDataUri>

ButacaHelper::ButacaHelper(QObject *parent) :
    QObject(parent)
{

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
