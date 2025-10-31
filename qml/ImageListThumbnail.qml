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

    // Semi-transparent overlay for darkening on hover
    Rectangle {
        anchors.fill: parent
        color: parent.hovered ? "#66000000" : "transparent"  // Dark overlay on hover
        radius: 12
        z: 1
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
        anchors.fill: parent
        preventStealing: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton

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
                var previewWindowComponent = Qt.createComponent("PreviewWindow.qml");

                if (previewWindowComponent.status === Component.Ready) {
                    imageDelegate.previewWindow = previewWindowComponent.createObject(null);
                    if (imageDelegate.previewWindow) {
                        imageDelegate.previewWindow.uri = imageDelegate.uri;
                        imageDelegate.previewWindow.width = Math.max(300, imageDelegate.width * 1.5);
                        imageDelegate.previewWindow.height = imageDelegate.previewWindow.width / imageDelegate.width * imageDelegate.height;
                        imageDelegate.previewWindow.imageWidth = Math.max(300, imageDelegate.width * 1.5);
                        imageDelegate.previewWindow.imageHeight = imageDelegate.previewWindow.imageWidth / imageDelegate.width * imageDelegate.height;
                        imageDelegate.previewWindow.minimumWidth = Math.max(imageDelegate.width * 0.4, 150);
                        imageDelegate.previewWindow.minimumHeight = Math.max(imageDelegate.height * 0.4, 150);
                        imageDelegate.previewWindow.show();
                    }
                }
            } else if (mouse.button === Qt.RightButton) {
                console.log("Right clicked on image:", imageDelegate.uri);
                if(imageDelegate.previewWindow){
                    imageDelegate.previewWindow.close();
                    imageDelegate.previewWindow = null;
                }
                imageDelegate.imageDeleted(imageDelegate.index);

            }
        }
    }
}
