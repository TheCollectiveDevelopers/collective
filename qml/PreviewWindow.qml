import QtQuick
import Qt5Compat.GraphicalEffects

Window{
  id: previewWindow
  width: 400
  height: 400
  flags: Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
  color: "transparent"

  property string uri
  property int resizeMargin: 8
  property int cornerSize: 16

  Rectangle{
    id: previewImageRectangle
    anchors.fill: parent
    color: "black"
    radius: 17
    
    AnimatedImage{
      id: previewImage
      anchors.fill: parent
      anchors.margins: 5
      fillMode: Image.PreserveAspectCrop
      layer.enabled: true
      layer.effect: OpacityMask {
        maskSource: Rectangle {
          width: previewImage.width
          height: previewImage.height
          radius: 12
        }
      }

      source: previewWindow.uri
    }
  }


  Rectangle{
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    height: 30
    width: childrenRect.width + 20
    bottomLeftRadius: 40
    bottomRightRadius: 40

    color: "black"

    MouseArea {
      id: moveArea
      anchors.fill: parent
      anchors.margins: resizeMargin
      propagateComposedEvents: true
      
      onPressed: {
        previewWindow.startSystemMove()
      }
    }

    Row{
      spacing: 10
      anchors.centerIn: parent

      Image{
        width: 15
        height: 15
        visible: false
        source: "qrc:/qt/qml/collective/assets/refresh-white.png"
      }

      Text{
        text: previewWindow.uri.split("/").pop().slice(0, 20)
        color: "#efefef"
        font.pixelSize: 12
        font.weight: Font.Bold
      }

      Image{
        width: 15
        height: 15
        source: "qrc:/qt/qml/collective/assets/x-white.png"
        MouseArea{
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor

          onClicked: {
            previewWindow.close()
          }
        }
      }
    }
  }


  // Move area - center of window
  

  // Top-left corner resize
  MouseArea {
    id: topLeftResize
    width: cornerSize
    height: cornerSize
    anchors.left: parent.left
    anchors.top: parent.top
    cursorShape: Qt.SizeFDiagCursor
    
    onPressed: {
      previewWindow.startSystemResize(Qt.TopEdge | Qt.LeftEdge)
    }
  }

  // Top-right corner resize
  MouseArea {
    id: topRightResize
    width: cornerSize
    height: cornerSize
    anchors.right: parent.right
    anchors.top: parent.top
    cursorShape: Qt.SizeBDiagCursor
    
    onPressed: {
      previewWindow.startSystemResize(Qt.TopEdge | Qt.RightEdge)
    }
  }

  // Bottom-left corner resize
  MouseArea {
    id: bottomLeftResize
    width: cornerSize
    height: cornerSize
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    cursorShape: Qt.SizeBDiagCursor
    
    onPressed: {
      previewWindow.startSystemResize(Qt.BottomEdge | Qt.LeftEdge)
    }
  }

  // Bottom-right corner resize
  MouseArea {
    id: bottomRightResize
    width: cornerSize
    height: cornerSize
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    cursorShape: Qt.SizeFDiagCursor
    
    onPressed: {
      previewWindow.startSystemResize(Qt.BottomEdge | Qt.RightEdge)
    }
  }

  // Top edge resize
  MouseArea {
    id: topResize
    height: resizeMargin
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.leftMargin: cornerSize
    anchors.rightMargin: cornerSize
    cursorShape: Qt.SizeVerCursor
    
    onPressed: {
      previewWindow.startSystemResize(Qt.TopEdge)
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
      previewWindow.startSystemResize(Qt.BottomEdge)
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
      previewWindow.startSystemResize(Qt.LeftEdge)
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
      previewWindow.startSystemResize(Qt.RightEdge)
    }
  }
}
