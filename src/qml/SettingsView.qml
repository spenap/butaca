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
import 'constants.js' as UIConstants
import "storage.js" as Storage

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

    Component.onCompleted: {
        Storage.initialize()
        var orderBy = Storage.getSetting('orderBy', 'rating')
        var order = Storage.getSetting('order', 'desc')

        if (orderBy === 'title') {
            criteriaOptions.checkedButton = byTitle
        } else if (orderBy === 'release') {
            criteriaOptions.checkedButton = byRelease
        } else {
            criteriaOptions.checkedButton = byRating
        }

        if (order === 'asc') {
            sortOrderOptions.checkedButton = sortAscending
        } else {
            sortOrderOptions.checkedButton = sortDescending
        }
    }

    Component.onDestruction: {
        Storage.setSetting('location', locationInput.text)
        Storage.setSetting('minVotes', minVotesInput.text)
        Storage.setSetting('perPage', resultsPerPageInput.text)
    }

    Flickable {
        id: settingsContent
        anchors {
            fill: parent
            leftMargin: UIConstants.DEFAULT_MARGIN
            rightMargin: UIConstants.DEFAULT_MARGIN
        }
        width: parent.width
        contentHeight: settingsColumnContent.height

        Column {
            id: settingsColumnContent
            width: parent.width
            spacing: UIConstants.DEFAULT_MARGIN

            Header {
                id: settingsHeader
                anchors { rightMargin: 0; leftMargin: 0 }
                //: Text shown in the settings view header
                //% "Settings"
                text: qsTrId('btc-settings-header')
                showDivider: false
            }

            ListSectionDelegate {
                id: showtimesSection
                anchors { rightMargin: 0; leftMargin: 0 }
                //: Label for the showtimes section in the settings view
                //% "Showtimes"
                sectionName: qsTrId('btc-settings-showtimes')
            }

            Row {
                id: showtimesLocation
                spacing: UIConstants.DEFAULT_MARGIN
                width: parent.width

                Label {
                    id: locationText
                    anchors.verticalCenter: locationInput.verticalCenter
                    platformStyle: LabelStyle {
                        fontPixelSize: UIConstants.FONT_DEFAULT
                    }
                    color: UIConstants.COLOR_INVERTED_FOREGROUND
                    //: Label for the default location setting to try for showtimes
                    //% "Default location"
                    text: qsTrId('btc-settings-default-location')
                }

                TextField {
                    id: locationInput
                    //: Placeholder text for the default location. When visible, automatic location will be attempted
                    //% "Try automatically"
                    placeholderText: qsTrId('btc-settings-locate-automatically')
                    width: parent.width - locationText.width - parent.spacing
                    text: Storage.getSetting('location', '')
                    Keys.onReturnPressed: {
                        Storage.setSetting('location', text)
                    }

                    Image {
                        id: clearLocationText
                        anchors {
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                        }
                        source: 'image://theme/icon-m-input-clear'
                        visible: locationInput.activeFocus
                    }

                    MouseArea {
                        id: locationInputMouseArea
                        anchors.fill: clearLocationText
                        onClicked: {
                            inputContext.reset()
                            locationInput.text = ''
                        }
                    }
                }
            }

            ListSectionDelegate {
                id: browsingSection
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                //: Label for the browsing section in the settings view
                //% "Browsing"
                sectionName: qsTrId('btc-settings-browsing')
            }

            Item {
                id: orderCriteria
                width: parent.width
                height: childrenRect.height

                Label {
                    id: criteriaText
                    anchors.top:  parent.top
                    platformStyle: LabelStyle {
                        fontPixelSize: UIConstants.FONT_DEFAULT
                    }
                    //: Label for the order criteria setting used when browsing
                    //% "Order criteria"
                    text: qsTrId('btc-settings-order-criteria')
                    color: UIConstants.COLOR_INVERTED_FOREGROUND
                }

                ButtonColumn {
                    id: criteriaOptions
                    anchors {
                        top: criteriaText.bottom
                        topMargin: UIConstants.DEFAULT_MARGIN / 2
                        right: parent.right
                    }

                    Button {
                        id: byRating
                        //: Label for the "order by rating" setting
                        //% "Rating"
                        text: qsTrId('btc-settings-order-by-rating')
                        onClicked: Storage.setSetting('orderBy', 'rating')
                    }

                    Button {
                        id: byRelease
                        //: Label for the "order by release date" setting
                        //% "Release"
                        text: qsTrId('btc-settings-order-by-release')
                        onClicked: Storage.setSetting('orderBy', 'release')
                    }

                    Button {
                        id: byTitle
                        //: Label for the "order by title" setting
                        //% "Title"
                        text: qsTrId('btc-settings-order-by-title')
                        onClicked: Storage.setSetting('orderBy', 'title')
                    }
                }
            }

            Item {
                id: sortOrder
                width: parent.width
                height: childrenRect.height

                Label {
                    id: sortOrderText
                    anchors.top:  parent.top
                    platformStyle: LabelStyle {
                        fontPixelSize: UIConstants.FONT_DEFAULT
                    }
                    //: Label for the sort order setting used when browsing
                    //% "Sort order"
                    text: qsTrId('btc-settings-sort-order')
                    color: UIConstants.COLOR_INVERTED_FOREGROUND
                }

                ButtonColumn {
                    id: sortOrderOptions
                    anchors {
                        top: sortOrderText.bottom
                        topMargin: UIConstants.DEFAULT_MARGIN / 2
                        right: parent.right
                    }

                    Button {
                        id: sortAscending
                        //: Label for the "sort ascending" setting
                        //% "Ascending"
                        text: qsTrId('btc-settings-sort-ascending')
                        onClicked: Storage.setSetting('order', 'asc')
                    }

                    Button {
                        id: sortDescending
                        //: Label for the "sort descending" setting
                        //% "Descending"
                        text: qsTrId('btc-settings-sort-descending')
                        onClicked: Storage.setSetting('order', 'desc')
                    }
                }
            }

            Item {
                id: resultsPerPage
                width: parent.width
                height: childrenRect.height

                Label {
                    id: resultsPerPageText
                    anchors {
                        verticalCenter: resultsPerPageInput.verticalCenter
                        left: parent.left
                    }
                    platformStyle: LabelStyle {
                        fontPixelSize: UIConstants.FONT_DEFAULT
                    }
                    //: Label for the results per page setting used when browsing
                    //% "Results per page"
                    text: qsTrId('btc-settings-results-per-page')
                    color: UIConstants.COLOR_INVERTED_FOREGROUND
                }

                TextField {
                    id: resultsPerPageInput
                    anchors.right: parent.right
                    text: Storage.getSetting('perPage', '10')
                    width: 100
                    inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoPredictiveText
                    Keys.onReturnPressed: {
                        Storage.setSetting('perPage', text)
                    }
                }
            }

            Item {
                id: minVotes
                width: parent.width
                height: childrenRect.height

                Label {
                    id: minVotesText
                    anchors {
                        verticalCenter: minVotesInput.verticalCenter
                        left: parent.left
                    }
                    platformStyle: LabelStyle {
                        fontPixelSize: UIConstants.FONT_DEFAULT
                    }
                    //: Label for the minimum votes setting used when browsing
                    //% "Minimum votes"
                    text: qsTrId('btc-settings-minimum-votes')
                    color: UIConstants.COLOR_INVERTED_FOREGROUND
                }

                TextField {
                    id: minVotesInput
                    anchors.right: parent.right
                    text: Storage.getSetting('minVotes', '0')
                    width: 100
                    inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoPredictiveText
                    Keys.onReturnPressed: {
                        Storage.setSetting('minVotes', text)
                    }
                }
            }
        }
    }
}
