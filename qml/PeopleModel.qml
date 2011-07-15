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
import com.meego 1.0

XmlListModel {

    property string apiKey: '249e1a42df9bee09fac5e92d3a51396b'
    property string baseUrl: 'http://api.themoviedb.org/2.1/'
    property string language: 'en'
    property string format: 'xml'
    property string apiMethod: 'Person.search'
    property string params: ''

    source: baseUrl + apiMethod + '/' + language + '/' + format + '/'+ apiKey + params
    query: '/OpenSearchDescription/people/person'

    XmlRole { name: "personId"; query: "id/string()" }
    XmlRole { name: "personName"; query: "name/string()" }
    XmlRole { name: "popularity"; query: "popularity/number()" }
    XmlRole { name: "score"; query: "score/number()" }
    XmlRole { name: "biography"; query: "biography/string()" }
    XmlRole { name: "url"; query: "url/string()" }
    XmlRole { name: "version"; query: "version/number()" }
    XmlRole { name: "image"; query: "images/image[@size='thumb' and @type='profile'][1]/@url/string()" }
    XmlRole { name: "lastModified"; query: "last_modified_at/string()" }
}
