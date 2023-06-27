import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQml 2.12

Item{
    property alias list: gridReapter.model

    Grid{
        id: hridLayout
        anchors.fill: parent
        columns: 5
        Repeater{
            id: gridReapter
            model: []
            Frame{
                padding: 10
                width: parent.width*0.2
                height: parent.width*0.2+10
                background: Rectangle{
                    id: background
                    color: "#00000000"
                }
                clip: true

                MusicBorderImage{
                    id: img
                    width: parent.width
                    height: parent.width
                    imgSrc: modelData.coverImgUrl
                }

                Text {
                    height: 20
                    width: parent.width
                    anchors{
                        top: img.bottom
                        horizontalCenter: parent.horizontalCenter
                    }
                    text: modelData.name
                    font{
                        family: window.mFONT_FAMILY
                        //pointSize: 10
                    }
                    elide: Qt.ElideMiddle
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: {
                        background.color = "#50000000"
                    }
                    onExited: {
                        background.color = "#00000000"
                    }
                    onClicked: {
                        var item = gridReapter.model[index]
                        pageHomeView.showPlayList(item.id, "1000")
                    }
                }

            }
        }
    }
}
