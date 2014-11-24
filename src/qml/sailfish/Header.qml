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

Item {
    property alias text: headerText.text
    property string tagline
    property bool showDivider: false

    width: parent.width
    height: appWindow.inPortrait ?
                UIConstants.HEADER_DEFAULT_HEIGHT_PORTRAIT :
                UIConstants.HEADER_DEFAULT_HEIGHT_LANDSCAPE

    BorderImage {
        id: backgroundImage
        anchors.fill: parent
        source: 'qrc:/resources/view-header-fixed-inverted.png'
    }

    Label {
        id: headerText
//        platformStyle: LabelStyle {
//            fontPixelSize: UIConstants.FONT_XLARGE
//        }
        color: UIConstants.COLOR_INVERTED_FOREGROUND
        width: parent.width
        elide: Text.ElideRight
        anchors {
            left: parent.left
            leftMargin: UIConstants.DEFAULT_MARGIN
            verticalCenter: parent.verticalCenter
        }
    }
}
