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
import com.nokia.extras 1.0
import "butacautils.js" as BUTACA
import 'constants.js' as UIConstants

Item {
    id: movieDelegate

    signal clicked

    property int titleSize: UIConstants.FONT_SLARGE
    property int titleWeight: Font.Bold
    property color titleColor: theme.inverted ?
                                   UIConstants.COLOR_INVERTED_FOREGROUND :
                                   UIConstants.COLOR_FOREGROUND

    property int subtitleSize: UIConstants.FONT_LSMALL
    property int subtitleWeight: Font.Light
    property color subtitleColor: UIConstants.COLOR_SECONDARY_FOREGROUND

    width: movieDelegate.ListView.view.width
    height: 140 + UIConstants.DEFAULT_MARGIN

    Item {
        anchors.fill: parent
        anchors {
            leftMargin: UIConstants.DEFAULT_MARGIN
            rightMargin: UIConstants.DEFAULT_MARGIN
        }

        BorderImage {
            id: background
            anchors.fill: parent
            anchors.leftMargin: -UIConstants.DEFAULT_MARGIN
            anchors.rightMargin: -UIConstants.DEFAULT_MARGIN
            visible: mouseArea.pressed
            source: theme.inverted ?
                        'image://theme/meegotouch-list-fullwidth-inverted-background-pressed-vertical-center' :
                        'image://theme/meegotouch-list-fullwidth-background-pressed-vertical-center'
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            onClicked: movieDelegate.clicked()
        }

        Row {
            id: content
            spacing: 15
            anchors {
                topMargin: UIConstants.DEFAULT_MARGIN / 2
                bottomMargin: UIConstants.DEFAULT_MARGIN / 2
                rightMargin: UIConstants.DEFAULT_MARGIN
            }
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
                right: viewDetails.left
            }

            Image {
                id: moviePoster
                width: 95
                height: 140
                source: poster ? poster : 'qrc:/resources/movie-placeholder.svg'
                onStatusChanged: {
                    if (moviePoster.status == Image.Error) {
                        moviePoster.source = 'qrc:/resources/movie-placeholder.svg'
                    }
                }
            }

            Column {
                width: parent.width - moviePoster.width - 15
                height: parent.height
                spacing: 10

                Text {
                    id: titleText
                    width: parent.width
                    elide: Text.ElideRight
                    textFormat: Text.StyledText
                    font.weight: movieDelegate.titleWeight
                    font.pixelSize: movieDelegate.titleSize
                    font.family: UIConstants.FONT_FAMILY
                    color: movieDelegate.titleColor
                    maximumLineCount: 3
                    wrapMode: Text.WordWrap
                    text: title
                }

                Text {
                    id: yearText
                    width: parent.width
                    font.weight: movieDelegate.subtitleWeight
                    font.pixelSize: movieDelegate.subtitleSize
                    font.family: UIConstants.FONT_FAMILY
                    color: movieDelegate.subtitleColor
                    text: '(' + BUTACA.getYearFromDate(released) +')'
                }

                RatingIndicator {
                    ratingValue: rating / 2
                    maximumValue: 5
                    count: votes
                    inverted: theme.inverted
                }
            }
        }

        CustomMoreIndicator {
            id: viewDetails
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
        }
    }
}
