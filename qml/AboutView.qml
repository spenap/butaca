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
import "file:///usr/lib/qt4/imports/com/meego/UIConstants.js" as UIConstants
import "file:///usr/lib/qt4/imports/com/nokia/extras/constants.js" as ExtrasConstants

Component {
    id: aboutView

    Page {
        property string license: '<i>This program is free software: you can redistribute it and/or modify ' +
            'it under the terms of the GNU General Public License as published by ' +
            'the Free Software Foundation, either version 3 of the License, or ' +
            '(at your option) any later version.<br /><br />' +

            'This package is distributed in the hope that it will be useful, ' +
            'but WITHOUT ANY WARRANTY; without even the implied warranty of ' +
            'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the ' +
            'GNU General Public License for more details.<br /><br />' +

            'You should have received a copy of the GNU General Public License ' +
            'along with this program. If not, see ' +
            '<a href="http://www.gnu.org/licenses">http://www.gnu.org/licenses</a></i><br /><br />'

        tools: ToolBarLayout {
            ToolIcon {
                id: backIcon
                iconId: 'toolbar-back'
                onClicked: pageStack.pop()
            }
        }
        orientationLock: PageOrientation.LockPortrait

        Flickable {
            id: flick
            anchors.fill: parent
            anchors {
                topMargin: appWindow.inPortrait?
                              UIConstants.HEADER_DEFAULT_TOP_SPACING_PORTRAIT :
                              UIConstants.HEADER_DEFAULT_TOP_SPACING_LANDSCAPE
                leftMargin: UIConstants.DEFAULT_MARGIN
                rightMargin: UIConstants.DEFAULT_MARGIN
            }

            contentHeight: aboutImage.height +
                           aboutVersion.height +
                           aboutCopyright.height +
                           aboutContact.height +
                           aboutThemovieDb.height +
                           aboutAfterCreditsDisclaimer.height +
                           aboutShowtimesDisclaimer.height +
                           aboutLicense.height +
                           UIConstants.DEFAULT_MARGIN * 4

            Image {
                id: aboutImage
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                source: 'qrc:/butaca.svg'
            }

            Text {
                id: aboutVersion
                text: 'Butaca 0.3.4'
                anchors.top: aboutImage.bottom
                anchors.topMargin: UIConstants.DEFAULT_MARGIN
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: UIConstants.FONT_XLARGE
                color: !theme.inverted ?
                           UIConstants.COLOR_FOREGROUND :
                           UIConstants.COLOR_INVERTED_FOREGROUND
            }

            Text {
                id: aboutCopyright
                text: 'Copyright © 2011 Simon Pena'
                anchors.top: aboutVersion.bottom
                anchors.topMargin: UIConstants.DEFAULT_MARGIN
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: UIConstants.FONT_XLARGE
                color: !theme.inverted ?
                           UIConstants.COLOR_FOREGROUND :
                           UIConstants.COLOR_INVERTED_FOREGROUND
            }

            Text {
                id: aboutContact
                anchors.top: aboutCopyright.bottom
                anchors.topMargin: UIConstants.DEFAULT_MARGIN
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: UIConstants.FONT_LSMALL
                color: !theme.inverted ?
                           UIConstants.COLOR_FOREGROUND :
                           UIConstants.COLOR_INVERTED_FOREGROUND
                text: '<a href="mailto:spena@igalia.com">spena@igalia.com</a> | ' +
                      '<a href="http://www.simonpena.com">simonpena.com</a>'
                onLinkActivated: Qt.openUrlExternally(link)
            }

            Item {
                id: aboutThemovieDb
                anchors.top: aboutContact.bottom
                anchors.topMargin: UIConstants.DEFAULT_MARGIN
                width: parent.width
                height: childrenRect.height

                Image {
                    id: aboutThemovieDbImage
                    anchors.top: parent.top
                    source: 'qrc:/tmdb-logo.png'
                }

                Text {
                    id: aboutThemovieDbDisclaimer
                    anchors.top: aboutThemovieDbImage.bottom
                    font.pixelSize: UIConstants.FONT_LSMALL
                    color: !theme.inverted ?
                               UIConstants.COLOR_FOREGROUND :
                               UIConstants.COLOR_INVERTED_FOREGROUND
                    width: parent.width
                    wrapMode: Text.WordWrap
                    text: 'This product uses the <a href="http://www.themoviedb.org/">TMDb</a> API but is not endorsed or certified by TMDb.'
                    onLinkActivated: Qt.openUrlExternally(link)
                }
            }

            Text {
                id: aboutAfterCreditsDisclaimer
                anchors.top: aboutThemovieDb.bottom
                anchors.topMargin: UIConstants.DEFAULT_MARGIN
                font.pixelSize: UIConstants.FONT_LSMALL
                color: !theme.inverted ?
                           UIConstants.COLOR_FOREGROUND :
                           UIConstants.COLOR_INVERTED_FOREGROUND
                width: parent.width
                wrapMode: Text.WordWrap
                text: 'This product uses <a href="http://aftercredits.com/">What\'s After The Credits?</a> API but is not endorsed or certified by them.'
                onLinkActivated: Qt.openUrlExternally(link)
            }

            Text {
                id: aboutShowtimesDisclaimer
                anchors.top: aboutAfterCreditsDisclaimer.bottom
                anchors.topMargin: UIConstants.DEFAULT_MARGIN
                font.pixelSize: UIConstants.FONT_LSMALL
                color: !theme.inverted ?
                           UIConstants.COLOR_FOREGROUND :
                           UIConstants.COLOR_INVERTED_FOREGROUND
                width: parent.width
                wrapMode: Text.WordWrap
                text: 'This product presents showtimes from <a href="http://www.google.com/movies">Google Movies</a> but is not endorsed or certified by Google.'
                onLinkActivated: Qt.openUrlExternally(link)
            }

            Text {
                id: aboutLicense
                anchors.top: aboutShowtimesDisclaimer.bottom
                anchors.topMargin: UIConstants.DEFAULT_MARGIN
                font.pixelSize: UIConstants.FONT_LSMALL
                color: !theme.inverted ?
                           UIConstants.COLOR_FOREGROUND :
                           UIConstants.COLOR_INVERTED_FOREGROUND
                width: parent.width
                wrapMode: Text.WordWrap
                text: license
                onLinkActivated: Qt.openUrlExternally(link)
            }
        }

        ScrollDecorator {
            flickableItem: flick
            anchors.rightMargin: -UIConstants.DEFAULT_MARGIN
        }
    }
}
