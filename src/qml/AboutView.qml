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
        property string license: 'This program is free software: you can redistribute it and/or modify ' +
            'it under the terms of the GNU General Public License as published by ' +
            'the Free Software Foundation, either version 3 of the License, or ' +
            '(at your option) any later version.<br /><br />' +

            'This package is distributed in the hope that it will be useful, ' +
            'but WITHOUT ANY WARRANTY; without even the implied warranty of ' +
            'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the ' +
            'GNU General Public License for more details.<br /><br />' +

            'You should have received a copy of the GNU General Public License ' +
            'along with this program. If not, see ' +
            '<a href="http://www.gnu.org/licenses">http://www.gnu.org/licenses</a><br /><br />'
        property string credits: 'L10n credits:<br />' +
                                      '<ul>'+
                                      '<li>Nik Rolls - English (en_GB)</li>' +
                                      '<li>Christoph Keller - German (de)</li>' +
                                      '<li>Janne Makinen - Finnish (fi)</li>' +
                                      '<li>Alexandre Mazari - French (fr_FR)</li>' +
                                      '<li>Petru Motrescu - Romanian (ro)</li>' +
                                      '<li>Oytun Şengül, Ismail Coskuner, Aras Ergus - Turkish (tr)</li>' +
                                      '<li>Joaquim Rocha - Portuguese (pt)</li>' +
                                      '</ul>'

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

            contentHeight: contentColumn.height

            Column {
                id: contentColumn
                spacing: UIConstants.DEFAULT_MARGIN
                width: parent.width

                Image {
                    id: aboutImage
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: 'qrc:/resources/butaca.svg'
                }

                Text {
                    id: aboutVersion
                    text: 'Butaca 0.4.1'
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: UIConstants.FONT_XLARGE
                    font.family: UIConstants.FONT_FAMILY
                    color: !theme.inverted ?
                               UIConstants.COLOR_FOREGROUND :
                               UIConstants.COLOR_INVERTED_FOREGROUND
                }

                Text {
                    id: aboutCopyright
                    text: 'Copyright © 2011 Simon Pena'
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: UIConstants.FONT_XLARGE
                    font.family: "Nokia Pure Text Light"
                    color: !theme.inverted ?
                               UIConstants.COLOR_FOREGROUND :
                               UIConstants.COLOR_INVERTED_FOREGROUND
                }

                Text {
                    id: aboutContact
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: UIConstants.FONT_LSMALL
                    font.family: UIConstants.FONT_FAMILY
                    color: !theme.inverted ?
                               UIConstants.COLOR_FOREGROUND :
                               UIConstants.COLOR_INVERTED_FOREGROUND
                    text: '<a href="mailto:spena@igalia.com">spena@igalia.com</a> | ' +
                          '<a href="http://www.simonpena.com/?utm_source=harmattan&utm_medium=apps&utm_campaign=butaca">simonpena.com</a>'
                    onLinkActivated: Qt.openUrlExternally(link)
                }

                Item {
                    id: aboutThemovieDb
                    width: parent.width
                    height: childrenRect.height

                    Image {
                        id: aboutThemovieDbImage
                        anchors.top: parent.top
                        source: 'qrc:/resources/tmdb-logo.png'
                    }

                    Text {
                        id: aboutThemovieDbDisclaimer
                        anchors.top: aboutThemovieDbImage.bottom
                        font.pixelSize: UIConstants.FONT_LSMALL
                        font.family: UIConstants.FONT_FAMILY
                        color: !theme.inverted ?
                                   UIConstants.COLOR_FOREGROUND :
                                   UIConstants.COLOR_INVERTED_FOREGROUND
                        width: parent.width
                        wrapMode: Text.WordWrap
                        //: This product uses the <a href="http://www.themoviedb.org/">TMDb</a> API but is not endorsed or certified by TMDb.
                        text: qsTr('btc-themoviedb-disclaimer')
                        onLinkActivated: Qt.openUrlExternally(link)
                    }
                }

                Text {
                    id: aboutAfterCreditsDisclaimer
                    font.pixelSize: UIConstants.FONT_LSMALL
                    font.family: UIConstants.FONT_FAMILY
                    color: !theme.inverted ?
                               UIConstants.COLOR_FOREGROUND :
                               UIConstants.COLOR_INVERTED_FOREGROUND
                    width: parent.width
                    wrapMode: Text.WordWrap
                    //: This product uses <a href="http://aftercredits.com/">What\'s After The Credits?</a> API but is not endorsed or certified by them.
                    text: qsTr('btc-aftercredits-disclaimer')
                    onLinkActivated: Qt.openUrlExternally(link)
                }

                Text {
                    id: aboutShowtimesDisclaimer
                    font.pixelSize: UIConstants.FONT_LSMALL
                    font.family: UIConstants.FONT_FAMILY
                    color: !theme.inverted ?
                               UIConstants.COLOR_FOREGROUND :
                               UIConstants.COLOR_INVERTED_FOREGROUND
                    width: parent.width
                    wrapMode: Text.WordWrap
                    //: This product presents showtimes from <a href="http://www.google.com/movies">Google Movies</a> but is not endorsed or certified by Google.
                    text: qsTr('btc-showtimes-disclaimer')
                    onLinkActivated: Qt.openUrlExternally(link)
                }


                Button {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr('Credits')
                    onClicked: {
                        dialog.titleText = qsTr('Credits')
                        dialog.message = credits
                        dialog.open()
                    }
                }

                Button {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr('License')
                    onClicked: {
                        dialog.titleText = qsTr('License')
                        dialog.message = license
                        dialog.open()
                    }
                }
            }
        }

        ScrollDecorator {
            flickableItem: flick
            anchors.rightMargin: -UIConstants.DEFAULT_MARGIN
        }

        QueryDialog {
            id: dialog
            acceptButtonText: qsTr('OK')
        }
    }
}
