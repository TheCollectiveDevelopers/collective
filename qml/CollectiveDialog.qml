import QtQuick
import QtQuick.Layouts

Window {
    id: dialogWindow
    minimumWidth: 300
    minimumHeight: 150
    flags: Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    color: "transparent"

    property string text: ""
    property int buttons: CollectiveDialog.Ok
    property bool locked: false

    signal accepted
    signal rejected

    enum StandardButton {
        NoButton = 0,
        Ok = 1,
        Cancel = 2
    }

    function open() {
        dialogWindow.show();
    }

    Rectangle {
        anchors.fill: parent
        radius: 17
        border.width: 0.5
        border.color: "#22ffffff"
        color: "#1a1a1a"

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            // Close button in top right
            Rectangle {
                id: close
                Layout.alignment: Qt.AlignRight
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
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        dialogWindow.rejected();
                        dialogWindow.close();
                    }
                }
            }

            Item{
                Layout.fillHeight: true
                Layout.fillWidth: true
                // Text content
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: dialogWindow.text
                    color: "white"
                    font.pixelSize: 14
                    wrapMode: Text.WordWrap
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                }

                // Buttons row
                Row {
                    id: buttonRow

                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    spacing: 10

                    Rectangle {
                        visible: dialogWindow.buttons & CollectiveDialog.Ok

                        width: 80
                        height: 35
                        radius: 8
                        color: "#1F4CFF"

                        Text {
                            anchors.centerIn: parent
                            text: "OK"
                            color: "white"
                            font.pixelSize: 13
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor

                            onClicked: {
                                dialogWindow.accepted();
                                dialogWindow.close();
                            }
                        }
                    }

                    Rectangle {
                        visible: dialogWindow.buttons & CollectiveDialog.Cancel
                        width: 80
                        height: 35
                        radius: 8
                        color: "#333333"

                        Text {
                            anchors.centerIn: parent
                            text: "Cancel"
                            color: "white"
                            font.pixelSize: 13
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor

                            onClicked: {
                                dialogWindow.rejected();
                                dialogWindow.close();
                            }
                        }
                    }
                }
            }

        }
    }

    // Move area - top section
    MouseArea {
        id: moveArea
        anchors.left: dialogWindow.left
        anchors.right: dialogWindow.right
        anchors.top: dialogWindow.top
        height: 30
        width: dialogWindow.width
        anchors.margins: 8
        propagateComposedEvents: true
        onPressed: {
            if (!dialogWindow.locked)
                dialogWindow.startSystemMove();
        }
    }

    // Top-left corner resize
    MouseArea {
        id: topLeftResize
        width: 16
        height: 16
        anchors.left: parent.left
        anchors.top: parent.top
        cursorShape: Qt.SizeFDiagCursor

        onPressed: {
            if (!dialogWindow.locked)
                dialogWindow.startSystemResize(Qt.TopEdge | Qt.LeftEdge);
        }
    }

    // Top-right corner resize
    MouseArea {
        id: topRightResize
        width: 16
        height: 16
        anchors.right: parent.right
        anchors.top: parent.top
        cursorShape: Qt.SizeBDiagCursor

        onPressed: {
            if (!dialogWindow.locked)
                dialogWindow.startSystemResize(Qt.TopEdge | Qt.RightEdge);
        }
    }

    // Bottom-left corner resize
    MouseArea {
        id: bottomLeftResize
        width: 16
        height: 16
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        cursorShape: Qt.SizeBDiagCursor

        onPressed: {
            if (!dialogWindow.locked)
                dialogWindow.startSystemResize(Qt.BottomEdge | Qt.LeftEdge);
        }
    }

    // Bottom-right corner resize
    MouseArea {
        id: bottomRightResize
        width: 16
        height: 16
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        cursorShape: Qt.SizeFDiagCursor

        onPressed: {
            if (!dialogWindow.locked)
                dialogWindow.startSystemResize(Qt.BottomEdge | Qt.RightEdge);
        }
    }

    // Top edge resize
    MouseArea {
        id: topResize
        height: 8
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        cursorShape: Qt.SizeVerCursor

        onPressed: {
            if (!dialogWindow.locked)
                dialogWindow.startSystemResize(Qt.TopEdge);
        }
    }

    // Bottom edge resize
    MouseArea {
        id: bottomResize
        height: 8
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        cursorShape: Qt.SizeVerCursor

        onPressed: {
            if (!dialogWindow.locked)
                dialogWindow.startSystemResize(Qt.BottomEdge);
        }
    }

    // Left edge resize
    MouseArea {
        id: leftResize
        width: 8
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.topMargin: 16
        anchors.bottomMargin: 16
        cursorShape: Qt.SizeHorCursor

        onPressed: {
            if (!dialogWindow.locked)
                dialogWindow.startSystemResize(Qt.LeftEdge);
        }
    }

    // Right edge resize
    MouseArea {
        id: rightResize
        width: 8
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.topMargin: 16
        anchors.bottomMargin: 16
        cursorShape: Qt.SizeHorCursor

        onPressed: {
            if (!dialogWindow.locked)
                dialogWindow.startSystemResize(Qt.RightEdge);
        }
    }
}
