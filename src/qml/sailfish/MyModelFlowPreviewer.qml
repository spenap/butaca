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


Column {
    id: flwt

    property ListModel flowModel
    property string previewedField: ''
    property int previewedItems: flowModel.count
    property string title: ''

    anchors {
        left: parent.left
        right: parent.right
        leftMargin: Theme.paddingLarge
        rightMargin: Theme.paddingLarge
    }
    visible: flowModel.count > 0

    MyEntryHeader {
        width: parent.width
        //: Label acting as the header for the genres
        text: title
    }

    Flow {
        id: flowPreviewer
        width: parent.width

        property alias previewedItems: flwt.previewedItems
        property alias previewedField: flwt.previewedField

        Repeater {
            model: previewedItems
            delegate: Label {
                    font.pixelSize: Theme.fontSizeSmall
                    text: flwt.flowModel.get(index)[previewedField] + (index !== previewedItems - 1 ? ', ' : '')
                }
        }
    }
}
