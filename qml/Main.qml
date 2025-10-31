import QtQuick
import Qt.labs.platform

Window {
    id: mainWindow
    width: 200
    height: 500
    minimumWidth: 150
    maximumWidth: 400
    x: 30
    y: (Screen.desktopAvailableHeight - height) / 2
    visible: true
    title: qsTr("Collective")

    flags: Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    color: "transparent"

    property bool isDragging: false
    property int snapThreshold: 200 // pixels from edge to trigger snap
    property int edgePadding: 30 // padding from screen edges when snapping

    property int currentImageListKey: 0
    property var imageListMap: ({})

    // Check if window is snapped to left edge
    property bool isSnappedToLeft: Math.abs(x - edgePadding) < 5

    // Check if window is snapped to right edge
    property bool isSnappedToRight: Math.abs(x - (Screen.desktopAvailableWidth - width - edgePadding)) < 5

    // MouseArea {
    //   id: dragArea
    //   anchors.fill: parent
    //   acceptedButtons: Qt.LeftButton
    //   propagateComposedEvents: true

    //   onPressed: function(mouse) {
    //     isDragging = true
    //     console.log("Mouse pressed - ready for edge snapping")
    //     mouse.accepted = true
    //   }

    //   onReleased: function(mouse) {
    //     isDragging = false
    //     console.log("Mouse released - checking for edge snap at position:", mouse.x, mouse.y)
    //     mouse.accepted = true
    //     snapToEdges(mouse.x)
    //   }
    // }

    SystemTrayIcon {
        visible: true
        tooltip: "Collective"
        icon.source: "qrc:/qt/qml/collective/assets/icon.png"

        onActivated: reason => {
            if (reason === SystemTrayIcon.Trigger) {
                mainWindow.show();
            }
        }
    }

    Shortcut {
        sequence: "Alt+C"
        onActivated: {
            if (mainWindow.visible) {
                mainWindow.hide();
            } else {
                mainWindow.show();
            }
        }
    }

    // Function to snap window to screen edges based on mouse position
    function snapToEdges(mouseX) {
        var screenWidth = Screen.desktopAvailableWidth;
        var screenHeight = Screen.desktopAvailableHeight;

        // Calculate the absolute mouse position on screen
        var absoluteMouseX = mainWindow.x + mouseX;

        // Snap to left edge with padding
        if (absoluteMouseX < snapThreshold) {
            snapToLeft.start();
        } else
        // Snap to right edge with padding
        if (absoluteMouseX > screenWidth - snapThreshold) {
            snapToRight.start();
        } else {
            console.log("No edge snap - mouse position:", absoluteMouseX);
        }

        // Keep window within screen bounds vertically
        if (mainWindow.y < 0) {
            mainWindow.y = 0;
        } else if (mainWindow.y > screenHeight - mainWindow.height) {
            mainWindow.y = screenHeight - mainWindow.height;
        }
    }

    // Animation for snapping to left edge with padding
    NumberAnimation {
        id: snapToLeft
        target: mainWindow
        property: "x"
        to: edgePadding
        duration: 500
        easing.type: Easing.OutCubic
    }

    // Animation for snapping to right edge with padding
    NumberAnimation {
        id: snapToRight
        target: mainWindow
        property: "x"
        to: Screen.desktopAvailableWidth - mainWindow.width - edgePadding
        duration: 500
        easing.type: Easing.OutCubic
    }

    Row {
        id: mainDock
        anchors.fill: parent
        spacing: 10
        layoutDirection: isSnappedToLeft ? Qt.LeftToRight : Qt.RightToLeft
        //anchors.verticalCenter: parent.verticalCenter

        function addImageList(key: int) {
            var initialImageListComponent = Qt.createComponent("ImageList.qml");
            if (initialImageListComponent.status === Component.Ready) {
                var initialImageList = initialImageListComponent.createObject(listContainer);
                if (initialImageList !== null) {
                    initialImageList.key = key;
                    mainWindow.imageListMap[key] = initialImageList;
                }
            } else {
                console.log(initialImageListComponent.errorString());
            }
        }

        Rectangle {
            id: rect
            radius: 20
            height: parent.height
            width: parent.width - 50
            color: "#1A1A1A"
            clip: true

            border.color: "#22ffffff"
            border.width: 0.5

            Component.onCompleted: {
                mainDock.addImageList(0);
            }

            // Add drag functionality to the main rectangle
            MouseArea {
                id: dragArea
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                propagateComposedEvents: true
                drag.target: mainWindow
                drag.axis: Drag.XAndYAxis
                cursorShape: isDragging ? Qt.ClosedHandCursor : Qt.OpenHandCursor

                onPressed: function (mouse) {
                    isDragging = true;
                    console.log("Mouse pressed - ready for edge snapping");
                    mouse.accepted = true;
                }

                onReleased: function (mouse) {
                    isDragging = false;
                    console.log("Mouse released - checking for edge snap at position:", mouse.x, mouse.y);
                    mouse.accepted = true;
                    snapToEdges(mouse.x);
                }
            }

            Row {
                anchors.fill: parent

                // Left resize handle - only active when snapped to right
                MouseArea {
                    id: leftResizeHandle
                    width: 10
                    height: parent.height
                    cursorShape: Qt.SizeHorCursor
                    drag.axis: Drag.XAxis
                    enabled: isSnappedToRight

                    property bool isResizing: false
                    property int startX: 0

                    onPressed: mouse => {
                        if (isSnappedToRight) {
                            mainWindow.startSystemResize(Qt.LeftEdge);
                        }
                    }
                }

                Item {
                    id: listContainer
                    width: parent.width - 20
                    height: parent.height
                }

                // Right resize handle - only active when snapped to left
                MouseArea {
                    id: rightResizeHandle
                    width: 10
                    height: parent.height
                    cursorShape: Qt.SizeHorCursor
                    enabled: isSnappedToLeft

                    onPressed: mouse => {
                        if (isSnappedToLeft) {
                            mainWindow.startSystemResize(Qt.RightEdge);
                        }
                    }
                }
            }
        }

        Rectangle {
            id: optionsDock
            width: 40
            height: contentColumn.implicitHeight + 15
            anchors.verticalCenter: parent.verticalCenter
            color: "#1a1a1a"
            radius: 10

            border.width: 0.5
            border.color: "#22ffffff"

            property bool isHovering: false

            Column {
                id: contentColumn
                spacing: 5
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter

                WorkspaceSwitcher {
                    id: workspaceSwitcher
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width - 10

                    onWorkspaceCreated: key => {
                        mainDock.addImageList(key);
                        mainWindow.imageListMap[mainWindow.currentImageListKey].visible = false;
                        mainWindow.currentImageListKey = key;
                        mainWindow.imageListMap[key].visible = true;
                    }

                    onCurrentWorkspaceChanged: {
                        mainWindow.imageListMap[mainWindow.currentImageListKey].visible = false;

                        mainWindow.currentImageListKey = workspaceSwitcher.currentWorkspace;
                        mainWindow.imageListMap[workspaceSwitcher.currentWorkspace].visible = true;
                    }

                    onWorkspaceDeleted: key => {
                        mainWindow.imageListMap[key].destroy();
                        mainWindow.imageListMap[key] = undefined;
                    }
                }

                Rectangle {
                    width: parent.width - 10
                    height: 1
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#22ffffff"

                    visible: optionsDock.isHovering && false
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                propagateComposedEvents: true

                onEntered: {
                    parent.isHovering = true;
                }

                onExited: {
                    parent.isHovering = false;
                }
            }
        }
    }
}
