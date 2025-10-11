import QtQuick

Window {
  id: mainWindow
  width: rect.width
  height: rect.height
  x: 30
  y: (Screen.desktopAvailableHeight - height) / 2
  visible: true
  title: qsTr("Collective")

  flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
  color: "transparent"

  property bool isDragging: false
  property int snapThreshold: 200 // pixels from edge to trigger snap
  property int edgePadding: 30 // padding from screen edges when snapping

  DropArea{
    anchors.fill: parent
    onDropped: {
      console.log(drop.text)
    }
  }

  // MouseArea for edge snapping only
  MouseArea {
    id: dragArea
    anchors.fill: parent
    acceptedButtons: Qt.LeftButton
    propagateComposedEvents: true
    
    onPressed: function(mouse) {
      isDragging = true
      console.log("Mouse pressed - ready for edge snapping")
      mouse.accepted = true
    }
    
    onReleased: function(mouse) {
      isDragging = false
      console.log("Mouse released - checking for edge snap at position:", mouse.x, mouse.y)
      mouse.accepted = true
      snapToEdges(mouse.x)
    }
  }

  // Function to snap window to screen edges based on mouse position
  function snapToEdges(mouseX) {
    var screenWidth = Screen.desktopAvailableWidth
    var screenHeight = Screen.desktopAvailableHeight
    
    // Calculate the absolute mouse position on screen
    var absoluteMouseX = mainWindow.x + mouseX
    
    console.log("Absolute mouse X position:", absoluteMouseX, "Screen width:", screenWidth)
    
    // Snap to left edge with padding
    if (absoluteMouseX < snapThreshold) {
      console.log("Snapping to left edge")
      snapToLeft.start()
    }
    // Snap to right edge with padding
    else if (absoluteMouseX > screenWidth - snapThreshold) {
      console.log("Snapping to right edge")
      snapToRight.start()
    }
    else {
      console.log("No edge snap - mouse position:", absoluteMouseX)
    }
    
    // Keep window within screen bounds vertically
    if (mainWindow.y < 0) {
      mainWindow.y = 0
    } else if (mainWindow.y > screenHeight - mainWindow.height) {
      mainWindow.y = screenHeight - mainWindow.height
    }
  }

  // Animation for snapping to left edge with padding
  NumberAnimation {
    id: snapToLeft
    target: mainWindow
    property: "x"
    to: edgePadding
    duration: 500
    easing.type: Easing.OutCubic
  }

  // Animation for snapping to right edge with padding
  NumberAnimation {
    id: snapToRight
    target: mainWindow
    property: "x"
    to: Screen.desktopAvailableWidth - mainWindow.width - edgePadding
    duration: 500
    easing.type: Easing.OutCubic
  }

  Rectangle {
    id: rect
    width: 200
    height: 500

    radius: 20
    color: "#1A1A1A"

    border.color: "#22ffffff"
    border.width: 0.5
    
    Column {
        anchors.centerIn: parent
        spacing: 20
        
        Image {
            id: dragImage
            source: "assets/drag.png"
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

  }
}
