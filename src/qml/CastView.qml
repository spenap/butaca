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
import 'butacautils.js' as BUTACA
import 'constants.js' as UIConstants

Page {
    id: castView
    orientationLock: PageOrientation.LockPortrait

    tools: ToolBarLayout {
        ToolIcon {
            iconId: 'toolbar-back'
            onClicked: {
                appWindow.pageStack.pop()
            }
        }
    }

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
    property variant rawCrew: ''
    property bool showsCast: true

    Component.onCompleted: {
        if (!showsCast && rawCrew) {
            for (var i = 0; i < rawCrew.length; i ++) {
                castModel.append(new BUTACA.TMDbCrewPerson(rawCrew[i]))
            }
        }
    }

    Component {
        id: listSectionDelegate

        ListSectionDelegate {
            // Translate the section name. See dummy() for translations
            sectionName: qsTranslate("CastView", section)
        }
    }

    ListView {
        id: castList
        anchors {
            fill: parent
            margins: UIConstants.DEFAULT_MARGIN
        }
        model: castModel
        header: Header {
            text: showsCast ?
                      //: This appears in the cast view when the cast is shown
                      qsTr('Full cast in %1').arg(movieName) :
                      //: This appears in the cast view when cast and crew are shown
                      qsTr('Cast and crew in %1').arg(movieName)
            showDivider: false
        }
        delegate: MyListDelegate {
            width: parent.width
            title: model.name
            subtitle: showsCast ? model.character : model.job

            onClicked: {
                appWindow.pageStack.push(personView,
                                         {
                                             tmdbId: model.id,
                                             loading: true
                                         })
            }
        }

        section.property: !showsCast ? 'department' : ''
        section.delegate: listSectionDelegate
    }

    ScrollDecorator {
        flickableItem: castList
        anchors.rightMargin: -UIConstants.DEFAULT_MARGIN
    }
}
