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

import QtQuick 1.1
import 'moviedbwrapper.js' as TheMovieDb

// See http://api.themoviedb.org/2.1/methods/Genres.getList
XmlListModel {
    source: TheMovieDb.genres_list({ app_locale: appLocale })
    query: TheMovieDb.query_path(TheMovieDb.GENRES_LIST)

    XmlRole { name: "title"; query: "@name/string()" }
    XmlRole { name: "genreId"; query: "id/string()" }
    XmlRole { name: "genreUrl"; query: "url/string()" }
}
