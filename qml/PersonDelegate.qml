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
import com.meego 1.0
import com.nokia.extras 1.0
import "file:///usr/lib/qt4/imports/com/meego/UIConstants.js" as UIConstants

Item {
    id: personDelegate
    width: personDelegate.ListView.view.width
    height: personDelegate.ListView.view.height

    FilmographyView { id: filmographyView }

    Item {
        anchors.fill: parent
        anchors.margins: UIConstants.DEFAULT_MARGIN

        ButacaHeader {
            id: nameText
            anchors.top: parent.top
            width: parent.width

            text: personName
        }

        Flickable {
            id: flick
            anchors.top: nameText.bottom
            anchors.bottom: parent.bottom
            anchors.margins: 20

            width: parent.width
            contentHeight: row.height + biographyText.height + 20
            clip: true

            Row {
                id: row
                spacing: 20
                width: parent.width

                Image {
                    id: image
                    width: 190
                    height: 280
                    source: profileImage ? profileImage : 'images/person-placeholder.svg'
                    onStatusChanged: {
                        if (image.status == Image.Error) {
                            image.source = 'images/person-placeholder.svg'
                        }
                    }
                }

                Column {
                    width: parent.width - image.width
                    spacing: 8

                    Text {
                        id: akaText
                        width: parent.width
                        font.pixelSize: UIConstants.FONT_LSMALL
                        color: !theme.inverted ?
                                   UIConstants.COLOR_FOREGROUND :
                                   UIConstants.COLOR_INVERTED_FOREGROUND
                        wrapMode: Text.WordWrap
                        text: '<b>Also known as:</b><br />' +
                              (alternativeName ? alternativeName : ' - ')
                    }
                    Text {
                        id: birthdayText
                        width: parent.width
                        font.pixelSize: UIConstants.FONT_LSMALL
                        color: !theme.inverted ?
                                   UIConstants.COLOR_FOREGROUND :
                                   UIConstants.COLOR_INVERTED_FOREGROUND
                        wrapMode: Text.WordWrap
                        text: '<b>Birthday:</b> ' +
                              (birthday ? birthday : ' - ')
                    }

                    Text {
                        id: birthplaceText
                        width: parent.width
                        font.pixelSize: UIConstants.FONT_LSMALL
                        color: !theme.inverted ?
                                   UIConstants.COLOR_FOREGROUND :
                                   UIConstants.COLOR_INVERTED_FOREGROUND
                        wrapMode: Text.WordWrap
                        text: '<b>Birthplace:</b><br />' +
                              (birthplace ? birthplace : ' - ')
                    }

                    Text {
                        id: knownMoviesText
                        width: parent.width
                        font.pixelSize: UIConstants.FONT_LSMALL
                        color: !theme.inverted ?
                                   UIConstants.COLOR_FOREGROUND :
                                   UIConstants.COLOR_INVERTED_FOREGROUND
                        wrapMode: Text.WordWrap
                        text: '<b>Known movies:</b> ' +
                              (knownMovies ? knownMovies : ' - ')
                    }
                }

                /* Disable filmography temporarily */
//                    MouseArea {
//                        anchors.fill: personFacts
//                        onClicked: {
//                            appWindow.pageStack.push(filmographyView, { person: personName, personId: personId })
//                        }
//                    }
            }

            Text {
                id: biographyText
                anchors.top: row.bottom
                anchors.topMargin: 20
                width: parent.width
                font.pixelSize: UIConstants.FONT_SMALL
                color: !theme.inverted ?
                           UIConstants.COLOR_FOREGROUND :
                           UIConstants.COLOR_INVERTED_FOREGROUND
                text: '<b>Biography:</b><br />' +
                      (biography ? biography : 'Biography not found')
                wrapMode: Text.WordWrap
            }
        }

        ScrollDecorator {
            flickableItem: flick
        }
    }
}
