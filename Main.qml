import QtQuick

Window {
  width: rect.width
  height: rect.height
  x: 30
  y: (Screen.desktopAvailableHeight - height) / 2
  visible: true
  title: qsTr("Collective")

  flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
  color: "transparent"

  DropArea{
    anchors.fill: parent
    onDropped: {
      console.log(drop.text)
    }
  }

  Rectangle {
    id: rect
    width: 200
    height: 500

    radius: 20
    color: "#000000"

    border.color: "#22ffffff"
    border.width: 1


  }
}
