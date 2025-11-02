import QtQuick

Window{
    id: recordPlayerWindow
    width: 300
    height: 300
    flags: Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    color: "transparent"

    property bool locked: false
    required property string song


    Rectangle {
        anchors.fill: parent
        radius: 17
        border.width: 0.5
        border.color: "#22ffffff"
        color: "#141414"

        Column{
            anchors.fill: parent
            spacing: 10

            Item{
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 10
                height: 40

                Rectangle{
                    height: parent.height
                    anchors.left: parent.left
                    color: "#1F1F1F"

                    Text{
                        text: recordPlayerWindow.song
                        color: "#A2A2A2"
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
            if (!recordPlayerWindow.locked)
                recordPlayerWindow.startSystemMove();
        }
    }

    MouseArea {
        id: topLeftResize
        width: 16
        height: 16
        anchors.left: parent.left
        anchors.top: parent.top
        cursorShape: Qt.SizeFDiagCursor

        onPressed: {
            if (!recordPlayerWindow.locked)
                recordPlayerWindow.startSystemResize(Qt.TopEdge | Qt.LeftEdge);
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
            if (!recordPlayerWindow.locked)
                recordPlayerWindow.startSystemResize(Qt.TopEdge | Qt.RightEdge);
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
            if (!recordPlayerWindow.locked)
                recordPlayerWindow.startSystemResize(Qt.BottomEdge | Qt.LeftEdge);
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
            if (!recordPlayerWindow.locked)
                recordPlayerWindow.startSystemResize(Qt.BottomEdge | Qt.RightEdge);
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
            if (!recordPlayerWindow.locked)
                recordPlayerWindow.startSystemResize(Qt.TopEdge);
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
            if (!recordPlayerWindow.locked)
                recordPlayerWindow.startSystemResize(Qt.BottomEdge);
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
            if (!recordPlayerWindow.locked)
                recordPlayerWindow.startSystemResize(Qt.LeftEdge);
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
            if (!recordPlayerWindow.locked)
                recordPlayerWindow.startSystemResize(Qt.RightEdge);
        }
    }
}
