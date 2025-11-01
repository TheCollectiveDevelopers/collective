pragma ComponentBehavior: Bound
import QtQuick
import Qt5Compat.GraphicalEffects

Window {
    id: previewWindow
    width: 400
    height: 400
    flags: Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    color: "transparent"

    property string uri
    property int resizeMargin: 8
    property int cornerSize: 16

    property int imageWidth: 400
    property int imageHeight: 400

    property bool locked: false
    property bool isRotating: false
    property bool isOpacity: false
    property bool isMirrored: false

    Rectangle {
        id: previewImageRectangle
        anchors.fill: parent
        color: "#1a1a1a"

        radius: 17

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                width: previewImageRectangle.width
                height: previewImageRectangle.height
                radius: 17
            }
        }
        property real updatedImageWidth: 400
        property real updatedImageHeight: 400
        property real globalScalingFactor: 1
        property real globalRotationAngle: 0

        function updateImageSize() {
            var scalingFactor = 0;

            if (previewImageRectangle.width > previewImageRectangle.height) {
                scalingFactor = (previewImageRectangle.width) / previewWindow.imageWidth;
            } else {
                scalingFactor = (previewImageRectangle.height) / previewWindow.imageHeight;
            }
            previewImageRectangle.updatedImageWidth = previewWindow.imageWidth * scalingFactor;
            previewImageRectangle.updatedImageHeight = previewWindow.imageHeight * scalingFactor;
        }

        onWidthChanged: updateImageSize()
        onHeightChanged: updateImageSize()

        AnimatedImage {
            id: previewImage
            width: previewImageRectangle.updatedImageWidth * previewImageRectangle.globalScalingFactor
            height: previewImageRectangle.updatedImageHeight * previewImageRectangle.globalScalingFactor
            rotation: previewImageRectangle.globalRotationAngle

            mirror: previewWindow.isMirrored
            fillMode: Image.PreserveAspectCrop
            smooth: true

            source: previewWindow.uri
        }

        MouseArea {
            id: imageMoveArea
            anchors.fill: parent
            propagateComposedEvents: true
            drag.target: !previewWindow.isRotating ? previewImage : undefined
            enabled: !previewWindow.locked

            property real startAngle: 0
            property real startGlobalRotation: 0

            function angleFromCenter(x, y) {
                var centerX = width / 2;
                var centerY = height / 2;
                return Math.atan2(y - centerY, x - centerX) * 180 / Math.PI;
            }

            onPressed: {
                startAngle = angleFromCenter(mouseX, mouseY);
                startGlobalRotation = previewImageRectangle.globalRotationAngle;
            }

            onDoubleClicked: {
                previewImage.x = 0;
                previewImage.y = 0;
                previewImageRectangle.globalScalingFactor = 1;
                previewImageRectangle.globalRotationAngle = 0;
            }

            onWheel: {
                var scrollAmount = wheel.angleDelta.y / 120;
                if (previewWindow.isOpacity) {
                    previewImageRectangle.opacity = Math.max(Math.min(previewImageRectangle.opacity + scrollAmount * 0.2, 1), 0.2);
                } else {
                    previewImageRectangle.globalScalingFactor = Math.max(previewImageRectangle.globalScalingFactor + scrollAmount * 0.2, 0.07);
                }
            }

            onPositionChanged: {
                if (pressed && previewWindow.isRotating) {
                    var currentAngle = angleFromCenter(mouseX, mouseY);
                    var angleDelta = currentAngle - startAngle;

                    previewImageRectangle.globalRotationAngle = startGlobalRotation + angleDelta;
                }
            }
        }
    }
    Rectangle {
        id: titleBar
        anchors.margins: 5
        anchors.top: parent.top
        anchors.right: parent.right
        height: 30
        width: contentRow.implicitWidth + 20
        radius: 20
        z: 10
        property bool hovering: false

        color: "#1a1a1a"

        Behavior on width {
            NumberAnimation {
                duration: 300
                easing.type: Easing.InOutQuad
            }
        }

        Row {
            id: contentRow
            spacing: 10
            x: 10
            anchors.verticalCenter: parent.verticalCenter

            Image {
                width: 15
                height: 15
                visible: titleBar.hovering
                source: "qrc:/qt/qml/collective/assets/reflect-white.png"

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        previewWindow.isMirrored = !previewWindow.isMirrored;
                    }
                }
            }

            Image {
                width: 15
                height: 15
                visible: titleBar.hovering && !previewWindow.isOpacity
                source: "qrc:/qt/qml/collective/assets/drop-white.png"

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        previewWindow.isOpacity = true;
                    }
                }
            }

            Image {
                width: 15
                height: 15
                visible: previewWindow.isOpacity
                source: "qrc:/qt/qml/collective/assets/drop-yellow.png"

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        previewWindow.isOpacity = false;
                    }
                }
            }

            Image {
                width: 15
                height: 15
                visible: titleBar.hovering && !previewWindow.isRotating
                source: "qrc:/qt/qml/collective/assets/refresh-white.png"

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        previewWindow.isRotating = true;
                    }
                }
            }

            Image {
                width: 15
                height: 15
                visible: previewWindow.isRotating
                source: "qrc:/qt/qml/collective/assets/refresh-yellow.png"

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        previewWindow.isRotating = false;
                    }
                }
            }

            Image {
                width: 15
                height: 15
                visible: titleBar.hovering && !previewWindow.locked
                source: "qrc:/qt/qml/collective/assets/lock-white.png"

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        previewWindow.locked = true;
                    }
                }
            }

            Image {
                width: 15
                height: 15
                visible: previewWindow.locked
                source: "qrc:/qt/qml/collective/assets/lock-yellow.png"

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        previewWindow.locked = false;
                    }
                }
            }

            Image {
                width: 15
                height: 15
                source: "qrc:/qt/qml/collective/assets/x-white.png"
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        previewWindow.close();
                    }
                }
            }
        }
    }

    MouseArea {
        id: moveArea
        anchors.left: previewWindow.left
        anchors.right: previewWindow.right
        anchors.top: previewWindow.top
        height: 30
        width: previewWindow.width
        anchors.margins: previewWindow.resizeMargin
        propagateComposedEvents: true
        hoverEnabled: true
        onPressed: {
            if (!previewWindow.locked)
                previewWindow.startSystemMove();
        }

        onEntered: {
            titleBar.hovering = true;
        }

        onExited: {
            titleBar.hovering = false;
        }
    }
    // Move area - center of window

    // Top-left corner resize
    MouseArea {
        id: topLeftResize
        width: previewWindow.cornerSize
        height: previewWindow.cornerSize
        anchors.left: parent.left
        anchors.top: parent.top
        cursorShape: Qt.SizeFDiagCursor

        onPressed: {
            if (!previewWindow.locked)
                previewWindow.startSystemResize(Qt.TopEdge | Qt.LeftEdge);
        }
    }

    // Top-right corner resize
    MouseArea {
        id: topRightResize
        width: previewWindow.cornerSize
        height: previewWindow.cornerSize
        anchors.right: parent.right
        anchors.top: parent.top
        cursorShape: Qt.SizeBDiagCursor

        onPressed: {
            if (!previewWindow.locked)
                previewWindow.startSystemResize(Qt.TopEdge | Qt.RightEdge);
        }
    }

    // Bottom-left corner resize
    MouseArea {
        id: bottomLeftResize
        width: previewWindow.cornerSize
        height: previewWindow.cornerSize
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        cursorShape: Qt.SizeBDiagCursor

        onPressed: {
            if (!previewWindow.locked)
                previewWindow.startSystemResize(Qt.BottomEdge | Qt.LeftEdge);
        }
    }

    // Bottom-right corner resize
    MouseArea {
        id: bottomRightResize
        width: previewWindow.cornerSize
        height: previewWindow.cornerSize
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        cursorShape: Qt.SizeFDiagCursor

        onPressed: {
            if (!previewWindow.locked)
                previewWindow.startSystemResize(Qt.BottomEdge | Qt.RightEdge);
        }
    }

    // Top edge resize
    MouseArea {
        id: topResize
        height: previewWindow.resizeMargin
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: cornerSize
        anchors.rightMargin: cornerSize
        cursorShape: Qt.SizeVerCursor

        onPressed: {
            if (!previewWindow.locked)
                previewWindow.startSystemResize(Qt.TopEdge);
        }
    }

    // Bottom edge resize
    MouseArea {
        id: bottomResize
        height: resizeMargin
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: cornerSize
        anchors.rightMargin: cornerSize
        cursorShape: Qt.SizeVerCursor

        onPressed: {
            if (!previewWindow.locked)
                previewWindow.startSystemResize(Qt.BottomEdge);
        }
    }

    // Left edge resize
    MouseArea {
        id: leftResize
        width: resizeMargin
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.topMargin: cornerSize
        anchors.bottomMargin: cornerSize
        cursorShape: Qt.SizeHorCursor

        onPressed: {
            if (!previewWindow.locked)
                previewWindow.startSystemResize(Qt.LeftEdge);
        }
    }

    // Right edge resize
    MouseArea {
        id: rightResize
        width: resizeMargin
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.topMargin: cornerSize
        anchors.bottomMargin: cornerSize
        cursorShape: Qt.SizeHorCursor

        onPressed: {
            if (!previewWindow.locked)
                previewWindow.startSystemResize(Qt.RightEdge);
        }
    }
}
