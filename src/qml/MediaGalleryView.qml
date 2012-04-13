import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1
import 'butacautils.js' as BUTACA
import 'constants.js' as UIConstants

Page {
    id: galleryView

    property ListModel galleryViewModel
    property int currentIndex: -1
    property bool expanded: false

    tools: ToolBarLayout {
        ToolIcon {
            iconId: 'toolbar-back'
            onClicked: {
                appWindow.pageStack.pop()
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
                clip: true
                opacity: gridDelegateMouseArea.pressed ? 0.5 : 1

                Image {
                    id: gridDelegateImage
                    anchors {
                        fill: parent
                        margins: UIConstants.PADDING_XSMALL
                    }
                    source: sizes['w154'].url
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
                source: galleryView.galleryViewModel.get(galleryView.currentIndex).sizes['mid'].url
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
}
