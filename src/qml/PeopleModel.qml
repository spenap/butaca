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

// See http://api.themoviedb.org/2.1/methods/Person.search
XmlListModel {
    property string personName: ''

    source: personName ? TheMovieDb.person_search(personName) : ''
    query: TheMovieDb.query_path(TheMovieDb.PERSON_SEARCH)

    XmlRole { name: "id"; query: "id/string()" }
    XmlRole { name: "name"; query: "name/string()" }
    XmlRole { name: "score"; query: "score/number()" }
    XmlRole { name: "popularity"; query: "popularity/number()" }
    XmlRole { name: "biography"; query: "biography/string()" }
    XmlRole { name: "url"; query: "url/string()" }
    XmlRole { name: "image"; query: "images/image[@size='thumb' and @type='profile'][1]/@url/string()" }
    XmlRole { name: "version"; query: "version/number()" }
    XmlRole { name: "lastModified"; query: "last_modified_at/string()" }
}
