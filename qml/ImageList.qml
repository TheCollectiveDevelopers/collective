import QtQuick
import Qt5Compat.GraphicalEffects

Item {
  
  ListModel{
    id: imageList
  }

  ListView{
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
      layer.enabled: true
      layer.effect: OpacityMask {
        maskSource: Rectangle {
          width: imageDelegate.width
          height: imageDelegate.height
          radius: 12
        }
      }

      source: imageDelegate.uri

      Drag.dragType: Drag.Automatic
      Drag.proposedAction: Qt.CopyAction
      Drag.supportedActions: Qt.CopyAction
      Drag.mimeData: {
        "text/uri-list": imageDelegate.uri,
        "text/plain": imageDelegate.uri
      }

      MouseArea {
        anchors.fill: parent
        preventStealing: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        
        onPressed: function(mouse) {
          if (mouse.button === Qt.LeftButton) {
            // Left click - open preview
            console.log("Left clicked on image:", imageDelegate.uri)
            if (typeof previewWindow !== 'undefined') {
              previewWindow.showPreview(imageDelegate.uri)
            }
          } else if (mouse.button === Qt.RightButton) {
            // Right click - start drag
            console.log("Right clicked on image:", imageDelegate.uri)
            imageDelegate.Drag.start(Qt.CopyAction)
          }
        }
        
        onReleased: function(mouse) {
          if (mouse.button === Qt.RightButton) {
            imageDelegate.Drag.drop()
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

  DropArea{
    id: dropArea
    anchors.fill: parent
    z: 1 // Ensure it's above the MouseArea
  }

  Connections{
    target: dropArea
    
    function onEntered(drag: DragEvent){
      console.log("Drag entered - hasUrls:", drag.hasUrls, "formats:", drag.formats)
      if(drag.hasUrls) {
        drag.accept(Qt.LinkAction)
        console.log("Drag accepted with LinkAction")
      }
    }

    function onDropped(drop: DragEvent){
      console.log("Drop event - hasUrls:", drop.hasUrls, "urls:", drop.urls)
      if(drop.hasUrls) {
        for(const url of drop.urls){
          console.log("Adding URL:", url)
          imageList.append({
            uri: url
          })
        }
        drop.accept(Qt.LinkAction)
      }
    }
  }

}