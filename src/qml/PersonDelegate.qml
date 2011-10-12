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
import com.nokia.extras 1.0
import "butacautils.js" as BUTACA
import "file:///usr/lib/qt4/imports/com/meego/UIConstants.js" as UIConstants

Item {
    id: personDelegate
    width: personDelegate.ListView.view.width
    height: personDelegate.ListView.view.height

    FilmographyView { id: filmographyView }

    function formatPersonFilmography() {
        var movies = [ movie1 ]
        //: Filmography:
        var output = '<b>' + qsTr('btc-filmography') + '</b><br />'

        if (movies.indexOf(movie2) < 0) {
            movies.push(movie2)
        }
        if (movies.indexOf(movie3) < 0) {
            movies.push(movie3)
        }

        for (var i = 0; i < movies.length; i ++) {
            if (movies[i]) {
                output += movies[i]
                if (i < movies.length - 1) {
                    output += ', '
                } else {
                    output += '...'
                }
            }
        }
        return output
    }

    Flickable {
        id: flick
        anchors.fill: parent
        anchors {
            rightMargin: UIConstants.DEFAULT_MARGIN
            leftMargin: UIConstants.DEFAULT_MARGIN
        }

        contentHeight: nameText.height +
                       row.height +
                       filmography.height +
                       biographyText.height +
                       4 * UIConstants.DEFAULT_MARGIN

        ButacaHeader {
            id: nameText
            anchors.rightMargin: 0
            anchors.leftMargin: 0

            text: personName
        }

        Row {
            id: row
            spacing: 20
            width: parent.width
            anchors.top: nameText.bottom
            anchors.topMargin: UIConstants.DEFAULT_MARGIN

            Image {
                id: image
                width: 190
                height: 280
                source: profileImage ? profileImage : 'qrc:/resources/person-placeholder.svg'
                onStatusChanged: {
                    if (image.status == Image.Error) {
                        image.source = 'qrc:/resources/person-placeholder.svg'
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
                    font.family: "Nokia Pure Text Light"
                    color: (!theme.inverted ?
                               UIConstants.COLOR_FOREGROUND :
                               UIConstants.COLOR_INVERTED_FOREGROUND)
                    wrapMode: Text.WordWrap
                    //: Also known as:
                    text: '<b>' + qsTr('btc-also-known-as') + '</b><br />' +
                          (alternativeName ? alternativeName : ' - ')
                }
                Text {
                    id: birthdayText
                    width: parent.width
                    font.pixelSize: UIConstants.FONT_LSMALL
                    font.family: "Nokia Pure Text Light"
                    color: (!theme.inverted ?
                               UIConstants.COLOR_FOREGROUND :
                               UIConstants.COLOR_INVERTED_FOREGROUND)
                    wrapMode: Text.WordWrap
                    //: Birthday:
                    text: '<b>' + qsTr('btc-birthday') + '</b>' +
                          (birthday ? birthday : ' - ')
                }

                Text {
                    id: birthplaceText
                    width: parent.width
                    font.pixelSize: UIConstants.FONT_LSMALL
                    font.family: "Nokia Pure Text Light"
                    color: (!theme.inverted ?
                               UIConstants.COLOR_FOREGROUND :
                               UIConstants.COLOR_INVERTED_FOREGROUND)
                    wrapMode: Text.WordWrap
                    //: Birthplace:
                    text: '<b>' + qsTr('btc-birthplace') + '</b><br />' +
                          (birthplace ? birthplace : ' - ')
                }

                Text {
                    id: knownMoviesText
                    width: parent.width
                    font.pixelSize: UIConstants.FONT_LSMALL
                    font.family: "Nokia Pure Text Light"
                    color: (!theme.inverted ?
                               UIConstants.COLOR_FOREGROUND :
                               UIConstants.COLOR_INVERTED_FOREGROUND)
                    wrapMode: Text.WordWrap
                    //: Known movies:
                    text: '<b>' + qsTr('btc-known-movies') + '</b> ' +
                          (knownMovies ? knownMovies : ' - ')
                }
            }
        }

        Text {
            id: filmography
            anchors.top: row.bottom
            anchors.topMargin: 20

            width: parent.width - filmographyDetails.width
            font.pixelSize: UIConstants.FONT_LSMALL
            font.family: UIConstants.FONT_FAMILY
            color: !theme.inverted ?
                       UIConstants.COLOR_FOREGROUND :
                       UIConstants.COLOR_INVERTED_FOREGROUND
            wrapMode: Text.WordWrap
            text: formatPersonFilmography()
            opacity: filmographyMouseArea.pressed ? 0.5 : 1

            Image {
                id: filmographyDetails
                anchors.top: parent.top
                anchors.right: parent.right
                source: 'image://theme/icon-s-music-video-description'
            }

            MouseArea {
                id: filmographyMouseArea
                anchors.fill: filmography
                onClicked: {
                    appWindow.pageStack.push(filmographyView,
                                             { person: personName,
                                               personId: personId })
                }
            }
        }

        Text {
            id: biographyText
            anchors.top: filmography.bottom
            anchors.topMargin: 20
            width: parent.width
            font.pixelSize: UIConstants.FONT_LSMALL
            font.family: UIConstants.FONT_FAMILY
            color: (!theme.inverted ?
                       UIConstants.COLOR_FOREGROUND :
                       UIConstants.COLOR_INVERTED_FOREGROUND)
            //: Biography:
            text: '<b>' + qsTr('btc-biography') + '</b><br />' +
                  //: Biography not found
                  (biography ? BUTACA.sanitizeText(biography) : qsTr('btc-biography-not-found'))
            wrapMode: Text.WordWrap
        }
    }

    ScrollDecorator {
        flickableItem: flick
        anchors.rightMargin: -UIConstants.DEFAULT_MARGIN
    }
}
