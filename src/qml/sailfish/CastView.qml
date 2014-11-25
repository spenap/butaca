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
import 'butacautils.js' as BUTACA
import 'moviedbwrapper.js' as TMDB

Page {
    id: castView
    allowedOrientations: Orientation.Portrait

    // Dummy function for translations (found no other way to add them to the file)
    function dummy() {
        qsTr('Camera');
        qsTr("Crew");
        qsTr("Sound");
        qsTr("Directing");
        qsTr("Writing");
        qsTr("Production");
        qsTr("Actors");
        qsTr("Editing");
        qsTr("Art");
        qsTr("Costume & Make-Up");
        qsTr("Visual Effects");
    }

    property string movieName: ''
    property ListModel castModel: ListModel { }
    property bool showsCast: true

    Component {
        id: listSectionDelegate

        SectionHeader {
            // Translate the section name. See dummy() for translations
            text: qsTranslate("CastView", section)
        }
    }

    SilicaListView {
        id: castList
        anchors.fill: parent
        model: castModel
        header: PageHeader {
            title: showsCast ?
                      //: This appears in the cast view when the cast is shown
                      qsTr('Full cast in %1').arg(movieName) :
                      //: This appears in the cast view when cast and crew are shown
                      qsTr('Cast and crew in %1').arg(movieName)
        }
        delegate: MyListDelegate {
            width: castList.width
            title: model.name
            subtitle: model.subtitle || ''
            iconSource: model.img ?
                            TMDB.image(TMDB.IMAGE_PROFILE, 0, model.img, { app_locale: appLocale }) :
                            'qrc:/resources/person-placeholder.svg'

            onClicked: {
                appWindow.pageStack.push(personView,
                                         {
                                             person: model,
                                             loading: true
                                         })
            }
        }

        section.property: !showsCast ? 'department' : ''
        section.delegate: listSectionDelegate

        VerticalScrollDecorator { }
    }
}
