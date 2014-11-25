import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: infoPage

    property alias title: header.title
    property alias text: contentText.text

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: content.height

        Column {
            id: content
            width: parent.width

            PageHeader { id: header }

            Item {
                height: contentText.height
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                    right: parent.right
                    rightMargin: Theme.paddingLarge
                }

                Label {
                    id: contentText
                    width: parent.width
                    wrapMode: Text.WordWrap
                    textFormat: Text.RichText
                }
            }
        }

        VerticalScrollDecorator { }
    }
}
