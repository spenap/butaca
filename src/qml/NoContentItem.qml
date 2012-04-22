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
import com.nokia.meego 1.0
import 'constants.js' as UIConstants

Item {
    property alias text: noContentText.text

    Label {
        id: noContentText
        platformStyle: LabelStyle {
            fontPixelSize: UIConstants.FONT_XLARGE
        }
        color: !theme.inverted ?
                   UIConstants.COLOR_FOREGROUND :
                   UIConstants.COLOR_INVERTED_FOREGROUND
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.Wrap
        anchors.centerIn: parent
        opacity: 0.5
    }
}
