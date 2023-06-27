import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQml 2.12
import QtQuick.Layouts 1.12
import QtQuick.Shapes 1.12

Frame{
    property var musicList: []
    property int all: 0
    property int pageSize: 60
    property int current: 0

    signal loadMore(int offset, int current)

    onMusicListChanged: {
        listViewModel.clear()
        listViewModel.append(musicList)
    }

    Layout.fillHeight: true
    Layout.fillWidth: true
    clip: true
    padding: 0
    background: Rectangle{
        color: "#00000000"
    }

    ListView{
        id: listView
        anchors.fill: parent
        anchors.bottomMargin: 70
        model: ListModel{
            id: listViewModel
        }
        delegate: listViewDelegate
        ScrollBar.vertical: ScrollBar{
            anchors.right: parent.right
        }
        header: listViewHeader
        highlight: Rectangle{
            color: "#f0f0f0"
        }
        highlightMoveDuration: 0
        highlightResizeDuration: 0
    }

    Component{
        id: listViewDelegate
        Rectangle{
            id: listViewDelegateItem
            //color: "#aaa"
            height: 45
            width: listView.width

            //边框
            Shape{
                anchors.fill: parent
                ShapePath{
                    strokeWidth: 0
                    strokeColor: "#50000000"
                    strokeStyle: ShapePath.SolidLine
                    startX: 0
                    startY: 45
                    PathLine{
                        x: 0
                        y: 45
                    }
                    PathLine{
                        x: parent.width
                        y: 45
                    }
                }
            }

            MouseArea{
                RowLayout{
                    width: parent.width
                    height: parent.height
                    spacing: 15
                    x: 5
                    Text{
                        text: index+1+pageSize*current
                        horizontalAlignment: Qt.AlignHCenter
                        Layout.preferredWidth: parent.width*0.05
                        font.family: window.mFONT_FAMILY
                        font.pointSize: 13
                        color: "black"
                        elide: Qt.ElideRight
                    }
                    Text{
                        text: name
                        //horizontalAlignment: Qt.AlignHCenter
                        Layout.preferredWidth: parent.width*0.4
                        font.family: window.mFONT_FAMILY
                        font.pointSize: 13
                        color: "black"
                        elide: Qt.ElideRight
                    }
                    Text{
                        text: artist
                        horizontalAlignment: Qt.AlignHCenter
                        Layout.preferredWidth: parent.width*0.15
                        font.family: window.mFONT_FAMILY
                        font.pointSize: 13
                        color: "black"
                        elide: Qt.ElideRight
                    }
                    Text{
                        text: album
                        horizontalAlignment: Qt.AlignHCenter
                        Layout.preferredWidth: parent.width*0.15
                        font.family: window.mFONT_FAMILY
                        font.pointSize: 13
                        color: "black"
                        elide: Qt.ElideMiddle
                    }
                    Item{
                        Layout.preferredWidth: parent.width*0.15
                        RowLayout{
                            anchors.centerIn: parent
                            MusicIconButton{
                                iconSource: "qrc:/images/pause"
                                iconHeight: 16
                                iconWidth: 16
                                toolTip: "播放"
                                onClicked: {
                                    layoutBottomView.current = -1
                                    layoutBottomView.playList = musicList
                                    layoutBottomView.current = index
                                }

                            }
                            MusicIconButton{
                                iconSource: "qrc:/images/favorite"
                                iconHeight: 16
                                iconWidth: 16
                                toolTip: "喜欢"
                                onClicked: {
                                    // 喜欢
                                }

                            }
                            MusicIconButton{
                                iconSource: "qrc:/images/download"
                                iconHeight: 16
                                iconWidth: 16
                                toolTip: "下载"
                                onClicked: {
                                    // 下载
                                }

                            }
                        }
                    }
                }
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: {
                    color = "#60f0f0f0"
                }
                onExited: {
                    color = "#00000000"
                }
                onClicked: {
                    listViewDelegateItem.ListView.view.currentIndex = index
                }
            }

        }

    }

    Component{
        id: listViewHeader
        Rectangle{
            color: "#ff5656"
            height: 45
            width: listView.width
            RowLayout{
                width: parent.width
                height: parent.height
                spacing: 15
                x: 5
                Text{
                    text: "序号"
                    horizontalAlignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width*0.05
                    font.family: window.mFONT_FAMILY
                    font.pointSize: 13
                    color: "black"
                    elide: Qt.ElideRight
                }
                Text{
                    text: "歌名"
                    //horizontalAlignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width*0.4
                    font.family: window.mFONT_FAMILY
                    font.pointSize: 13
                    color: "black"
                    elide: Qt.ElideRight
                }
                Text{
                    text: "歌手"
                    horizontalAlignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width*0.15
                    font.family: window.mFONT_FAMILY
                    font.pointSize: 13
                    color: "black"
                    elide: Qt.ElideRight
                }
                Text{
                    text: "专辑"
                    horizontalAlignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width*0.15
                    font.family: window.mFONT_FAMILY
                    font.pointSize: 13
                    color: "black"
                    elide: Qt.ElideRight
                }
                Text{
                    text: "操作"
                    horizontalAlignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width*0.15
                    font.family: window.mFONT_FAMILY
                    font.pointSize: 13
                    color: "black"
                    elide: Qt.ElideRight
                }
            }
        }
    }

    Item{
        id: pageButton
        visible: musicList.length!==0 && all!==0
        width: parent.width
        height: 40
        anchors.top: listView.bottom
        anchors.topMargin: 20

        ButtonGroup{
            buttons: buttons.children
        }

        RowLayout{
            id: buttons
            anchors.centerIn: parent
            Repeater{
                id: repeater
                model: all/pageSize?9:all/pageSize
                Button{
                    Text{
                        anchors.centerIn: parent
                        text: modelData+1
                        font.family: window.mFONT_FAMILY
                        font.pointSize: 14
                        color: checked?"#497563":"black"
                    }
                    background: Rectangle{
                        implicitHeight: 30
                        implicitWidth: 30
                        color: checked?"#e2f0f8":"#20e9f4ff"
                        radius: 3
                    }
                    checkable: true
                    checked: modelData === current
                    onClicked: {
                        if (current === index) return
                        current = index
                        loadMore(current*pageSize, index)
                    }
                }

            }
        }
    }

}
