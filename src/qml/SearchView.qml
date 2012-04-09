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
import "butacautils.js" as BUTACA
import "storage.js" as Storage

Page {
    tools: ToolBarLayout {
        ToolIcon {
            iconId: 'toolbar-back'
            onClicked: appWindow.pageStack.pop()
        }
    }

    orientationLock: PageOrientation.LockPortrait

    property alias searchTerm: searchInput.text
    property bool useSimpleDelegate : searchCategory.checkedButton !== movieSearch

    Header {
        id: header
        //: Search
        text: qsTr('btc-search-header')
    }

    TextField {
        id: searchInput
        //: Enter search terms
        placeholderText: qsTr('btc-search-placeholder')

        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            margins: UIConstants.DEFAULT_MARGIN
        }

        platformSipAttributes: SipAttributes {
            actionKeyIcon: '/usr/share/themes/blanco/meegotouch/icons/icon-m-toolbar-search-selected.png'
        }

        Keys.onReturnPressed: {
            doSearch()
        }

        Image {
            id: clearText
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            source: searchInput.text ?
                        'image://theme/icon-m-input-clear' :
                        ''
        }

        MouseArea {
            id: searchInputMouseArea
            anchors.fill: clearText
            onClicked: {
                inputContext.reset()
                searchInput.text = ''
            }
        }
    }

    ButtonRow {
        id: searchCategory
        anchors {
            top: searchInput.bottom
            left: parent.left
            right: parent.right
            margins: UIConstants.DEFAULT_MARGIN
        }

        Button {
            id: movieSearch
            //: Movies
            text: qsTr('btc-movies')
        }

        Button {
            id: peopleSearch
            //: People
            text: qsTr('btc-people')
        }

        onCheckedButtonChanged: {
            localModel.clear()
            doSearch()
        }
    }

    Component { id: movieView; MovieView { } }

    Item {
        id: searchResults
        anchors {
            topMargin: UIConstants.DEFAULT_MARGIN
            top: searchCategory.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        PeopleModel {
            id: peopleModel
            source: ''
            onStatusChanged: {
                if (status == XmlListModel.Ready &&
                        count > 0) {
                    localModel.clear()
                    for (var i = 0; i < count; i ++) {
                        localModel.append(new BUTACA.TMDbPerson(get(i)))
                    }
                }
            }
        }

        MultipleMoviesModel {
            id: moviesModel
            source: ''
            onStatusChanged: {
                if (status == XmlListModel.Ready &&
                        count > 0) {
                    localModel.clear()
                    for (var i = 0; i < count; i ++) {
                        localModel.append(new BUTACA.TMDbMovie(get(i)))
                    }
                }
            }
        }

        ListModel {
            id: localModel
        }

        function handleClicked(index) {
            var element = localModel.get(index)
            switch (element.type) {
            case 'TMDbMovie':
                pageStack.push(movieView,
                               {
                                   movie: element
                               })
                break
            case 'TMDbPerson':
                pageStack.push(personView,
                               {
                                   detailId: element.id,
                                   viewType: BUTACA.PERSON
                               })
                break
            }
        }

        Component {
            id: listDelegate
            MyListDelegate {
                onClicked: searchResults.handleClicked(index)
            }
        }

        Component {
            id: multipleMoviesDelegate
            MultipleMoviesDelegate {
                onClicked: searchResults.handleClicked(index)
            }
        }

        ListView {
            id: resultsList
            anchors.fill: parent
            clip: true
            model: localModel
            delegate: useSimpleDelegate ? listDelegate : multipleMoviesDelegate
        }

        NoContentItem {
            id: noResults
            anchors.fill: parent
            visible: false
        }

        BusyIndicator {
            id: busyIndicator
            visible: running
            running: peopleModel.status === XmlListModel.Loading ||
                     moviesModel.status === XmlListModel.Loading
            platformStyle: BusyIndicatorStyle { size: 'large' }
            anchors.centerIn: parent
        }

        ScrollDecorator {
            id: scrollDecorator
            flickableItem: resultsList
        }
    }

    function doSearch() {
        if (searchTerm) {
            if (searchCategory.checkedButton === movieSearch) {
                peopleModel.source = ''
                moviesModel.source = BUTACA.getTMDbSource(BUTACA.TMDB_MOVIE_SEARCH, appLocale, searchTerm)
            } else if (searchCategory.checkedButton === peopleSearch) {
                moviesModel.source = ''
                peopleModel.source = BUTACA.getTMDbSource(BUTACA.TMDB_PERSON_SEARCH, appLocale, searchTerm)
            }
        }
    }
}
