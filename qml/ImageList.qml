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
  }

  Connections{
    target: dropArea
    
    function onEntered(drag: DragEvent){
      drag.accept(Qt.LinkAction)
    }

    function onDropped(drop: DragEvent){
      for(const url of drop.urls){
        imageList.append({
          uri: url
        })
      }
    }
  }

}