pragma ComponentBehavior: Bound
import QtQuick
import Qt5Compat.GraphicalEffects

AnimatedImage {
    id: imageDelegate
    sourceSize.width: 300
    fillMode: Image.PreserveAspectFit
    required property string uri
    required property int index
    property Window previewWindow: null
    layer.enabled: true
    layer.effect: OpacityMask {
        maskSource: Rectangle {
            width: imageDelegate.width
            height: imageDelegate.height
            radius: 12
        }
    }

    source: uri

    // Hover tracking property
    property bool hovered: false
    signal imageDeleted(index: int)

    // Drag configuration
    Drag.active: dragArea.drag.active
    Drag.dragType: Drag.Automatic
    Drag.supportedActions: Qt.CopyAction
    Drag.mimeData: {
        "text/uri-list": uri
    }

    // Semi-transparent overlay for darkening on hover
    Rectangle {
        anchors.fill: parent
        color: parent.hovered ? "#66000000" : "transparent"  // Dark overlay on hover
        radius: 12
        z: 1
    }

    Rectangle{
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 10
        color: "#1a1a1a"
        visible: previewWindow.locked
        width: 25
        height: 25
        z: 2

        radius: 2

        Image{
            width: 15
            height: 15
            anchors.centerIn: parent
            anchors.margins: 10
            source: "qrc:/qt/qml/collective/assets/lock-yellow.png"

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    previewWindow.locked = false;
                }
            }
        }
    }

    // Animate opacity on appearance
    SequentialAnimation on opacity {
        running: true
        loops: 1
        PropertyAction {
            target: imageDelegate
            property: "opacity"
            value: 0
        }
        NumberAnimation {
            to: 1
            duration: 100
            easing.type: Easing.InOutQuad
        }
    }

    // Animate scale on appearance for emerging effect
    SequentialAnimation on scale {
        running: true
        loops: 1
        PropertyAction {
            target: imageDelegate
            property: "scale"
            value: 0.8
        }
        NumberAnimation {
            to: 1
            duration: 100
            easing.type: Easing.InOutQuad
        }
    }

    MouseArea {
        id: dragArea
        anchors.fill: parent
        preventStealing: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        propagateComposedEvents: true
        drag.target: imageDelegate

        hoverEnabled: true
        onEntered: {
            imageDelegate.hovered = true;
        }
        onExited: {
            imageDelegate.hovered = false;
        }

        onPressed: function (mouse) {
            if (mouse.button === Qt.LeftButton) {
                console.log("Left clicked on image:", imageDelegate.uri);
                previewWindow.show()
            } else if (mouse.button === Qt.RightButton) {
                console.log("Right clicked on image:", imageDelegate.uri);
                if(imageDelegate.previewWindow){
                    imageDelegate.previewWindow.close();
                    imageDelegate.previewWindow = null;
                }
                imageDelegate.imageDeleted(imageDelegate.index);

            }
        }

        onReleased: {
            imageDelegate.Drag.drop()
        }
    }

    PreviewWindow{
        id: previewWindow
        uri: imageDelegate.uri

        onLockedChanged: {
            if(!locked){
                flags = Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
            }
        }

        Component.onCompleted: {
            width = Math.max(300, imageDelegate.width * 1.5)
            height = width / imageDelegate.width * imageDelegate.height
            imageWidth = Math.max(300, imageDelegate.width * 1.5)
            imageHeight = width / imageDelegate.width * imageDelegate.height
            minimumWidth = Math.max(imageDelegate.width * 0.4, 150)
            minimumHeight = Math.max(imageDelegate.height * 0.4, 150)
        }
    }
}
