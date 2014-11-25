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

import QtQuick 2.0
import Sailfish.Silica 1.0
import 'butacautils.js' as Util
import 'moviedbwrapper.js' as TheMovieDb
import 'storage.js' as Storage

Page {
    id: searchView
    allowedOrientations: Orientation.Portrait

    property alias searchTerm: searchInput.text
    property bool useSimpleDelegate : searchCategory.currentIndex === 2
    property bool loading: false
    property ListModel localModel: ListModel { }

    Component.onCompleted: {
        searchInput.forceActiveFocus()
    }

    PageHeader {
        id: header
        //: Header shown in the search view
        title: qsTr('Search')
    }

    SearchField {
        id: searchInput
        //: Placeholder text shown in the search input field
        placeholderText: qsTr('Enter search terms')

        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
        }

        EnterKey.enabled: text.length > 0
        EnterKey.onClicked: doSearch()
    }

    ComboBox {
        id: searchCategory
        anchors {
            top: searchInput.bottom
        }
        width: parent.width
        label: qsTr("Category")

        menu: ContextMenu {
            MenuItem {
                //: Shown in the button selecting movie search
                text: qsTr('Movies')
            }
            MenuItem {
                //: Shown in the button selecting TV search
                text: qsTr('TV')
            }
            MenuItem {
                //: Shown in the button selecting celebrities search
                text: qsTr('Celebrities')
            }
        }
        onCurrentIndexChanged: {
            doSearch()
        }
    }

    Loader {
        id: resultsListLoader
        sourceComponent: useSimpleDelegate ? peopleListWrapper : filmListWrapper
        anchors {
            topMargin: Theme.paddingLarge
            top: searchCategory.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
    }

    JSONListModel {
        id: moviesModel
        property string movieName: ''
        property int page: 1
        source: movieName ? TheMovieDb.search('movie', movieName, {
                                                  app_locale: appLocale,
                                                  'page_value': page,
                                                  'includeAdult_value': Storage.getSetting('includeAdult', 'true')
                                              }) : ''
        query: TheMovieDb.query_path(TheMovieDb.SEARCH)
        onJsonChanged: {
            if (json !== "")
                loading = false
            if (count !== 0)
                Util.populateModelFromModel(moviesModel.model, localModel, Util.TMDBSearchresult)
        }
    }

    JSONListModel {
        id: tvModel
        property string tvName: ''
        property int page: 1
        source: tvName ? TheMovieDb.search('tv', tvName, {
                                                   app_locale: appLocale,
                                                   'page_value': page
                                               }) : ''
        query: TheMovieDb.query_path(TheMovieDb.SEARCH)
        onJsonChanged: {
            if (json !== "")
                loading = false
            Util.populateModelFromModel(tvModel.model, localModel, Util.TMDBSearchresult)
        }
    }

    JSONListModel {
        id: peopleModel
        property string personName: ''
        property int page: 1
        source: personName ? TheMovieDb.search('person', personName, {
                                                   app_locale: appLocale,
                                                   'page_value': page,
                                                   'includeAdult_value': Storage.getSetting('includeAdult', 'true')
                                               }) : ''
        query: TheMovieDb.query_path(TheMovieDb.SEARCH)
        onJsonChanged: {
            if (json !== "")
                loading = false
            Util.populateModelFromModel(peopleModel.model, localModel, Util.TMDBSearchresult)
        }
    }

    Component {
        id: filmListWrapper

        Item {
            id: innerWrapper

            SilicaListView {
                id: filmList
                clip: true
                anchors.fill: parent
                model: searchView.localModel
                delegate: MultipleMoviesDelegate {
                    iconSource: model.img
                    name: model.name
                    rating: model.vote_avg
                    votes: model.vote_cnt
                    year: Util.getYearFromDate(model.date)

                    onClicked: searchView.handleClicked(index)
                }

                onMovementEnded: {
                    if (atYEnd) {
                        if (searchCategory.currentIndex === 0) {
                            moviesModel.page++
                        } else if (searchCategory.currentIndex === 1) {
                            tvModel.page++
                        }
                    }
                }

                VerticalScrollDecorator { }
            }
        }
    }

    Component {
        id: peopleListWrapper

        Item {
            id: innerWrapper

            SilicaListView {
                id: peopleList
                clip: true
                anchors.fill: parent
                model: searchView.localModel
                delegate: MyListDelegate {
                    width: parent.width
                    title: model.name
                    onClicked: searchView.handleClicked(index)
                }

                onMovementEnded: {
                    if (atYEnd)
                        peopleModel.page++
                }

                VerticalScrollDecorator { }
            }
        }
    }

    ViewPlaceholder {
        id: noResults
        anchors {
            top: searchCategory.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            margins: Theme.paddingLarge
        }
        enabled: false
        text: ''
    }

    BusyIndicator {
        id: busyIndicator
        visible: running
        running: loading
        size: BusyIndicatorSize.Large
        anchors.centerIn: noResults
    }

    states: [
        State {
            name: 'loadingState'
            when: (moviesModel.source != '' && moviesModel.json == '') ||
                  (tvModel.source != '' && tvModel.json == '') ||
                  (peopleModel.source != '' && peopleModel.json == '')
            PropertyChanges {
                target: busyIndicator
                running: true
            }
        },
        State {
            name: 'notFoundState'
            when: ((moviesModel.source != '' && moviesModel.json != '') ||
                   (tvModel.source != '' && tvModel.json != '') ||
                   (peopleModel.source != '' && peopleModel.json != '' )) &&
                  localModel.count === 0
            PropertyChanges {
                target: noResults
                enabled: true
                //: Shown in the search results area when no results were found
                text: qsTr('No results found')
            }
        },
        State {
            name: 'emptyState'
            when: moviesModel.source == '' &&
                  tvModel.source == '' &&
                  peopleModel.source  == '' &&
                  !searchInput.text
            PropertyChanges {
                target: noResults
                enabled: true
                //: Shown in the search results area when no terms have been introduced
                text: qsTr('Introduce search terms')
            }
        }
    ]

    function handleClicked(index) {
        var element = localModel.get(index)
        if (searchCategory.currentIndex === 0) {
            pageStack.push(movieView, { movie: element })
        } else if (searchCategory.currentIndex === 1) {
            pageStack.push(tvView, { movie: element })
        } else if (searchCategory.currentIndex === 2) {
            pageStack.push(personView, { person: element })
        }
    }

    function doSearch() {
        // avoid keyboard hiding when pre-selecting category
        if (searchTerm === '')
            searchInput.forceActiveFocus()

        moviesModel.movieName = ''
        tvModel.tvName = ''
        peopleModel.personName = ''
        localModel.clear()
        if (searchTerm) {
            loading = true
            if (searchCategory.currentIndex === 0) {
                moviesModel.page = 1
                moviesModel.movieName = searchTerm
            } else if (searchCategory.currentIndex === 1) {
                tvModel.page = 1
                tvModel.tvName = searchTerm
            } else if (searchCategory.currentIndex === 2) {
                peopleModel.page = 1
                peopleModel.personName = searchTerm
            }
            resultsListLoader.forceActiveFocus()
        }
    }
}
