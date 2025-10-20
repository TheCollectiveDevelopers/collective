import QtQuick

Window {
  id: mainWindow
  width: 200
  height: 500
  x: 30
  y: (Screen.desktopAvailableHeight - height) / 2
  visible: true
  title: qsTr("Collective")

  flags: Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
  color: "transparent"

  property bool isDragging: false
  property int snapThreshold: 200 // pixels from edge to trigger snap
  property int edgePadding: 30 // padding from screen edges when snapping
  
  // Check if window is snapped to left edge
  property bool isSnappedToLeft: Math.abs(x - edgePadding) < 5
  
  // Check if window is snapped to right edge
  property bool isSnappedToRight: Math.abs(x - (Screen.desktopAvailableWidth - width - edgePadding)) < 5

  // MouseArea {
  //   id: dragArea
  //   anchors.fill: parent
  //   acceptedButtons: Qt.LeftButton
  //   propagateComposedEvents: true
    
  //   onPressed: function(mouse) {
  //     isDragging = true
  //     console.log("Mouse pressed - ready for edge snapping")
  //     mouse.accepted = true
  //   }
    
  //   onReleased: function(mouse) {
  //     isDragging = false
  //     console.log("Mouse released - checking for edge snap at position:", mouse.x, mouse.y)
  //     mouse.accepted = true
  //     snapToEdges(mouse.x)
  //   }
  // }

  // Function to snap window to screen edges based on mouse position
  function snapToEdges(mouseX) {
    var screenWidth = Screen.desktopAvailableWidth
    var screenHeight = Screen.desktopAvailableHeight
    
    // Calculate the absolute mouse position on screen
    var absoluteMouseX = mainWindow.x + mouseX
    
    // Snap to left edge with padding
    if (absoluteMouseX < snapThreshold) {
      snapToLeft.start()
    }
    // Snap to right edge with padding
    else if (absoluteMouseX > screenWidth - snapThreshold) {
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
    anchors.fill: parent
    radius: 20
    color: "#1A1A1A"

    border.color: "#22ffffff"
    border.width: 0.5

    // Add drag functionality to the main rectangle
    MouseArea {
      id: dragArea
      anchors.fill: parent
      acceptedButtons: Qt.LeftButton
      propagateComposedEvents: true
      drag.target: mainWindow
      drag.axis: Drag.XAndYAxis
      cursorShape: isDragging ? Qt.ClosedHandCursor : Qt.OpenHandCursor
      
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

    Row {
      anchors.fill: parent
      
      // Left resize handle - only active when snapped to right
      MouseArea{
        id: leftResizeHandle
        width: 10
        height: parent.height
        cursorShape: Qt.SizeHorCursor
        drag.axis: Drag.XAxis
        enabled: isSnappedToRight

        property bool isResizing: false
        property int startX: 0

        onPressed: (mouse) => {
          if (isSnappedToRight) {
            mainWindow.startSystemResize(Qt.LeftEdge)
          }
        }
      }

      ImageList{
        width: parent.width - 20 // Account for both resize handles
        height: parent.height
      }

      // Right resize handle - only active when snapped to left
      MouseArea{
        id: rightResizeHandle
        width: 10
        height: parent.height
        cursorShape: Qt.SizeHorCursor
        enabled: isSnappedToLeft

        onPressed: (mouse) => {
          if (isSnappedToLeft) {
            mainWindow.startSystemResize(Qt.RightEdge)
          }
        }
      }
    }
  }
  
  // Preview window instance
  PreviewWindow {
    id: previewWindow
  }
}