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
import com.nokia.meego 1.1
import com.nokia.extras 1.1
import 'constants.js' as UIConstants

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
                             'Marco Porsch</p>')
    property string styleSheets: "<style type='text/css'>a:link {color:#FFFFFF}</style>"

    tools: ToolBarLayout {
        ToolIcon {
            id: backIcon
            iconId: 'toolbar-back'
            onClicked: pageStack.pop()
        }
    }

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
            data: 'mailto:?subject=Download%20Butaca&body=Available%20at%20https://openrepos.net/content/whisk4s/butaca'
        }
        ListElement {
            title: 'Cuéntanos tu opinión'
            action: 'openExternally'
            data: 'mailto:spena@igalia.com?subject=Butaca'
        }
        ListElement {
            title: 'Valóranos en openrepos.net'
            action: 'openExternally'
            data: 'https://openrepos.net/content/whisk4s/butaca'
        }
        ListElement {
            title: 'Síguenos en Twitter'
            action: 'openExternally'
            data: 'https://twitter.com/#!/spenap'
        }
    }

    Flickable {
        id: flick
        clip: true
        anchors.fill: parent
        anchors {
            topMargin: UIConstants.DEFAULT_MARGIN
            leftMargin: UIConstants.DEFAULT_MARGIN
            rightMargin: UIConstants.DEFAULT_MARGIN
        }
        contentHeight: contentColumn.height

        Column {
            id: contentColumn
            spacing: UIConstants.PADDING_LARGE
            width: parent.width

            Label {
                id: aboutVersion
                text: 'Butaca %1'.arg(packageVersion)
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                platformStyle: LabelStyle {
                    fontPixelSize: UIConstants.FONT_XLARGE
                }
                color: UIConstants.COLOR_INVERTED_FOREGROUND
            }

            Rectangle {
                width: parent.width
                height: repeater.model.count * UIConstants.LIST_ITEM_HEIGHT_SMALL
                color: UIConstants.COLOR_INVERTED_FOREGROUND

                Column {
                    id: subcolumn
                    anchors.fill: parent
                    Repeater {
                        id: repeater
                        model: aboutOptions
                        Item {
                            height: UIConstants.LIST_ITEM_HEIGHT_SMALL
                            width: parent.width

                            BorderImage {
                                anchors.fill: parent
                                visible: mouseArea.pressed
                                source: 'image://theme/meegotouch-list-fullwidth-background-pressed-vertical-center'
                            }

                            Label {
                                anchors {
                                    left: parent.left
                                    leftMargin: UIConstants.DEFAULT_MARGIN
                                    verticalCenter: parent.verticalCenter
                                }
                                platformStyle: LabelStyle {
                                    fontPixelSize: UIConstants.FONT_SLARGE
                                }
                                color: UIConstants.COLOR_FOREGROUND
                                text: model.title
                            }

                            Image {
                                source: 'image://theme/icon-m-common-drilldown-arrow'
                                anchors {
                                    right: parent.right
                                    rightMargin: UIConstants.DEFAULT_MARGIN
                                    verticalCenter: parent.verticalCenter
                                }
                            }

                            Rectangle {
                                anchors.bottom: parent.bottom
                                width: parent.width
                                height: 1
                                color: UIConstants.COLOR_FOREGROUND
                                visible: index !== repeater.model.count - 1
                            }

                            MouseArea {
                                id: mouseArea
                                anchors.fill: parent
                                onClicked: {
                                    if (model.action === 'openExternally')
                                        Qt.openUrlExternally(model.data)
                                }
                            }
                        }
                    }
                }

                BorderImage {
                    id: border
                    source: 'qrc:/resources/round-corners.png'
                    anchors.fill: parent
                    border { left: 18; top: 18; right: 18; bottom: 18 }
                }
            }

            Label {
                id: aboutCopyright
                text: 'Copyright © 2011 - 2012 Simon Pena'
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                platformStyle: LabelStyle {
                    fontPixelSize: UIConstants.FONT_LSMALL
                    fontFamily: UIConstants.FONT_FAMILY_LIGHT
                }
                color: UIConstants.COLOR_SECONDARY_FOREGROUND
            }

            Column {
                width: parent.width

                Image {
                    id: aboutThemovieDbImage
                    source: 'qrc:/resources/tmdb-logo.png'
                }

                Label {
                    id: aboutTMDbDisclaimer
                    //: Disclaimer about The Movie Database API usage
                    text: styleSheets + qsTr('This product uses the ' +
                               '<a href="http://www.themoviedb.org/">TMDb</a> ' +
                               'API but is not endorsed or certified by TMDb.')
                    width: parent.width
                    horizontalAlignment: Text.AlignJustify
                    platformStyle: LabelStyle {
                        fontPixelSize: UIConstants.FONT_LSMALL
                        fontFamily: UIConstants.FONT_FAMILY_LIGHT
                    }
                    color: UIConstants.COLOR_SECONDARY_FOREGROUND
                    onLinkActivated: Qt.openUrlExternally(link)
                }

                Label {
                    id: aboutShowtimesDisclaimer
                    //: Disclaimer about Google Showtimes usage
                    text: styleSheets + qsTr('This product presents showtimes from ' +
                               '<a href="http://www.google.com/movies">Google ' +
                               'Movies</a> but is not endorsed or certified by Google.')
                    width: parent.width
                    horizontalAlignment: Text.AlignJustify
                    platformStyle: LabelStyle {
                        fontPixelSize: UIConstants.FONT_LSMALL
                        fontFamily: UIConstants.FONT_FAMILY_LIGHT
                    }
                    color: UIConstants.COLOR_SECONDARY_FOREGROUND
                    onLinkActivated: Qt.openUrlExternally(link)
                }
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                //: Shown in a button. When clicked, the application license is shown
                text: qsTr('License')
                onClicked: licenseDialog.open()
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                //: Shown in a button. When clicked, the application credits are shown
                text: qsTr('Credits')
                onClicked: creditsDialog.open()
            }
        }
    }

    QueryDialog {
        id: licenseDialog
        titleText: qsTr('License')
        message: license
        //: OK button
        acceptButtonText: qsTr('OK')
    }

    QueryDialog {
        id: creditsDialog
        titleText: qsTr('Credits')
        message: credits
        acceptButtonText: qsTr('OK')
    }

    ScrollDecorator {
        flickableItem: flick
        anchors.rightMargin: -UIConstants.DEFAULT_MARGIN
    }
}
