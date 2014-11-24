import QtQuick 2.0
import Sailfish.Silica 1.0

import 'constants.js' as UIConstants

// collapsable details box
BackgroundItem {
    id: detailsBackground

    property string textHeader: ''
    property string textContent: ''

//    property real ellipsisDisplacement: detailsBox.opened ? 0 : Theme.paddingLarge
//    Behavior on ellipsisDisplacement {
//        NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
//    }

    width: parent.width
    //detailsBox.height + detailsBox.y + Theme.paddingMedium + ellipsisDisplacement
    height: content.height + Theme.paddingMedium //+ ellipsisDisplacement

    Column {
        id: content
        width: parent.width

        MyEntryHeader {
            text: textHeader
            anchors {
                left: parent.left
                right: parent.right
                leftMargin: Theme.paddingLarge
                rightMargin: Theme.paddingLarge
            }
        }

        Item {
            id: detailsBox

            property bool opened: false

            y: Theme.paddingMedium
            width: parent.width
            clip: true

            height: opened ? contentLabel.height
                           : Math.min(contentLabel.height, contentLabelHeight.height)

            Behavior on height {
                NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
            }

            Label {
                id: contentLabelHeight
                width: parent.width
                font.pixelSize: Theme.fontSizeSmall
                text: "\n\n\n\n\n" // Emulate 6 lines
            }

            Label {
                id: contentLabel
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: Theme.paddingLarge
                    rightMargin: Theme.paddingLarge
                }
                text: textContent
                color: detailsBackground.highlighted ? Theme.highlightColor : Theme.primaryColor
                font.pixelSize: Theme.fontSizeSmall
                wrapMode: Text.WordWrap
            }

        }//Item

    }

    Item {
        x: detailsBox.x
        y: detailsBox.y
        OpacityRampEffect {
            sourceItem: detailsBox
            enabled: !detailsBox.opened
            direction: OpacityRamp.TopToBottom
            slope: 1.6
            offset: 4 / 7
            width: detailsBox.width
            height: detailsBox.height
            anchors.fill: null
        }
    }

    Image {
        anchors {
            right: parent.right
            bottom: parent.bottom
            rightMargin: Theme.paddingLarge
        }
        source: "image://theme/icon-lock-more"
    }

    onClicked: {
        detailsBox.opened = !detailsBox.opened
    }
}
