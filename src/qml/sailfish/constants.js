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

.pragma library

.import Sailfish.Silica 1.0 as Silica

var COLOR_FOREGROUND            = Silica.Theme.primaryColor
var COLOR_INVERTED_FOREGROUND   = '#ffffff'
var COLOR_SECONDARY_FOREGROUND  = Silica.Theme.secondaryColor

var DEFAULT_MARGIN  = Silica.Theme.paddingLarge
var PADDING_LARGE   = Silica.Theme.paddingMedium
var PADDING_SMALL   = Silica.Theme.paddingSmall
var PADDING_XSMALL  = Silica.Theme.paddingSmall / 2

var FONT_FAMILY         = Silica.Theme.fontFamily
var FONT_FAMILY_BOLD    = Silica.Theme.fontFamily
var FONT_FAMILY_LIGHT   = Silica.Theme.fontFamily
var FONT_FAMILY_TABULAR = Silica.Theme.fontFamily

var FONT_XXXLARGE   = 42
var FONT_XXLARGE    = 36
var FONT_XLARGE     = 32
var FONT_LARGE      = 28
var FONT_SLARGE     = 26
var FONT_DEFAULT    = 24
var FONT_LSMALL     = 22
var FONT_SMALL      = 20
var FONT_XSMALL     = 18
var FONT_XXSMALL    = 16

var HEADER_DEFAULT_TOP_SPACING_LANDSCAPE    = 16
var HEADER_DEFAULT_TOP_SPACING_PORTRAIT     = 20
var HEADER_DEFAULT_HEIGHT_PORTRAIT          = 72
var HEADER_DEFAULT_HEIGHT_LANDSCAPE         = 52

var LIST_ITEM_HEIGHT_DEFAULT = Silica.Theme.itemSizeMedium
var LIST_ITEM_HEIGHT_SMALL = Silica.Theme.itemSizeSmall
var SIZE_ICON_LARGE = Silica.Theme.iconSizeMedium
