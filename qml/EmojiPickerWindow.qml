import QtQuick
import "qrc:/qt/qml/collective/qml/emojis.js" as EmojiScript

Window{
  id: emojiWindow
  width: 300
  height: 300
  flags: Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
  color: "transparent"

  signal emojiPressed(emoji: string)

  ListModel{
    id: emojiList
  }

  Rectangle{
    anchors.fill: parent
    radius: 17
    border.width: 0.5
    border.color: "#22ffffff"
    color: "#1a1a1a"

    Component.onCompleted: {
      for(var emoji of EmojiScript.emojis){
        emojiList.append({
          emoji: emoji
        })
      }
    }

    Column{
      anchors.fill: parent
      anchors.margins: 10
      spacing: 10

      Rectangle{
        id: close
        anchors.right: parent.right
        width: 30
        height: 30
        radius: 30
        color: "#55000000"
        z: 10

        Image{
          anchors.fill: parent
          anchors.centerIn: parent
          anchors.margins: 7

          source: "qrc:/qt/qml/collective/assets/x-white.png"
        }

        MouseArea{
          anchors.fill: parent
          
          onClicked: {
            emojiWindow.close()
          }
        }
      }

      GridView{
        id: emojiGrid
        model: emojiList
        width: parent.width
        height: parent.height - 20
        cellWidth: 40
        cellHeight: 40


        delegate: Rectangle{
          width: 35
          height: 35
          color: "transparent"
          radius: 10
          required property string emoji

          Text{
            anchors.centerIn: parent
            text: parent.emoji
            font.pixelSize: 24
          }

          MouseArea{
            anchors.fill: parent
            hoverEnabled: true
            propagateComposedEvents: true

            onEntered: {
              parent.color = "#88000000"
            }

            onExited: {
              parent.color = "transparent"
            }

            onClicked: {
              emojiWindow.emojiPressed(parent.emoji)
            }
          }
        }
      }
    }
  }


  MouseArea {
    id: moveArea
    anchors.left: emojiWindow.left
    anchors.right: emojiWindow.right
    anchors.top: emojiWindow.top
    height: 30
    width: emojiWindow.width
    anchors.margins: 8
    propagateComposedEvents: true
    onPressed: {
      if(!emojiWindow.locked) emojiWindow.startSystemMove()
    } 
  }

  MouseArea {
    id: topLeftResize
    width: 16
    height: 16
    anchors.left: parent.left
    anchors.top: parent.top
    cursorShape: Qt.SizeFDiagCursor
    
    onPressed: {
      if(!emojiWindow.locked) emojiWindow.startSystemResize(Qt.TopEdge | Qt.LeftEdge)
    }
  }

  // Top-right corner resize
  MouseArea {
    id: topRightResize
    width: 16
    height: 16
    anchors.right: parent.right
    anchors.top: parent.top
    cursorShape: Qt.SizeBDiagCursor
    
    onPressed: {
      if(!emojiWindow.locked) emojiWindow.startSystemResize(Qt.TopEdge | Qt.RightEdge)
    }
  }

  // Bottom-left corner resize
  MouseArea {
    id: bottomLeftResize
    width: 16
    height: 16
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    cursorShape: Qt.SizeBDiagCursor
    
    onPressed: {
      if(!emojiWindow.locked) emojiWindow.startSystemResize(Qt.BottomEdge | Qt.LeftEdge)
    }
  }

  // Bottom-right corner resize
  MouseArea {
    id: bottomRightResize
    width: 16
    height: 16
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    cursorShape: Qt.SizeFDiagCursor
    
    onPressed: {
      if(!emojiWindow.locked) emojiWindow.startSystemResize(Qt.BottomEdge | Qt.RightEdge)
    }
  }

  // Top edge resize
  MouseArea {
    id: topResize
    height: 8
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.leftMargin: 16
    anchors.rightMargin: 16
    cursorShape: Qt.SizeVerCursor
    
    onPressed: {
      if(!emojiWindow.locked) emojiWindow.startSystemResize(Qt.TopEdge)
    }
  }

  // Bottom edge resize
  MouseArea {
    id: bottomResize
    height: 8
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    anchors.leftMargin: 16
    anchors.rightMargin: 16
    cursorShape: Qt.SizeVerCursor
    
    onPressed: {
      if(!emojiWindow.locked) emojiWindow.startSystemResize(Qt.BottomEdge)
    }
  }

  // Left edge resize
  MouseArea {
    id: leftResize
    width: 8
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.topMargin: 16
    anchors.bottomMargin: 16
    cursorShape: Qt.SizeHorCursor
    
    onPressed: {
      if(!emojiWindow.locked) emojiWindow.startSystemResize(Qt.LeftEdge)
    }
  }

  // Right edge resize
  MouseArea {
    id: rightResize
    width: 8
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.topMargin: 16
    anchors.bottomMargin: 16
    cursorShape: Qt.SizeHorCursor
    
    onPressed: {
      if(!emojiWindow.locked) emojiWindow.startSystemResize(Qt.RightEdge)
    }
  }}
