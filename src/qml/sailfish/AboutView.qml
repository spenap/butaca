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

Page {
    property string license: 'This program is free software: you can redistribute it and/or modify ' +
                             'it under the terms of the GNU General Public License as published by ' +
                             'the Free Software Foundation, either version 3 of the License, or ' +
                             '(at your option) any later version.<br /><br />' +

                             'This package is distributed in the hope that it will be useful, ' +
                             'but WITHOUT ANY WARRANTY; without even the implied warranty of ' +
                             'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the ' +
                             'GNU General Public License for more details.<br /><br />' +

                             'You should have received a copy of the GNU General Public License ' +
                             'along with this program. If not, see ' +
                             '<a href="http://www.gnu.org/licenses">http://www.gnu.org/licenses</a><br /><br />'

    //: Header introducing the list of contributors
    property string credits: qsTr('Thanks a lot to all contributors: %1').arg(
                                 '<br /><p>Adrian Perez, Amit Singh, Nik Rolls, ' +
                                 'Christoph Keller, Janne Makinen, Tuomas Siipola, ' +
                                 'Alexandre Mazari, Petru Motrescu, Oytun Şengül, ' +
                                 'Ismail Coskuner, Aras Ergus, Joaquim Rocha, ' +
                                 'Marco Porsch, Lukas Vogel, Stephan Beyerle, ' +
                                 'Jakub Kožíšek</p>')
    property string styleSheets: "<style type='text/css'>a:link {color:%1}</style>".arg(Theme.highlightColor)

    Component.onCompleted: {
        //: Short text inviting to recommend the application
        aboutOptions.get(0).title = qsTr('Recommend this app')
        //: Short text inviting to provide application feedback
        aboutOptions.get(1).title = qsTr('Tell us what you think')
        //: Short text inviting to rate us at openrepos.net
        aboutOptions.get(2).title = qsTr('Rate us at openrepos.net')
        //: Short text inviting to follow us on Twitter
        aboutOptions.get(3).title = qsTr('Follow us on Twitter')
    }

    ListModel {
        id: aboutOptions
        ListElement {
            title: 'Recomienda esta aplicación'
            action: 'openExternally'
            data: 'mailto:?subject=Download%20Butaca&body=Available%20at%20https://openrepos.net/content/lukedirtwalker/butaca'
        }
        ListElement {
            title: 'Cuéntanos tu opinión'
            action: 'openExternally'
            data: 'mailto:lukedirtwalkerdev@gmail.com?subject=Butaca'
        }
        ListElement {
            title: 'Valóranos en openrepos.net'
            action: 'openExternally'
            data: 'https://openrepos.net/content/lukedirtwalker/butaca'
        }
        ListElement {
            title: 'Síguenos en Twitter'
            action: 'openExternally'
            data: 'https://twitter.com/lukedirtwalker'
        }
    }

    SilicaFlickable {
        id: flick
        clip: true
        anchors.fill: parent
        contentHeight: contentColumn.height

        Column {
            id: contentColumn
            width: parent.width
            spacing: Theme.paddingMedium

            PageHeader {
                id: aboutVersion
                title: 'Butaca %1'.arg(packageVersion)
                width: parent.width
            }

            Repeater {
                id: repeater
                model: aboutOptions
                BackgroundItem {
                    id: aboutItem
                    height: Theme.itemSizeSmall
                    width: parent.width

                    Label {
                        anchors {
                            left: parent.left
                            leftMargin: Theme.paddingLarge
                            verticalCenter: parent.verticalCenter
                        }
                        text: model.title
                        color: aboutItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                    }

                    onClicked: {
                        if (model.action === 'openExternally')
                            Qt.openUrlExternally(model.data)
                    }
                }
            }

            Label {
                id: aboutCopyright
                text: 'Copyright © 2011 - 2012 Simon Pena'
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.secondaryColor
            }

            Image {
                id: aboutThemovieDbImage
                anchors.horizontalCenter: parent.horizontalCenter
                source: 'qrc:/resources/tmdb-logo.png'
            }

            Label {
                id: aboutTMDbDisclaimer
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                    right: parent.right
                    rightMargin: Theme.paddingLarge
                }

                //: Disclaimer about The Movie Database API usage
                text: styleSheets + qsTr('This product uses the ' +
                                         '<a href="http://www.themoviedb.org/">TMDb</a> ' +
                                         'API but is not endorsed or certified by TMDb.')
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignJustify
                font.pixelSize: Theme.fontSizeSmall
                textFormat: Text.RichText
                color: Theme.secondaryColor
                onLinkActivated: Qt.openUrlExternally(link)
            }

            // TODO: Showtimes
            //            Label {
            //                id: aboutShowtimesDisclaimer
            //                anchors {
            //                    left: parent.left
            //                    leftMargin: Theme.paddingLarge
            //                    right: parent.right
            //                    rightMargin: Theme.paddingLarge
            //                }

            //                //: Disclaimer about Google Showtimes usage
            //                text: styleSheets + qsTr('This product presents showtimes from ' +
            //                                         '<a href="http://www.google.com/movies">Google ' +
            //                                         'Movies</a> but is not endorsed or certified by Google.')
            //                wrapMode: Text.WordWrap
            //                horizontalAlignment: Text.AlignJustify
            //                font.pixelSize: Theme.fontSizeSmall
            //                textFormat: Text.RichText
            //                color: Theme.secondaryColor
            //                onLinkActivated: Qt.openUrlExternally(link)
            //            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                //: Shown in a button. When clicked, the application license is shown
                text: qsTr('License')
                onClicked: pageStack.push(Qt.resolvedUrl("InfoPage.qml"),
                                          {"title": text, "text": license})
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                //: Shown in a button. When clicked, the application credits are shown
                text: qsTr('Credits')
                onClicked: pageStack.push(Qt.resolvedUrl("InfoPage.qml"),
                                          {"title": text, "text": credits})
            }
        }
    }
}
