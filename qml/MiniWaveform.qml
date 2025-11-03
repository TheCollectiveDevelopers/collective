pragma ComponentBehavior: Bound
import QtQuick

Item{
    id: miniPlayControl
    width: 25
    height: 20

    property bool playing: false
    property real waveformWidth: 3
    property color waveformColor: "white"
    property real minHeight: 5

    Row{
        id: waveFormRow
        anchors.fill: parent
        visible: miniPlayControl.playing

        spacing: 2

        Rectangle{
            id: bar1
            width: miniPlayControl.waveformWidth
            height: miniPlayControl.minHeight
            radius: 40
            anchors.verticalCenter: parent.verticalCenter

            color: miniPlayControl.waveformColor

            SequentialAnimation {
                loops: Animation.Infinite
                running: miniPlayControl.playing

                NumberAnimation {
                    target: bar1
                    property: "height"
                    to: miniPlayControl.height
                    duration: 700 + Math.random() * 200
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    target: bar1
                    property: "height"
                    to: miniPlayControl.minHeight
                    duration: 700 + Math.random() * 200
                    easing.type: Easing.InOutQuad
                }
            }
        }

        Rectangle{
            id: bar2
            width: miniPlayControl.waveformWidth
            height: miniPlayControl.minHeight
            radius: 40
            anchors.verticalCenter: parent.verticalCenter

            color: miniPlayControl.waveformColor

            SequentialAnimation {
                loops: Animation.Infinite
                running: miniPlayControl.playing

                PauseAnimation { duration: 100 }
                NumberAnimation {
                    target: bar2
                    property: "height"
                    to: miniPlayControl.height * 0.7
                    duration: 250 + Math.random() * 200
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    target: bar2
                    property: "height"
                    to: miniPlayControl.minHeight
                    duration: 250 + Math.random() * 200
                    easing.type: Easing.InOutQuad
                }
            }
        }

        Rectangle{
            id: bar3
            width: miniPlayControl.waveformWidth
            height: miniPlayControl.minHeight
            radius: 40
            anchors.verticalCenter: parent.verticalCenter

            color: miniPlayControl.waveformColor

            SequentialAnimation {
                loops: Animation.Infinite
                running: miniPlayControl.playing

                PauseAnimation { duration: 50 }
                NumberAnimation {
                    target: bar3
                    property: "height"
                    to: miniPlayControl.height * 0.85
                    duration: 320 + Math.random() * 200
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    target: bar3
                    property: "height"
                    to: miniPlayControl.minHeight
                    duration: 320 + Math.random() * 200
                    easing.type: Easing.InOutQuad
                }
            }
        }

        Rectangle{
            id: bar4
            width: miniPlayControl.waveformWidth
            height: miniPlayControl.minHeight
            radius: 40
            anchors.verticalCenter: parent.verticalCenter

            color: miniPlayControl.waveformColor

            SequentialAnimation {
                loops: Animation.Infinite
                running: miniPlayControl.playing

                PauseAnimation { duration: 150 }
                NumberAnimation {
                    target: bar4
                    property: "height"
                    to: miniPlayControl.height * 0.6
                    duration: 280 + Math.random() * 200
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    target: bar4
                    property: "height"
                    to: miniPlayControl.minHeight
                    duration: 280 + Math.random() * 200
                    easing.type: Easing.InOutQuad
                }
            }
        }

        Rectangle{
            id: bar5
            width: miniPlayControl.waveformWidth
            height: miniPlayControl.minHeight
            radius: 40
            anchors.verticalCenter: parent.verticalCenter

            color: miniPlayControl.waveformColor

            SequentialAnimation {
                loops: Animation.Infinite
                running: miniPlayControl.playing

                PauseAnimation { duration: 200 }
                NumberAnimation {
                    target: bar5
                    property: "height"
                    to: miniPlayControl.height * 0.75
                    duration: 310 + Math.random() * 200
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    target: bar5
                    property: "height"
                    to: miniPlayControl.minHeight
                    duration: 310 + Math.random() * 200
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }

    // Play button (visible when not playing)
    Item {
        anchors.fill: parent
        visible: !miniPlayControl.playing

        Image{
            width: 17
            height: 17
            source: "qrc:/qt/qml/collective/assets/play.png"

            anchors.centerIn: parent
        }
    }

}
