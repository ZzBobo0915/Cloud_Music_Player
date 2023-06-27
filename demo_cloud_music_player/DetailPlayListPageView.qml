import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ColumnLayout{

    property string targetId: ""
    property string targetType: "10"  // /album || /playlist/detail
    property string name: "-"

    onTargetIdChanged: {
        if (targetType=="10") loadAlbum()
        else if (targetType==="1000") loadPlayList()
    }

    Rectangle{
        Layout.fillWidth: true
        width: parent.width
        height: 60
        color: "#00000000"
        Text{
            x: 10
            verticalAlignment: Text.AlignBottom
            text: qsTr(targetType==="10"?"专辑":"歌单")+name
            font.family: window.mFONT_FAMILY
            font.pointSize: 25
        }
    }

    RowLayout{
        height: 200
        width: parent.width

        MusicBorderImage{
            id: playListCover
            height: 180
            width: 180
            Layout.leftMargin: 15
        }
        Item{
            height: parent.height
            Layout.fillWidth: true
            Text{
                id: playListDesc
                width: parent.width*0.95
                anchors.centerIn: parent
                wrapMode: Text.WrapAnywhere  // 自动换行
                font.family: window.mFONT_FAMILY
                font.pointSize: 14
                maximumLineCount: 4
                elide: Text.ElideRight
                lineHeight: 1.5  // 行距
            }
        }
    }
    MusicListView{
        id: playListView

    }


    function loadAlbum(){
        if (targetId.length < 1) return
        var url = "album"+"?id="+(targetId.length<1?"32311":targetId)
        function onReply(reply){
            //console.log(reply)
            http.onReplySignal.disconnect(onReply)

            var album = JSON.parse(reply).album
            var songs = JSON.parse(reply).songs
            playListCover.imgSrc = album.blurPicUrl
            playListDesc.text = album.description
            name = "-" + album.name
            playListView.musicList = songs.map(item=>{
                                                 return {
                                                       id: item.id,
                                                       name: item.name,
                                                       artist: item.ar[0].name,
                                                       album: item.al.name,
                                                       cover: item.al.picUrl
                                                   }
                                               })
        }
        http.onReplySignal.connect(onReply)
        http.connet(url);
    }

    function loadPlayList(){
        if (targetId.length < 1) return
        var url = "playlist/detail"+"?id="+(targetId.length<1?"32311":targetId)

        function onSongDetailReply(reply){
            console.log(reply)
            http.onReplySignal.disconnect(onSongDetailReply)

            var songs = JSON.parse(reply).songs
            playListView.musicList = songs.map(item=>{
                                                 return {
                                                       id: item.id,
                                                       name: item.name,
                                                       artist: item.ar[0].name,
                                                       album: item.al.name,
                                                       cover: item.al.picUrl
                                                   }
                                               })
        }

        function onReply(reply){
            //console.log(reply)
            http.onReplySignal.disconnect(onReply)

            var playlist = JSON.parse(reply).playlist
            playListCover.imgSrc = playlist.coverImgUrl
            playListDesc.text = playlist.description
            name = "-" + playlist.name
            var ids = playlist.trackIds.map(item=>item.id).join(",")
            http.onReplySignal.connect(onSongDetailReply)
            http.connet("song/detail?ids="+ids);
        }
        http.onReplySignal.connect(onReply)
        http.connet(url);
    }
}

