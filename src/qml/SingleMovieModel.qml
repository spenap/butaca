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

    source: params ? BUTACA.getTMDbSource(BUTACA.TMDB_MOVIE_GET_INFO, locale, params) : ''
    query: BUTACA.TMDB_MOVIE_QUERY

    XmlRole { name: "popularity"; query: "popularity/number()" }
    XmlRole { name: "translated"; query: "translated/string()" }
    XmlRole { name: "adult"; query: "adult/string()" }
    XmlRole { name: "language"; query: "language/string()" }
    XmlRole { name: "originalName"; query: "original_name/string()" }
    XmlRole { name: "title"; query: "name/string()" }
    XmlRole { name: "alternativeName"; query: "alternative_name/string()" }
    XmlRole { name: "type"; query: "type/string()" }
    XmlRole { name: "tmdbId"; query: "id/string()" }
    XmlRole { name: "imdbId"; query: "imdb_id/string()" }
    XmlRole { name: "url"; query: "url/string()" }
    XmlRole { name: "overview"; query: "overview/string()" }
    XmlRole { name: "votes"; query: "votes/number()" }
    XmlRole { name: "rating"; query: "rating/number()" }
    XmlRole { name: "tagline"; query: "tagline/string()" }
    XmlRole { name: "certification"; query: "certification/string()" }
    XmlRole { name: "released"; query: "released/string()" }
    XmlRole { name: "runtime"; query: "runtime/number()" }
    XmlRole { name: "budget"; query: "budget/string()" }
    XmlRole { name: "revenue"; query: "revenue/string()" }
    XmlRole { name: "homepage"; query: "homepage/string()" }
    XmlRole { name: "trailer"; query: "trailer/string()" }
    XmlRole { name: "poster"; query: "images/image[@size='cover' and @type='poster'][1]/@url/string()" }
    XmlRole { name: "director"; query: "cast/person[@job='Director'][1]/@name/string()" }
    XmlRole { name: "actor1"; query: "cast/person[@job='Actor' and @order='0'][1]/@name/string()" }
    XmlRole { name: "actor2"; query: "cast/person[@job='Actor' and @order='1'][1]/@name/string()" }
    XmlRole { name: "actor3"; query: "cast/person[@job='Actor' and @order='2'][1]/@name/string()" }
}
