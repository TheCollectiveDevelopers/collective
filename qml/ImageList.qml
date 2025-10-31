pragma ComponentBehavior: Bound
import QtQuick
import Qt5Compat.GraphicalEffects

Item {
    anchors.fill: parent
    height: 500
    property int key

    ListModel {
        id: imageList
    }



    ListView {
        id: listView
        anchors.fill: parent
        anchors.margins: 10
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        visible: imageList.count > 0
        spacing: 10
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                width: listView.width
                height: listView.height
                radius: 12
            }
        }

        model: imageList

        delegate: Loader{
            id: loader
            required property string uri
            required property int index
            required property int type

            Component{
                id: imageDelegate

                ImageListThumbnail{
                    width: listView.width
                    uri: loader.uri
                    index: loader.index

                    onImageDeleted: key => {
                        for (var i = 0; i < imageList.count; i++) {
                            if (imageList.get(i).index === key) {
                                imageList.remove(i, 1);
                                break;
                            }
                        }
                    }
                }
            }

            Component{
                id: audioDelegate

                MusicPreview{
                    width: listView.width
                    uri: loader.uri
                    index: loader.index
                }
            }


            function getComponent(){
                if(type === Utils.Image){
                    return imageDelegate;
                }else if(type === Utils.Music){
                    return audioDelegate;
                }else{
                    return undefined;
                }
            }

            sourceComponent: getComponent()

        }
    }

    Column {
        id: emptyLayout
        anchors.centerIn: parent
        spacing: 20
        visible: imageList.count == 0

        Image {
            id: dragImage
            source: "qrc:/qt/qml/collective/assets/drag.png"
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

    DropArea {
        id: dropArea
        anchors.fill: parent
        z: 1 // Ensure it's above the MouseArea
    }

    Connections {
        target: dropArea

        function onEntered(drag) {
            if (drag.hasUrls) {
                for (var url of drag.urls) {
                    if (utils.allowDropFile(url)) {
                        drag.accept(Qt.LinkAction);
                    }
                }
            }
        }

        function onDropped(drop) {
            if (drop.hasUrls) {
                for (const url of drop.urls) {
                    console.log(Utils.PDF);
                    if (utils.detectFileType(url) === Utils.Image) {
                        console.log("Adding URL:", url);
                        imageList.append({
                            uri: url,
                            index: imageList.count,
                            type: Utils.Image
                        });
                    } else if (utils.detectFileType(url) === Utils.Music) {
                        imageList.append({
                            uri: url,
                            index: imageList.count,
                            type: Utils.Music
                        });
                    }
                }
                drop.accept(Qt.LinkAction);
            }
        }
    }
}
