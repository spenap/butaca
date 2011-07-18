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
import com.nokia.extras 1.0

Item {
    id: personDelegate
    width: personDelegate.ListView.view.width
    height: personDelegate.ListView.view.height

    Item {
        anchors.fill: parent
        anchors.margins: 10

        Text {
            id: nameText
            font.pixelSize: 26
            text: personName
            wrapMode: Text.WordWrap
        }

        Flickable {
            id: flick
            width: parent.width
            anchors.top: nameText.bottom; anchors.bottom: parent.bottom
            contentHeight: biographyText.height
            clip: true

            Row {
                spacing: 20
                width: parent.width

                Image {
                    id: image
                    width: 190
                    height: 280
                    source: profileImage ? profileImage : 'images/person-placeholder.svg'
                }

                Text {
                    id: biographyText
                    width: parent.width - image.width - 20
                    font.pixelSize: 20
                    text: biography
                    wrapMode: Text.WordWrap
                }
            }
        }
    }
}
