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
    id: titleBar
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    height: 30
    width: contentRow.implicitWidth + 20
    bottomLeftRadius: 40
    bottomRightRadius: 40

    property bool hovering: false

    color: "black"

    Behavior on width {
      NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
    }

    Row{
      id: contentRow
      spacing: 10
      x: 10
      anchors.verticalCenter: parent.verticalCenter

      Image{
        width: 15
        height: 15
        visible: titleBar.hovering
        source: "qrc:/qt/qml/collective/assets/refresh-white.png"
      }

      Image{
        width: 15
        height: 15
        visible: titleBar.hovering
        source: "qrc:/qt/qml/collective/assets/lock-white.png"
      }

      Image{
        width: 15
        height: 15
        visible: titleBar.hovering
        source: "qrc:/qt/qml/collective/assets/zoom-white.png"
      }

      Text{
        text: previewWindow.uri.split("/").pop().slice(0, 20)
        color: "#efefef"
        font.pixelSize: 12
        font.weight: Font.Bold
        visible: !titleBar.hovering
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

  MouseArea {
    id: moveArea
    anchors.left: previewWindow.left
    anchors.right: previewWindow.right
    anchors.top: previewWindow.top
    height: 30
    width: previewWindow.width
    anchors.margins: resizeMargin
    propagateComposedEvents: true
    hoverEnabled: true
    onPressed: {
       previewWindow.startSystemMove()
    }

    onEntered: {
      titleBar.hovering = true
    }

    onExited: {
      titleBar.hovering = false
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
