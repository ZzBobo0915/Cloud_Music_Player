import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQml 2.12

Item{
    property alias list: gridReapter.model

    Grid{
        id: hridLayout
        anchors.fill: parent
        columns: 3
        Repeater{
            id: gridReapter
            model: []

            Frame{
                padding: 10
                width: parent.width*0.33
                height: parent.width*0.1
                background: Rectangle{
                    id: background
                    color: "#00000000"
                }
                clip: true

                MusicBorderImage{
                    id: img
                    width: parent.width*0.25
                    height: parent.width*0.25
                    imgSrc: modelData.album.picUrl
                }

                Text {
                    id: name
                    height: 30
                    width: parent.width*0.7
                    anchors{
                        left: img.right
                        verticalCenter: parent.verticalCenter
                        bottomMargin: 10
                        leftMargin: 5
                    }
                    text: modelData.album.name
                    font{
                        family: window.mFONT_FAMILY
                        pointSize: 11
                    }
                    elide: Qt.ElideMiddle
                }

                Text {
                    height: 30
                    width: parent.width*0.7
                    anchors{
                        left: img.right
                        top: name.bottom
                        bottomMargin: 10
                        leftMargin: 5
                    }
                    text: modelData.artists[0].name
                    font{
                        family: window.mFONT_FAMILY
                    }
                    elide: Qt.ElideRight
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
                        console.log(modelData.artists[0].name)
                        layoutBottomView.current = -1
                        layoutBottomView.playList = [{id:modelData.id,
                                                      name:modelData.album.name,
                                                      artist:modelData.artists[0].name,
                                                      cover:modelData.album.blurPicUrl,
                                                      url:modelData.mp3Url,
                                                      time:modelData.mMusic.playTime
                                                     }]
                        layoutBottomView.current = 0
                    }
                }


            }
        }
    }
}
