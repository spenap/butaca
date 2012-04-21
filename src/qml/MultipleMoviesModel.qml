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

// See http://api.themoviedb.org/2.1/methods/Movie.search and
//     http://api.themoviedb.org/2.1/methods/Movie.browse
XmlListModel {
    XmlRole { name: "id"; query: "id/string()" }
    XmlRole { name: "imdb_id"; query: "imdb_id/string()" }
    XmlRole { name: "name"; query: "name/string()" }
    XmlRole { name: "original_name"; query: "original_name/string()" }
    XmlRole { name: "released"; query: "released/string()" }
    XmlRole { name: "rating"; query: "rating/number()" }
    XmlRole { name: "votes"; query: "votes/number()" }
    XmlRole { name: "overview"; query: "overview/string()" }
    XmlRole { name: "poster"; query: "images/image[@size='thumb' and @type='poster']/@url/string()" }
}
