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

Page {

    tools: ToolBarLayout {
        ToolIcon {
            iconId: 'toolbar-back'
            onClicked: {
                appWindow.pageStack.pop()
            }
        }
    }

    orientationLock: PageOrientation.LockPortrait

    property alias showtimesModel: list.model
    property string cinemaName: ''
    property string cinemaInfo: ''

    ListView {
        id: list
        anchors.fill: parent
        clip: true
        header: Item {
            width: parent.width
            height: col.height + 2 * UIConstants.DEFAULT_MARGIN

            BorderImage {
                anchors.fill: parent
                source: 'qrc:/resources/view-header-fixed-inverted.png'
            }

            Column {
                id: col
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                    margins: UIConstants.DEFAULT_MARGIN
                }

                Label {
                    platformStyle: LabelStyle {
                        fontPixelSize: UIConstants.FONT_XLARGE
                    }
                    color: UIConstants.COLOR_INVERTED_FOREGROUND
                    width: parent.width
                    elide: Text.ElideRight
                    text: cinemaName
                }

                Label {
                    platformStyle: LabelStyle {
                        fontFamily: UIConstants.FONT_FAMILY_LIGHT
                        fontPixelSize: UIConstants.FONT_LSMALL
                    }
                    color: UIConstants.COLOR_SECONDARY_FOREGROUND
                    width: parent.width
                    wrapMode: Text.WordWrap

                    text: cinemaInfo
                }
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
    }

    ScrollDecorator {
        flickableItem: list
    }
}
