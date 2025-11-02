pragma ComponentBehavior: Bound
import QtQuick
import QtMultimedia
import Qt5Compat.GraphicalEffects

Rectangle{
    id: musicPreview

    required property string uri
    required property int index

    FontLoader{
        id: shAdGrotesk
        source: "qrc:/qt/qml/collective/assets/sh-ad-grotesk.ttf"
    }

    FontLoader{
        id: calSans
        source: "qrc:/qt/qml/collective/assets/calsans.ttf"
    }

    height: 70
    color: "black"
    radius: 12

    CollectiveMediaPlayer{
        id: mediaPlayer
        source: musicPreview.uri

        audioOutput: AudioOutput{}
        onCoverArtUrlChanged: {
            coverArt.source = mediaPlayer.coverArtUrl;
        }
        onMajorColorChanged: {
            miniWaveForm.waveformColor = mediaPlayer.majorColor;
        }
    }

    Item{
        anchors.fill: parent
        anchors.margins: 5

        Image{
            id: coverArt
            asynchronous: true
            height: parent.height
            width: musicPreview.width < 100 ? parent.width: parent.height
            anchors.left: parent.left
            anchors.centerIn: musicPreview.width < 100 ? parent : undefined

            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    width: coverArt.width
                    height: coverArt.height
                    radius: 7
                }
            }
        }

        Column{
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: parent.height + 10
            spacing: 2
            visible: musicPreview.width > 130
            width: Math.max(30, parent.width - (parent.height + 40))
            clip: true

            Text{
                text: mediaPlayer.metaData.value(0) ?? "Unknown" //Title
                color: "white"
                font: calSans.font
                width: parent.width
                elide: Text.ElideRight
                maximumLineCount: 1
            }

            Text{
                text: mediaPlayer.metaData.value(19) ?? mediaPlayer.metaData.value(20)[0] ?? mediaPlayer.metaData.value(1) ?? "Unknown" //Author
                color: "#99ffffff"
                font: shAdGrotesk.font
                width: parent.width
                elide: Text.ElideRight
                maximumLineCount: 1
            }
        }

        Column{
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: 3

            MiniWaveform{
                id: miniWaveForm
                playing: mediaPlayer.playing
                MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if(mediaPlayer.playing){
                            mediaPlayer.pause()
                        }else{
                            mediaPlayer.play()
                        }
                    }
                }
            }

            Text{
                text: {
                    var remainingMs = mediaPlayer.duration - mediaPlayer.position;
                    var totalSeconds = Math.floor(remainingMs / 1000);
                    var minutes = Math.floor(totalSeconds / 60);
                    var seconds = totalSeconds % 60;
                    return minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
                }
                font: shAdGrotesk.font
                color: "white"
            }
        }
    }
}
