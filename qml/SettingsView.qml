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
import "file:///usr/lib/qt4/imports/com/meego/UIConstants.js" as UIConstants
import "file:///usr/lib/qt4/imports/com/nokia/extras/constants.js" as ExtrasConstants
import "butacautils.js" as BUTACA

Component {
    id: settingsView

    Page {
        tools: commonTools
        orientationLock: PageOrientation.LockPortrait

        Item {
            anchors.fill: parent
            anchors {
                leftMargin: UIConstants.DEFAULT_MARGIN
                rightMargin: UIConstants.DEFAULT_MARGIN
                bottomMargin: UIConstants.DEFAULT_MARGIN
            }

            ButacaHeader {
                id: header
                anchors.top: parent.top
                width: parent.width

                text: 'Settings'
            }

            Item {
                id: settingsContent
                anchors {
                    top: header.bottom;
                    left: parent.left;
                    right: parent.right;
                    bottom:  parent.bottom
                }

                ListSectionDelegate {
                    id: showtimesSection
                    anchors.top: parent.top
                    anchors.topMargin: UIConstants.DEFAULT_MARGIN
                    sectionName: 'Showtimes'
                }

                Row {
                    id: showtimesLocation
                    anchors.top: showtimesSection.bottom
                    anchors.topMargin: UIConstants.DEFAULT_MARGIN
                    spacing: UIConstants.DEFAULT_MARGIN
                    width: parent.width

                    Text {
                        id: locationText
                        text: 'Default location'
                        font.pixelSize: UIConstants.FONT_DEFAULT
                        color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                        anchors.verticalCenter: locationInput.verticalCenter
                    }

                    TextField {
                        id: locationInput
                        placeholderText: ''
                        width: parent.width - locationText.width - parent.spacing
                    }
                }

                ListSectionDelegate {
                    id: browsingSection
                    anchors.top: showtimesLocation.bottom
                    anchors.topMargin: UIConstants.DEFAULT_MARGIN
                    sectionName: 'Browsing'
                }

                Item {
                    id: orderCriteria
                    anchors.top: browsingSection.bottom
                    anchors.topMargin: UIConstants.DEFAULT_MARGIN / 2
                    width: parent.width
                    height: childrenRect.height

                    Text {
                        id: criteriaText
                        anchors.top:  parent.top
                        text: 'Order criteria'
                        font.pixelSize: UIConstants.FONT_DEFAULT
                        color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                    }

                    ButtonColumn {
                        id: criteriaOptions
                        anchors { top: criteriaText.bottom; right: parent.right }
                        anchors.topMargin: UIConstants.DEFAULT_MARGIN / 2

                        Button {
                            id: byRating
                            text: 'Rating'
                        }
                        Button {
                            id: byRelease
                            text: 'Release'
                        }
                        Button {
                            id: byTitle
                            text: 'Title'
                        }
                    }
                }

                Item {
                    id: sortOrder
                    anchors.top: orderCriteria.bottom
                    anchors.topMargin: UIConstants.DEFAULT_MARGIN
                    width: parent.width
                    height: childrenRect.height

                    Text {
                        id: sortOrderText
                        anchors.top:  parent.top
                        text: 'Order criteria'
                        font.pixelSize: UIConstants.FONT_DEFAULT
                        color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                    }

                    ButtonColumn {
                        id: sortOrderOptions
                        anchors { top: sortOrderText.bottom; right: parent.right }
                        anchors.topMargin: UIConstants.DEFAULT_MARGIN / 2

                        Button {
                            id: sortAscending
                            text: 'Ascending'
                        }
                        Button {
                            id: sortDescending
                            text: 'Descending'
                        }
                    }
                }

                Item {
                    id: resultsPerPage
                    anchors.top: sortOrder.bottom
                    anchors.topMargin: UIConstants.DEFAULT_MARGIN
                    width: parent.width
                    height: childrenRect.height

                    Text {
                        id: resultsPerPageText
                        text: 'Results per page'
                        font.pixelSize: UIConstants.FONT_DEFAULT
                        color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                        anchors.verticalCenter: resultsPerPageInput.verticalCenter
                        anchors.left: parent.left
                    }

                    TextField {
                        id: resultsPerPageInput
                        anchors.right: parent.right
                        text: '10'
                        width: 100
                    }
                }

                Item {
                    id: minVotes
                    anchors.top: resultsPerPage.bottom
                    anchors.topMargin: UIConstants.DEFAULT_MARGIN
                    width: parent.width
                    height: childrenRect.height

                    Text {
                        id: minVotesText
                        text: 'Minimum votes'
                        font.pixelSize: UIConstants.FONT_DEFAULT
                        color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                        anchors.verticalCenter: minVotesInput.verticalCenter
                        anchors.left: parent.left
                    }

                    TextField {
                        id: minVotesInput
                        anchors.right: parent.right
                        text: '0'
                        width: 100
                    }
                }
            }
        }
    }
}
