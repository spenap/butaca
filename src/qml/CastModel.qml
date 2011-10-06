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

import QtQuick 1.1
import "butacautils.js" as BUTACA

// See http://api.themoviedb.org/2.1/methods/Movie.getInfo
XmlListModel {

    property string params: ''

    source: BUTACA.getTMDbSource(BUTACA.TMDB_MOVIE_GET_INFO, locale, params)
    query: BUTACA.TMDB_MOVIE_CAST_QUERY

    /* name */
    XmlRole { name: "title"; query: "@name/string()" }
    /* character */
    XmlRole { name: "subtitle"; query: "@character/string()"}
    XmlRole { name: "job"; query: "@job/string()" }
    XmlRole { name: "personId"; query: "@id/string()" }
    /* thumb */
    XmlRole { name: "icon"; query: "@thumb/string()" }
    XmlRole { name: "department"; query: "@department/string()" }
    XmlRole { name: "url"; query: "@url/string()" }
    XmlRole { name: "order"; query: "@order/string()" }
    XmlRole { name: "castId"; query: "@cast_id/string()" }
}
