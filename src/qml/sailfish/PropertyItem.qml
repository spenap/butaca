import QtQuick 2.0
import Sailfish.Silica 1.0

Column {
    id: propertyItem
    property string title: ''
    property string text: ''

    anchors {
        left: parent.left
        right: parent.right
        leftMargin: Theme.paddingLarge
        rightMargin: Theme.paddingLarge
    }

    MyEntryHeader {
        //: Label acting as the header for the release date
        text: propertyItem.title
    }

    Label {
        id: release
        width: parent.width
        font.pixelSize: Theme.fontSizeSmall
        text: propertyItem.text
    }
}
