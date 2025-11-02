pragma ComponentBehavior: Bound
import QtQuick
import QtMultimedia
import Qt5Compat.GraphicalEffects
import QtQuick.Controls

Window{
    id: recordPlayerWindow
    width: 300
    height: 330
    flags: Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    color: "transparent"

    property bool locked: false
    required property url uri
    property var externalMediaPlayer: null

    Rectangle {
        anchors.fill: parent
        radius: 17
        border.width: 0.5
        border.color: "#22ffffff"
        color: "#141414"

        Column{
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            Item{
                anchors.left: parent.left
                anchors.right: parent.right
                height: 25

                Rectangle{
                    width: childrenRect.width + 20
                    height: parent.height
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#1F1F1F"
                    border.width: 0.5
                    border.color: "#4A4A4A"
                    radius: 7

                    Text{
                        anchors.centerIn: parent
                        text: externalMediaPlayer ? externalMediaPlayer.metaData.value(0) ?? "Unknown" : "Unknown"
                        color: "#A2A2A2"
                    }
                }

                Rectangle {
                    id: close
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    width: 30
                    height: 30
                    radius: 30
                    color: "#55000000"
                    z: 20

                    Image {
                        anchors.fill: parent
                        anchors.centerIn: parent
                        anchors.margins: 7

                        source: "qrc:/qt/qml/collective/assets/x-white.png"
                    }

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            recordPlayerWindow.close();
                        }
                    }
                }
            }

            Item{
                anchors.left: parent.left
                anchors.right: parent.right
                height: 200

                Item{
                    id: recordDiskContainer
                    anchors.centerIn: parent
                    width: 150
                    height: 150

                    Image{
                        id: recordDisk
                        anchors.centerIn: parent
                        width: 180
                        height: 180

                        source: "qrc:/qt/qml/collective/assets/disk.png"
                    }

                    Image{
                        id: albumArt
                        anchors.centerIn: parent
                        width: 70
                        height: 70
                        source: externalMediaPlayer ? externalMediaPlayer.coverArtUrl : ""

                        layer.enabled: true
                        layer.effect: OpacityMask {
                            maskSource: Rectangle {
                                width: albumArt.width
                                height: albumArt.height
                                radius: 90
                            }
                        }
                    }

                    RotationAnimator {
                        target: recordDiskContainer
                        from: 0
                        to: 360
                        duration: 3000
                        loops: Animation.Infinite
                        running: externalMediaPlayer ? externalMediaPlayer.playing : false
                    }
                }
            }

            Item{
                anchors.horizontalCenter: parent.horizontalCenter
                width: 200
                height: 100

                Column{
                    id: controlsLayout
                    anchors.fill: parent
                    spacing: 5

                    ProgressBar{
                        id: progress
                        from: 0
                        to: externalMediaPlayer ? externalMediaPlayer.duration : 0
                        value: externalMediaPlayer ? externalMediaPlayer.position : 0
                        width: parent.width
                        height: 2

                        background: Rectangle{
                            anchors.fill: parent
                            width: parent.width
                            height: 2
                            color: "#5D5D5D"
                        }

                        contentItem: Rectangle{
                            implicitWidth: parent.width
                            implicitHeight: 2
                            width: parent.visualPosition * parent.width
                            color: "#FFFFFF"
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: mouse => {
                                if (externalMediaPlayer) {
                                    var clickPosition = mouse.x / width;
                                    externalMediaPlayer.position = clickPosition * externalMediaPlayer.duration;
                                }
                            }
                        }
                    }

                    Item{
                        id: timelineContainer
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 20

                        Text{
                            id: currentPositionText
                            anchors.left: parent.left
                            color: "white"
                            text: {
                                var remainingMs = externalMediaPlayer ? externalMediaPlayer.position : 0;
                                var totalSeconds = Math.floor(remainingMs / 1000);
                                var minutes = Math.floor(totalSeconds / 60);
                                var seconds = totalSeconds % 60;
                                return minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
                            }
                        }

                        Text{
                            id: durationText
                            color: "white"
                            anchors.right: parent.right

                            text: {
                                var duration = externalMediaPlayer ? externalMediaPlayer.duration : 0;
                                var minutes = Math.floor(Math.floor(duration/1000)/ 60);
                                var seconds = (Math.floor(duration/1000)) % 60;
                                return minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
                            }
                        }
                    }

                    Item{
                        id: controlsContainer
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 30

                        Image{
                            id: volumeIcon
                            width: 15
                            height: 15
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            source: "qrc:/qt/qml/collective/assets/volume.png"
                            opacity: externalMediaPlayer ? externalMediaPlayer.audioOutput.volume : 1

                            MouseArea{
                                anchors.fill: parent
                                hoverEnabled: true

                                onWheel: wheel => {
                                    if (externalMediaPlayer) {
                                        var delta = wheel.angleDelta.y / 120;
                                        var newVolume = externalMediaPlayer.audioOutput.volume + (delta * 0.1);
                                        externalMediaPlayer.audioOutput.volume = Math.max(0, Math.min(1, newVolume));
                                    }
                                }
                            }
                        }

                        Row{
                            anchors.centerIn: parent
                            spacing: 5

                            Image{
                                width: 15
                                height: 15
                                anchors.verticalCenter: parent.verticalCenter
                                source: "qrc:/qt/qml/collective/assets/skip-back.png"

                                MouseArea{
                                    anchors.fill: parent

                                    onClicked: {
                                        if (externalMediaPlayer) {
                                            externalMediaPlayer.position = 0;
                                        }
                                    }
                                }
                            }

                            Image{
                                width: 15
                                height: 15
                                anchors.verticalCenter: parent.verticalCenter
                                source: "qrc:/qt/qml/collective/assets/play.png"
                                visible: externalMediaPlayer ? !externalMediaPlayer.playing : true

                                MouseArea{
                                    anchors.fill: parent

                                    onClicked: {
                                        if (externalMediaPlayer) {
                                            externalMediaPlayer.play();
                                        }
                                    }
                                }
                            }

                            Image{
                                width: 15
                                height: 15
                                anchors.verticalCenter: parent.verticalCenter
                                source: "qrc:/qt/qml/collective/assets/pause.png"
                                visible: externalMediaPlayer ? externalMediaPlayer.playing : false

                                MouseArea{
                                    anchors.fill: parent

                                    onClicked: {
                                        if (externalMediaPlayer) {
                                            externalMediaPlayer.pause();
                                        }
                                    }
                                }
                            }

                            Image{
                                width: 15
                                height: 15
                                anchors.verticalCenter: parent.verticalCenter
                                source: "qrc:/qt/qml/collective/assets/skip-forward.png"

                                MouseArea{
                                    anchors.fill: parent

                                    onClicked: {
                                        if (externalMediaPlayer) {
                                            externalMediaPlayer.position = externalMediaPlayer.duration;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    MouseArea {
        id: moveArea
        anchors.left: recordPlayerWindow.left
        anchors.right: recordPlayerWindow.right
        anchors.top: recordPlayerWindow.top
        height: 30
        width: recordPlayerWindow.width
        anchors.margins: 8
        propagateComposedEvents: true
        onPressed: {
            recordPlayerWindow.startSystemMove();
        }
    }

    // MouseArea {
    //     id: topLeftResize
    //     width: 16
    //     height: 16
    //     anchors.left: parent.left
    //     anchors.top: parent.top
    //     cursorShape: Qt.SizeFDiagCursor

    //     onPressed: {
    //         if (!recordPlayerWindow.locked)
    //             recordPlayerWindow.startSystemResize(Qt.TopEdge | Qt.LeftEdge);
    //     }
    // }

    // // Top-right corner resize
    // MouseArea {
    //     id: topRightResize
    //     width: 16
    //     height: 16
    //     anchors.right: parent.right
    //     anchors.top: parent.top
    //     cursorShape: Qt.SizeBDiagCursor

    //     onPressed: {
    //         if (!recordPlayerWindow.locked)
    //             recordPlayerWindow.startSystemResize(Qt.TopEdge | Qt.RightEdge);
    //     }
    // }

    // // Bottom-left corner resize
    // MouseArea {
    //     id: bottomLeftResize
    //     width: 16
    //     height: 16
    //     anchors.left: parent.left
    //     anchors.bottom: parent.bottom
    //     cursorShape: Qt.SizeBDiagCursor

    //     onPressed: {
    //         if (!recordPlayerWindow.locked)
    //             recordPlayerWindow.startSystemResize(Qt.BottomEdge | Qt.LeftEdge);
    //     }
    // }

    // // Bottom-right corner resize
    // MouseArea {
    //     id: bottomRightResize
    //     width: 16
    //     height: 16
    //     anchors.right: parent.right
    //     anchors.bottom: parent.bottom
    //     cursorShape: Qt.SizeFDiagCursor

    //     onPressed: {
    //         if (!recordPlayerWindow.locked)
    //             recordPlayerWindow.startSystemResize(Qt.BottomEdge | Qt.RightEdge);
    //     }
    // }

    // // Top edge resize
    // MouseArea {
    //     id: topResize
    //     height: 8
    //     anchors.left: parent.left
    //     anchors.right: parent.right
    //     anchors.top: parent.top
    //     anchors.leftMargin: 16
    //     anchors.rightMargin: 16
    //     cursorShape: Qt.SizeVerCursor

    //     onPressed: {
    //         if (!recordPlayerWindow.locked)
    //             recordPlayerWindow.startSystemResize(Qt.TopEdge);
    //     }
    // }

    // // Bottom edge resize
    // MouseArea {
    //     id: bottomResize
    //     height: 8
    //     anchors.left: parent.left
    //     anchors.right: parent.right
    //     anchors.bottom: parent.bottom
    //     anchors.leftMargin: 16
    //     anchors.rightMargin: 16
    //     cursorShape: Qt.SizeVerCursor

    //     onPressed: {
    //         if (!recordPlayerWindow.locked)
    //             recordPlayerWindow.startSystemResize(Qt.BottomEdge);
    //     }
    // }

    // // Left edge resize
    // MouseArea {
    //     id: leftResize
    //     width: 8
    //     anchors.top: parent.top
    //     anchors.bottom: parent.bottom
    //     anchors.left: parent.left
    //     anchors.topMargin: 16
    //     anchors.bottomMargin: 16
    //     cursorShape: Qt.SizeHorCursor

    //     onPressed: {
    //         if (!recordPlayerWindow.locked)
    //             recordPlayerWindow.startSystemResize(Qt.LeftEdge);
    //     }
    // }

    // // Right edge resize
    // MouseArea {
    //     id: rightResize
    //     width: 8
    //     anchors.top: parent.top
    //     anchors.bottom: parent.bottom
    //     anchors.right: parent.right
    //     anchors.topMargin: 16
    //     anchors.bottomMargin: 16
    //     cursorShape: Qt.SizeHorCursor

    //     onPressed: {
    //         if (!recordPlayerWindow.locked)
    //             recordPlayerWindow.startSystemResize(Qt.RightEdge);
    //     }
    // }
}
