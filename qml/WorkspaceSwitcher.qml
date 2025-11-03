pragma ComponentBehavior: Bound
import QtQuick

Item {
    id: workspaceSwitcher
    height: contentColumn.implicitHeight

    signal workspaceCreated(key: int)
    signal workspaceDeleted(key: int)
    signal loadCollectionRequested(key: int)
    property int currentWorkspace: 0
    property int deleteWorkspace
    property bool loaded: false

    Component.onCompleted: {
        if(!loaded){
            var collections = utils.loadCollections();

            if(collections.length === 0){
                workspaceList.append({
                    key: 0,
                    emoji: "😼"
                });
                workspaceSwitcher.workspaceCreated(0);
                workspaceSwitcher.currentWorkspace = workspaceList.get(0).key;
                workspaceSwitcher.loaded = true;
                return;
            }

            for(var i=0; i<collections.length; i++){
                var {emoji, key} = collections[i];
                workspaceList.append({
                    key: key,
                    emoji: emoji
                });
                workspaceSwitcher.workspaceCreated(key);
                workspaceSwitcher.loadCollectionRequested(key);
            }
            workspaceSwitcher.currentWorkspace = workspaceList.get(0).key;
            workspaceSwitcher.loaded = true;
        }else{
            workspaceList.append({
                key: 0,
                emoji: "😼"
            });
        }
    }

    function getCollections(){
        var keys = [];
        for(var i=0; i<workspaceList.count; i++){
            keys.push(workspaceList.get(i));
        }
        return keys;
    }

    ListModel {
        id: workspaceList
    }

    Column {
        id: contentColumn
        width: parent.width
        spacing: 10

        ListView {
            width: parent.width
            height: Math.min(120, childrenRect.height)
            model: workspaceList
            clip: true

            delegate: Rectangle {
                id: emojiSelector
                width: parent.width
                height: 30
                radius: 5
                color: key === workspaceSwitcher.currentWorkspace ? "#22ffffff" : "transparent"

                required property int key
                required property string emoji

                Text {
                    anchors.fill: parent
                    text: parent.emoji
                    font.pixelSize: 20
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton

                    onClicked: mouse => {
                        if (mouse.button === Qt.LeftButton) {
                            workspaceSwitcher.currentWorkspace = parent.key;
                        } else if (mouse.button === Qt.RightButton) {
                            if (workspaceList.count > 1) {
                                workspaceSwitcher.deleteWorkspace = parent.key;
                                deleteDialog.open();
                            }
                        }
                    }
                }
            }
        }

        Image {
            width: 20
            height: 20
            source: "qrc:/qt/qml/collective/assets/plus.png"
            anchors.horizontalCenter: parent.horizontalCenter

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    emojiPicker.show();
                }
            }
        }
    }

    Dialog {
        id: deleteDialog
        buttons: Dialog.Ok | Dialog.Cancel
        text: "Delete this collection?"

        onAccepted: {
            if (workspaceList.count === 1) {
                return;
            }

            if (workspaceSwitcher.deleteWorkspace === 0) {
                workspaceSwitcher.currentWorkspace = workspaceList.get(1).key;
                workspaceList.remove(0, 1);
                workspaceSwitcher.workspaceDeleted(workspaceSwitcher.deleteWorkspace);
                return;
            }

            for (var i = 0; i < workspaceList.count; i++) {
                if (workspaceList.get(i).key === workspaceSwitcher.deleteWorkspace) {
                    workspaceSwitcher.currentWorkspace = workspaceList.get(i - 1).key;
                    workspaceList.remove(i, 1);
                    workspaceSwitcher.workspaceDeleted(workspaceSwitcher.deleteWorkspace);
                    break;
                }
            }
        }
    }

    EmojiPickerWindow {
        id: emojiPicker

        onEmojiPressed: emoji => {
            var newKey = workspaceList.get(workspaceList.count - 1).key + 1;
            workspaceList.append({
                key: newKey,
                emoji: emoji
            });
            workspaceSwitcher.workspaceCreated(newKey);
            workspaceSwitcher.currentWorkspace = newKey;
            emojiPicker.close();
        }
    }
}
