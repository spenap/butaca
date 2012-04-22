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
import com.nokia.extras 1.1
import 'butacautils.js' as Util
import 'constants.js' as UIConstants

Item {
    id: movieDelegate

    signal clicked()

    width: movieDelegate.ListView.view.width
    height: 140 + UIConstants.DEFAULT_MARGIN

    Item {
        anchors {
            fill: parent
            leftMargin: UIConstants.DEFAULT_MARGIN
            rightMargin: UIConstants.DEFAULT_MARGIN
        }

        BorderImage {
            id: background
            anchors {
                fill: parent
                leftMargin: -UIConstants.DEFAULT_MARGIN
                rightMargin: -UIConstants.DEFAULT_MARGIN
            }
            visible: mouseArea.pressed
            source: 'image://theme/meegotouch-list-fullwidth-inverted-background-pressed-vertical-center'
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
                top: parent.top
                topMargin: UIConstants.DEFAULT_MARGIN / 2
                bottom: parent.bottom
                bottomMargin: UIConstants.DEFAULT_MARGIN / 2
                right: viewDetails.left
                rightMargin: UIConstants.DEFAULT_MARGIN
                left: parent.left
            }

            Image {
                id: moviePoster
                width: 95
                height: 140
                fillMode: Image.PreserveAspectFit
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

                Label {
                    id: titleText
                    platformStyle: LabelStyle {
                        fontFamily: UIConstants.FONT_FAMILY_BOLD
                        fontPixelSize: UIConstants.FONT_SLARGE
                    }
                    color: UIConstants.COLOR_INVERTED_FOREGROUND
                    width: parent.width
                    elide: Text.ElideRight
                    textFormat: Text.StyledText
                    maximumLineCount: 2
                    wrapMode: Text.WordWrap
                    text: title
                }

                Label {
                    id: yearText
                    platformStyle: LabelStyle {
                        fontFamily: UIConstants.FONT_FAMILY_LIGHT
                        fontPixelSize: UIConstants.FONT_LSMALL
                    }
                    color: UIConstants.COLOR_SECONDARY_FOREGROUND
                    width: parent.width
                    text: '(' + Util.getYearFromDate(released) +')'
                }

                MyRatingIndicator {
                    ratingValue: rating / 2
                    maximumValue: 5
                    count: votes
                    inverted: theme.inverted
                }
            }
        }

        MyMoreIndicator {
            id: viewDetails
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
        }
    }
}
