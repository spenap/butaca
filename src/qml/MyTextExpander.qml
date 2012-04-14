import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1
import 'constants.js' as UIConstants

Column {
    id: textExpander

    property string textHeader: ''
    property string textContent: ''

    Item {
        id: textContainer
        width: parent.width
        height: expanded ? actualSize : Math.min(actualSize, collapsedSize)
        clip: true

        Behavior on height {
            NumberAnimation { duration: 200 }
        }

        property int actualSize: innerColumn.height
        property int collapsedSize: 160
        property bool expanded: false

        Column {
            id: innerColumn
            width: parent.width

            MyEntryHeader {
                id: header
                width: parent.width
                text: textHeader
            }

            Label {
                id: contentLabel
                width: parent.width
                platformStyle: LabelStyle {
                    fontPixelSize: UIConstants.FONT_LSMALL
                    fontFamily: UIConstants.FONT_FAMILY_LIGHT
                }
                text: textContent
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignJustify
            }
        }
    }

    Item {
        id: expanderToggle
        height: UIConstants.SIZE_ICON_LARGE
        width: parent.width
        visible: textContainer.actualSize > textContainer.collapsedSize

        MouseArea {
            anchors.fill: parent
            onClicked: textContainer.expanded = !textContainer.expanded
        }

        MyMoreIndicator {
            id: moreIndicator
            anchors.centerIn: parent
            rotation: textContainer.expanded ? -90 : 90

            Behavior on rotation {
                NumberAnimation { duration: 200 }
            }
        }
    }
}
