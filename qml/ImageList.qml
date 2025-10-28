import QtQuick
import Qt5Compat.GraphicalEffects

Item {
  
  ListModel {
    id: imageList
  }

  ListView {
    id: listView
    anchors.fill: parent
    anchors.margins: 10
    anchors.leftMargin: 0
    anchors.rightMargin: 0
    visible: imageList.count > 0
    spacing: 10
    layer.enabled: true
    layer.effect: OpacityMask {
      maskSource: Rectangle {
        width: listView.width
        height: listView.height
        radius: 12
      }
    }

    model: imageList
    
    delegate: AnimatedImage {
      id: imageDelegate
      width: parent.width
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

      source: imageDelegate.uri

      // Hover tracking property
      property bool hovered: false

      // Semi-transparent overlay for darkening on hover
      Rectangle {
        anchors.fill: parent
        color: hovered ? "#66000000" : "transparent"  // Dark overlay on hover
        radius: 12
        z: 1
      }

      // Animate opacity on appearance
      SequentialAnimation on opacity {
        running: true
        loops: 1
        PropertyAction { target: imageDelegate; property: "opacity"; value: 0 }
        NumberAnimation { to: 1; duration: 100; easing.type: Easing.InOutQuad }
      }

      // Animate scale on appearance for emerging effect
      SequentialAnimation on scale {
        running: true
        loops: 1
        PropertyAction { target: imageDelegate; property: "scale"; value: 0.8 }
        NumberAnimation { to: 1; duration: 100; easing.type: Easing.InOutQuad }
      }

      MouseArea {
        anchors.fill: parent
        preventStealing: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        hoverEnabled: true
        onEntered: {
          imageDelegate.hovered = true
        }
        onExited: {
          imageDelegate.hovered = false
        }

        onPressed: function(mouse) {
          if (mouse.button === Qt.LeftButton) {
            console.log("Left clicked on image:", imageDelegate.uri)
            var previewWindowComponent = Qt.createComponent("PreviewWindow.qml")

            if(previewWindowComponent.status === Component.Ready){
              previewWindow = previewWindowComponent.createObject(null)
              if(previewWindow) {
                previewWindow.uri = imageDelegate.uri
                previewWindow.width = imageDelegate.width * 1.5;
                previewWindow.height = imageDelegate.height * 1.5;
                previewWindow.imageWidth = imageDelegate.width * 1.5;
                previewWindow.imageHeight = imageDelegate.height * 1.5;
                previewWindow.show()
              }
            }
          } else if (mouse.button === Qt.RightButton) {
            console.log("Right clicked on image:", imageDelegate.uri)
            for(var i=0; i<imageList.count; i++){
              if(imageList.get(i).index === imageDelegate.index){
                console.log(i)
                if(previewWindow){
                  previewWindow.close()
                  previewWindow = null
                }
                imageList.remove(i, 1)
                break
              }
            }
          }
        }

      }
    }
  }

  Column {
    anchors.centerIn: parent
    spacing: 20
    id: emptyLayout
    visible: imageList.count == 0

    Image {
      id: dragImage
      source: "qrc:/qt/qml/collective/assets/drag.png"
      width: 64
      height: 64
      anchors.horizontalCenter: parent.horizontalCenter
    }

    Text {
      id: dragText
      text: "Drag and Drop"
      color: "white"
      font.pixelSize: 18
      font.family: "Arial"
      anchors.horizontalCenter: parent.horizontalCenter
    }
  }

  DropArea {
    id: dropArea
    anchors.fill: parent
    z: 1 // Ensure it's above the MouseArea
  }

  Connections {
    target: dropArea

    function onEntered(drag) {
      console.log("Drag entered - hasUrls:", drag.hasUrls, "formats:", drag.formats)
      if (drag.hasUrls) {
        drag.accept(Qt.LinkAction)
        console.log("Drag accepted with LinkAction")
      }
    }

    function onDropped(drop) {
      console.log("Drop event - hasUrls:", drop.hasUrls, "urls:", drop.urls)
      if (drop.hasUrls) {
        for (const url of drop.urls) {
          console.log("Adding URL:", url)
          imageList.append({
            uri: url,
            index: imageList.count
          })
        }
        drop.accept(Qt.LinkAction)
      }
    }
  }
}
