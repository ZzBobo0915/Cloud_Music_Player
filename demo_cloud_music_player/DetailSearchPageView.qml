import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ColumnLayout{
    Layout.fillHeight: true
    Layout.fillWidth: true

    Rectangle{
        Layout.fillWidth: true
        width: parent.width
        height: 50
        color: "#00000000"
        Text{
            x: 10
            verticalAlignment: Text.AlignBottom
            text: qsTr("搜索音乐")
            font.family: window.mFONT_FAMILY
            font.pointSize: 20
        }
    }


    RowLayout{
        Layout.fillWidth: true

        Item{
            width: 5
        }

        TextField{
            id: searchInput
            font.family: window.mFONT_FAMILY
            font.pointSize: 14
            selectByMouse: true
            selectionColor: "#999999"
            placeholderText: qsTr("请搜索关键词")
            color: "#000000"
            background: Rectangle{
                color: "#00000000"
                border.color: "black"
                border.width: 1
                opacity: 0.05
                implicitHeight: 40
                implicitWidth: 400
            }
            focus: true
            Keys.onPressed: if(event.key === Qt.Key_Enter||event.key === Qt.Key_Return) doSearch()
        }

        MusicIconButton{
            iconSource: "qrc:/images/search-black"
            toolTip: qsTr("搜索")
            background: Rectangle{
                color: self.down||(isCheckable&&self.checked)?"#ffffff":"#ff5656"//"#497563":"#2939f4ff"  // 是否被按下
                radius: 3
            }
            onClicked: doSearch()
        }

    }

    MusicListView{
        id: musicListView
        onLoadMore: doSearch(offset,current)
    }

    function doSearch(offset = 0, current = 0){
        var keywords = searchInput.text
        if(keywords.length < 1) return
        function onReply(reply){
            http.onReplySignal.disconnect(onReply)
            var result = JSON.parse(reply).result
            musicListView.current = current
            musicListView.all = result.songCount
            musicListView.musicList = result.songs.map(item=>{
                                                      return {
                                                            id: item.id,
                                                            name: item.name,
                                                            artist: item.artists[0].name,
                                                            album: item.album.name,
                                                            cover: ""
                                                        }
                                                    })
        }
        http.onReplySignal.connect(onReply)
        http.connet("search?keywords="+keywords+"&offset="+offset+"&limit=60")
    }


}



