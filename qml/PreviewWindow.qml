import QtQuick
import QtQuick.Window

Window {
    id: previewWindow
    width: 800
    height: 600
    visible: false
    title: "Image Preview"
    flags: Qt.Window | Qt.FramelessWindowHint
    
    property string imageUri: ""
    property real imageAspectRatio: 1.0
    
    color: "transparent"
    
    Rectangle {
        id: previewContainer
        anchors.fill: parent
        color: "#1A1A1A"
        radius: 15
        
        // Window drag area (entire window)
        MouseArea {
            id: windowDragArea
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton
            cursorShape: Qt.OpenHandCursor
            hoverEnabled: true
            
            property bool isDragging: false
            property point dragStartPos
            
            onPressed: function(mouse) {
                isDragging = true
                cursorShape = Qt.ClosedHandCursor
                dragStartPos = Qt.point(mouse.x, mouse.y)
            }
            
            onMouseXChanged: {
                if (isDragging) {
                    previewWindow.x += mouseX - dragStartPos.x
                    dragStartPos.x = mouseX
                }
            }
            
            onMouseYChanged: {
                if (isDragging) {
                    previewWindow.y += mouseY - dragStartPos.y
                    dragStartPos.y = mouseY
                }
            }
            
            onReleased: function(mouse) {
                isDragging = false
                cursorShape = Qt.OpenHandCursor
            }
        }
        
        // Main image display with pan functionality
        Item {
            id: imageContainer
            anchors.fill: parent
            anchors.margins: 8
            clip: true
            
            AnimatedImage {
                id: previewImage
                anchors.centerIn: parent
                width: Math.min(parent.width, parent.height * imageAspectRatio)
                height: Math.min(parent.height, parent.width / imageAspectRatio)
                fillMode: Image.PreserveAspectFit
                source: previewWindow.imageUri
                smooth: true
                antialiasing: true
                
                // Scale and pan properties
                property real scaleFactor: 1.0
                property real panX: 0
                property real panY: 0
                
                transform: [
                    Scale {
                        origin.x: previewImage.width / 2
                        origin.y: previewImage.height / 2
                        xScale: previewImage.scaleFactor
                        yScale: previewImage.scaleFactor
                    },
                    Translate {
                        x: previewImage.panX
                        y: previewImage.panY
                    }
                ]
                
                // Pan functionality
                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton
                    cursorShape: Qt.OpenHandCursor
                    hoverEnabled: true
                    
                    property bool isPanning: false
                    property point panStartPos
                    
                    onPressed: function(mouse) {
                        isPanning = true
                        cursorShape = Qt.ClosedHandCursor
                        panStartPos = Qt.point(mouse.x, mouse.y)
                    }
                    
                    onMouseXChanged: {
                        if (isPanning) {
                            previewImage.panX += mouseX - panStartPos.x
                            panStartPos.x = mouseX
                        }
                    }
                    
                    onMouseYChanged: {
                        if (isPanning) {
                            previewImage.panY += mouseY - panStartPos.y
                            panStartPos.y = mouseY
                        }
                    }
                    
                    onReleased: function(mouse) {
                        isPanning = false
                        cursorShape = Qt.OpenHandCursor
                    }
                }
            }
        }
        
        // Close button
        Rectangle {
            id: closeButton
            width: 30
            height: 30
            radius: 15
            color: "#FF4444"
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 10
            z: 10 // Ensure it's above the drag area
            
            Text {
                text: "×"
                color: "white"
                font.pixelSize: 18
                font.bold: true
                anchors.centerIn: parent
            }
            
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("Close button clicked")
                    previewWindow.close()
                }
                cursorShape: Qt.PointingHandCursor
                propagateComposedEvents: false
            }
        }
        
        // Zoom controls
        Row {
            id: zoomControls
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: 20
            spacing: 10
            z: 10 // Ensure it's above the drag area
            
            Rectangle {
                width: 40
                height: 40
                radius: 20
                color: "#333333"
                border.color: "#555555"
                border.width: 1
                
                Text {
                    text: "-"
                    color: "white"
                    font.pixelSize: 20
                    font.bold: true
                    anchors.centerIn: parent
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (previewImage.scaleFactor > 0.1) {
                            previewImage.scaleFactor -= 0.1
                        }
                    }
                    cursorShape: Qt.PointingHandCursor
                }
            }
            
            Rectangle {
                width: 60
                height: 40
                radius: 20
                color: "#333333"
                border.color: "#555555"
                border.width: 1
                
                Text {
                    text: Math.round(previewImage.scaleFactor * 100) + "%"
                    color: "white"
                    font.pixelSize: 12
                    anchors.centerIn: parent
                }
            }
            
            Rectangle {
                width: 40
                height: 40
                radius: 20
                color: "#333333"
                border.color: "#555555"
                border.width: 1
                
                Text {
                    text: "+"
                    color: "white"
                    font.pixelSize: 20
                    font.bold: true
                    anchors.centerIn: parent
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (previewImage.scaleFactor < 5.0) {
                            previewImage.scaleFactor += 0.1
                        }
                    }
                    cursorShape: Qt.PointingHandCursor
                }
            }
            
            Rectangle {
                width: 50
                height: 40
                radius: 20
                color: "#333333"
                border.color: "#555555"
                border.width: 1
                
                Text {
                    text: "Reset"
                    color: "white"
                    font.pixelSize: 10
                    anchors.centerIn: parent
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        previewImage.scaleFactor = 1.0
                    }
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }
        
        // Mouse area for wheel zoom (only over image area)
        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.NoButton // Only handle wheel events
            z: 1 // Below controls but above drag area
            
            onWheel: function(wheel) {
                var zoomFactor = wheel.angleDelta.y > 0 ? 1.1 : 0.9
                var newScale = previewImage.scaleFactor * zoomFactor
                
                if (newScale >= 0.1 && newScale <= 5.0) {
                    previewImage.scaleFactor = newScale
                }
            }
        }
    }
    
    // Function to show the preview with a specific image
    function showPreview(imageUri) {
        previewWindow.imageUri = imageUri
        previewWindow.visible = true
        previewWindow.raise()
        previewWindow.requestActivate()
        
        // Reset zoom and position
        previewImage.scaleFactor = 1.0
        previewImage.panX = 0
        previewImage.panY = 0
        
        // Calculate aspect ratio and adjust window size
        Qt.callLater(function() {
            if (previewImage.sourceSize.width > 0 && previewImage.sourceSize.height > 0) {
                imageAspectRatio = previewImage.sourceSize.width / previewImage.sourceSize.height
                
                // Set window size based on image aspect ratio
                var baseWidth = 800
                var baseHeight = 600
                var maxWidth = 1200
                var maxHeight = 800
                
                if (imageAspectRatio > 1) {
                    // Landscape image
                    previewWindow.width = Math.min(maxWidth, baseWidth)
                    previewWindow.height = Math.min(maxHeight, previewWindow.width / imageAspectRatio)
                } else {
                    // Portrait image
                    previewWindow.height = Math.min(maxHeight, baseHeight)
                    previewWindow.width = Math.min(maxWidth, previewWindow.height * imageAspectRatio)
                }
            }
        })
    }
}
