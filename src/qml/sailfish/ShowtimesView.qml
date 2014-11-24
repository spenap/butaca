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

import QtQuick 2.0
import Sailfish.Silica 1.0
import 'constants.js' as UIConstants

Page {
    allowedOrientations: Orientation.Portrait

    property alias showtimesModel: list.model
    property string cinemaName: ''
    property string cinemaInfo: ''

    SilicaListView {
        id: list
        anchors.fill: parent
        clip: true
        header: Column {
            id: col
            width: parent.width

            PageHeader {
                title: cinemaName
            }

            Label {
                color: UIConstants.COLOR_SECONDARY_FOREGROUND
                anchors.left: parent.left
                anchors.leftMargin: UIConstants.DEFAULT_MARGIN
                anchors.right: parent.right
                anchors.rightMargin: UIConstants.DEFAULT_MARGIN
                wrapMode: Text.WordWrap

                text: cinemaInfo
            }
            // hack some space
            Item {
                height: UIConstants.DEFAULT_MARGIN
            }
        }
        delegate: MyListDelegate {
            width: parent.width
            title: model.name
            titleWraps: true
            subtitle: model.showtimes
            subtitleSize: UIConstants.FONT_SMALL
            subtitleWraps: true

            onClicked: {
                if (model.movieImdbId)
                    appWindow.pageStack.push(movieView, { imdbId: model.imdbId, loading: true })
                else
                    appWindow.pageStack.push(searchView, { searchTerm: model.name })
            }
        }

        VerticalScrollDecorator { }
    }
}
