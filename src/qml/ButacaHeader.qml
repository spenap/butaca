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
import com.nokia.meego 1.0
import 'constants.js' as UIConstants

Item {
    property alias text: headerText.text
    property string tagline
    property alias showDivider: headerDivider.visible

    anchors { left: parent.left; right: parent.right }
    anchors {
        leftMargin: UIConstants.DEFAULT_MARGIN
        rightMargin: UIConstants.DEFAULT_MARGIN
    }

    height: visible ?
                (headerText.height +
                 (subheaderText.visible ?
                      subheaderText.height :
                      0) +
                 (headerDivider.visible ?
                      headerDivider.height + UIConstants.DEFAULT_MARGIN :
                      0)) :
                0

    Text {
        id: headerText
        font.pixelSize: UIConstants.FONT_XLARGE
        font.family: UIConstants.FONT_FAMILY
        color: !theme.inverted ?
                   UIConstants.COLOR_FOREGROUND :
                   UIConstants.COLOR_INVERTED_FOREGROUND
        width: parent.width
        wrapMode: Text.WordWrap
    }

    Text {
        id: subheaderText
        anchors.top: headerText.bottom
        anchors.topMargin: UIConstants.DEFAULT_MARGIN
        font.pixelSize: UIConstants.FONT_DEFAULT
        font.family: "Nokia Pure Text Light"
        color: !theme.inverted ?
                   UIConstants.COLOR_FOREGROUND :
                   UIConstants.COLOR_INVERTED_FOREGROUND
        text: '<i>' + tagline + '</i>'
        wrapMode: Text.WordWrap
        visible: tagline
    }

    Rectangle {
        id: headerDivider
        anchors {
            top: subheaderText.visible ? subheaderText.bottom : headerText.bottom
            left: parent.left
            right: parent.right
        }
        anchors.topMargin: UIConstants.DEFAULT_MARGIN
        height: 1
        color: UIConstants.COLOR_SECONDARY_FOREGROUND
    }
}
