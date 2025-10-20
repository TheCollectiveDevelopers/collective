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
    color: "#1a1a1a"
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
    width: 15
    height: 15
    color: "#E9524A"
    radius: 10
    x: parent.width - 30
    y: parent.y + 10

    MouseArea{
      anchors.fill: parent
      cursorShape: Qt.ArrowCursor
      onClicked: {
        previewWindow.close()
      }
    }
  }


  // Move area - center of window
  MouseArea {
    id: moveArea
    anchors.fill: parent
    anchors.margins: resizeMargin
    cursorShape: Qt.SizeAllCursor
    propagateComposedEvents: true
    
    onPressed: {
      previewWindow.startSystemMove()
    }
  }

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
