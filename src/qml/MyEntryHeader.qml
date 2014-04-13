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
import com.nokia.meego 1.1
import 'constants.js' as UIConstants

Label {
    id: entryHeader

    property string headerText: ''
    property int headerFontWeight: Font.Bold
    property int headerFontSize: UIConstants.FONT_DEFAULT
    property string headerFontFamily: UIConstants.FONT_FAMILY_BOLD
    property int headerWrapMode: Text.WordWrap

    platformStyle: LabelStyle {
        fontPixelSize: headerFontSize
        fontFamily: headerFontFamily
    }
    font.weight: headerFontWeight
    wrapMode: headerWrapMode
    text: headerText
}
