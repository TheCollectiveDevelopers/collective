pragma ComponentBehavior: Bound
import QtQuick
import Qt5Compat.GraphicalEffects

Item {
    id: imageListContainer
    anchors.fill: parent
    height: 500
    property int key: -1

    signal listChanged()

    onKeyChanged: {
        console.log(imageListContainer.key);
        var assets = utils.getCollectionAssets(imageListContainer.key);

        for(var asset of assets){
            var type;
            console.log(asset.type);

            if(asset.type === "image"){
                type = Utils.Image;
            }else if(asset.type === "music"){
                type = Utils.Music;
            }else if(asset.type === "video"){
                type = Utils.Video;
            }else if(asset.type === "pdf"){
                type = Utils.PDF;
            }

            console.log(type);

            imageList.append({
                uri: new URL("file://" + asset.uri),
                index: imageList.count,
                type: type
            });
        }
    }

    function deleteAssets(){
        for(var i=0; i<imageList.count; i++){
            var asset = imageList.get(i);
            var urlObj = new URL(asset.uri);
            if(urlObj.href.includes(".collective")){
                utils.deleteAseet(asset.uri);
            }
        }
    }

    function saveAssets(){
        var assets = [];
        for(var i=0; i<imageList.count; i++){
            var asset = imageList.get(i);
            var type;
            if(asset.type === Utils.Image){
                type = "image";
            }else if(asset.type === Utils.Music){
                type = "music";
            }

            var urlObj = new URL(asset.uri);

            assets.push({
                uri: urlObj.href.includes(".collective") ? urlObj.pathname : utils.saveAsset(asset.uri),
                index: asset.index,
                type: type
            });
        }
        return assets;
    }

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
                        imageListContainer.listChanged();
                    }
                }
            }

            Component{
                id: audioDelegate

                MusicPreview{
                    width: listView.width
                    uri: loader.uri
                    index: loader.index

                    MouseArea{
                        anchors.fill: parent
                        acceptedButtons: Qt.RightButton

                        onClicked: {
                            for (var i = 0; i < imageList.count; i++) {
                                if (imageList.get(i).index === loader.index) {
                                    imageList.remove(i, 1);
                                    break;
                                }
                            }
                            imageListContainer.listChanged();
                        }
                    }
                }
            }


            function getComponent(){
                console.log("Loader: ", type)
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
                    if (utils.detectFileType(url) === Utils.Image || utils.detectFileType(url) === Utils.URL) {
                        console.log("Adding URL:", url);
                        imageList.append({
                            uri: url,
                            index: imageList.count,
                            type: Utils.Image
                        });
                        imageListContainer.listChanged();
                    } else if (utils.detectFileType(url) === Utils.Music) {
                        imageList.append({
                            uri: url,
                            index: imageList.count,
                            type: Utils.Music
                        });
                        imageListContainer.listChanged();
                    }
                }
                drop.accept(Qt.LinkAction);
            }
        }
    }
}
