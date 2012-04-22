import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1
import 'constants.js' as UIConstants

Page {
    id: galleryView

    property ListModel galleryViewModel
    property int currentIndex: -1
    property bool expanded: false

    property string gridSize: ''
    property string fullSize: ''
    property string saveSize: ''

    tools: ToolBarLayout {
        ToolIcon {
            iconId: 'toolbar-back'
            onClicked: {
                appWindow.pageStack.pop()
            }
        }

        ToolButton {
            anchors.centerIn: parent
            visible: expanded
            //: Placed on a tool button, when clicked opens a sheet to save the image
            //% "Save image"
            text: qsTrId('btc-gallery-toolbar-save')
            onClicked: {
                saveImageSheet.open()
            }
        }
    }

    Loader {
        sourceComponent: expanded ? detailedView : gridViewWrapper
        anchors.fill: parent
    }

    Component {
        id: gridViewWrapper

        GridView {
            id: gridView
            cellHeight: 160
            cellWidth: 160
            cacheBuffer: 2 * height
            model: galleryView.galleryViewModel
            delegate: Rectangle {
                id: gridViewDelegate
                height: cellHeight
                width: cellWidth
                color: '#2d2d2d'
                opacity: gridDelegateMouseArea.pressed ? 0.5 : 1

                Image {
                    id: gridDelegateImage
                    clip: true
                    anchors {
                        fill: parent
                        margins: UIConstants.PADDING_XSMALL
                    }
                    source: sizes[gridSize].url
                    fillMode: Image.PreserveAspectCrop
                }

                Rectangle {
                    id: gridDelegateFrame
                    anchors.fill: parent
                    color: 'transparent'
                    border.color: '#2d2d2d'
                    border.width: UIConstants.PADDING_XSMALL
                }

                MouseArea {
                    id: gridDelegateMouseArea
                    anchors.fill: parent
                    onClicked: {
                        galleryView.currentIndex = index
                        galleryView.expanded = !galleryView.expanded
                    }
                }
            }
        }
    }

    Component {
        id: detailedView

        Rectangle {
            id: detailedDelegate
            color: '#2d2d2d'

            PageIndicator {
                id: detailedDelegateIndicator
                anchors {
                    top: parent.top
                    topMargin: UIConstants.DEFAULT_MARGIN
                    horizontalCenter: parent.horizontalCenter
                }
                totalPages: galleryView.galleryViewModel.count
                currentPage: galleryView.currentIndex + 1
            }

            Image {
                id: detailedDelegateImage
                source: galleryView.galleryViewModel.get(galleryView.currentIndex).sizes[fullSize].url
                anchors {
                    top: detailedDelegateIndicator.bottom
                    topMargin: UIConstants.DEFAULT_MARGIN
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }
                fillMode: Image.PreserveAspectFit
            }

            ProgressBar {
                id: detailedDelegateProgressBar
                anchors.centerIn: parent
                width: parent.width / 2
                minimumValue: 0
                maximumValue: 1
                value: detailedDelegateImage.progress
                visible: detailedDelegateImage.status === Image.Loading
            }

            MouseArea {
                id: detailedDelegateMouseArea
                anchors.fill : parent
                property bool swipeDone: false
                property int startX
                property int startY

                Timer {
                    id: clickTimer
                    interval: 350
                    running: false
                    repeat:  false
                    onTriggered: {
                        if (!parent.swipeDone) {
                            galleryView.expanded = !galleryView.expanded
                        }
                        parent.swipeDone = false
                    }
                }

                onClicked: {
                    // There's a bug in Qt Components emitting a clicked signal
                    // when a double click is done.
                    clickTimer.start()
                }

                onPressed: {
                    startX = mouse.x
                    startY = mouse.y
                }

                onReleased: {
                        var deltaX = mouse.x - startX
                        var deltaY = mouse.y - startY

                        // Swipe is only allowed when we're not zoomed in
                        if (Math.abs(deltaX) > 50 || Math.abs(deltaY) > 50) {
                            swipeDone = true

                            if (deltaX > 30) {
                                detailedDelegate.swipeRight()
                            } else if (deltaX < -30) {
                                detailedDelegate.swipeLeft()
                            }
                        }
                }
            }

            function swipeRight() {
                galleryView.currentIndex = (galleryView.currentIndex - 1 +
                                            galleryView.galleryViewModel.count) %
                        galleryView.galleryViewModel.count
            }

            function swipeLeft() {
                galleryView.currentIndex = (galleryView.currentIndex + 1) %
                        galleryView.galleryViewModel.count
            }
        }
    }

    Sheet {
        id: saveImageSheet

        property string imageUrl: galleryView.currentIndex >= 0 ?
                                      galleryView.galleryViewModel.get(galleryView.currentIndex).sizes[saveSize].url :
                                      ''

        acceptButtonText:
            //: Placed on the save image sheet, when clicked actually saves the image
            //% "Save"
            qsTrId('btc-gallery-sheet-save')
        rejectButtonText:
            //: Placed on the save image sheet, when clicked closes the sheet and doesn't save
            //% "Cancel"
            qsTrId('btc-gallery-sheet-cancel')

        acceptButton.enabled: savingImage.status === Image.Ready

        buttons: BusyIndicator {
            anchors.centerIn: parent
            platformStyle: BusyIndicatorStyle {
                size: 'small'
            }
            visible: running
            running: savingImage.status === Image.Loading
        }

        content: Rectangle {
            id: saveImageContainer
            color: '#2d2d2d'
            anchors.fill: parent

            Image {
                id: savingImage
                source: saveImageSheet.visible ?
                            saveImageSheet.imageUrl :
                            ''
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
            }

            ProgressBar {
                id: savingImageProgressBar
                anchors.centerIn: parent
                width: parent.width / 2
                minimumValue: 0
                maximumValue: 1
                value: savingImage.progress
                visible: savingImage.status === Image.Loading
            }
        }
        onAccepted: {
            controller.saveImage(savingImage, saveImageSheet.imageUrl)
        }
    }
}
