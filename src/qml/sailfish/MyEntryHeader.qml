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

Label {
    id: entryHeader

    property int headerFontSize: Theme.fontSizeMedium
    property string headerFontFamily: Theme.fontFamilyHeading
    property int headerWrapMode: Text.WordWrap

    font.pixelSize: headerFontSize
    font.family: headerFontFamily
    color: Theme.highlightColor
    wrapMode: headerWrapMode
}
