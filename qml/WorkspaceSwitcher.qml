import QtQuick
import QtQuick.Layouts

Item {
    id: workspaceSwitcher
    height: contentColumn.implicitHeight

    signal workspaceCreated(key: int)
    property int currentWorkspace: 0

    ListModel {
        id: workspaceList

        ListElement {
            key: 0
            emoji: "😼"
        }
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
                color: "transparent"

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

                    onClicked: {
                        workspaceSwitcher.currentWorkspace = parent.key;
                        console.log(workspaceSwitcher.currentWorkspace);
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
