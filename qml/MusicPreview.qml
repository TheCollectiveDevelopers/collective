pragma ComponentBehavior: Bound
import QtQuick
import QtMultimedia
import Qt5Compat.GraphicalEffects
import collective 1.0

Rectangle{
    id: musicPreview

    required property string uri
    required property int index

    height: 70
    color: "black"
    radius: 12

    CollectiveMediaPlayer{
        id: mediaPlayer
        source: musicPreview.uri

        audioOutput: AudioOutput{}
        onMetaDataChanged: {
            console.log(mediaPlayer.coverArtUrl);
            coverArt.source = mediaPlayer.coverArtUrl;
        }
    }

    Item{
        anchors.fill: parent
        anchors.margins: 5

        Image{
            id: coverArt
            asynchronous: true
            height: parent.height
            width: parent.height
            anchors.left: parent.left

            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    width: coverArt.width
                    height: coverArt.height
                    radius: 7
                }
            }


        }
    }
}
