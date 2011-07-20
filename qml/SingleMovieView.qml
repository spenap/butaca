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

Component {
    id: singleMovieView

    Page {
        property string movieId

        function getContent() {
            var itemTitle = list.model.get(list.currentIndex).title
            var itemIcon = list.model.get(list.currentIndex).poster
            return {'title': itemTitle, 'icon': itemIcon}
        }

        tools: ToolBarLayout {

            ToolIcon {
                iconId: "toolbar-back"; onClicked: pageStack.pop();
            }

            ToolIcon {
                anchors.horizontalCenter: parent.horizontalCenter
                iconId: welcomeView.isFavorite(getContent()) ? "toolbar-favorite-mark" : "toolbar-favorite-unmark"
                onClicked: {
                    iconId = iconId == "toolbar-favorite-mark" ? "toolbar-favorite-unmark" : "toolbar-favorite-mark"

                    var content = getContent()

                    if (welcomeView.isFavorite(content)) {
                        welcomeView.removeFavorite(content)
                    } else {
                        welcomeView.addFavorite(content)
                    }
                }
            }
        }
        width: parent.width; height: parent.height

        SingleMovieModel { id: moviesModel; params: movieId }

        ListView {
            id: list
            width: parent.width
            height: parent.height
            model: moviesModel
            interactive: false
            delegate: SingleMovieDelegate {}
        }
    }
}
