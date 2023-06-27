import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQml 2.12

ScrollView{
    clip: true  // 超出部分自动裁剪
    ColumnLayout{
        Rectangle{
            border.width: 0
            Layout.fillWidth: true
            width: parent.width
            height: 50
            color: "#00000000"
            Text{
                x: 10
                verticalAlignment: Text.AlignBottom
                text: qsTr("推荐内容")
                font.family: window.mFONT_FAMILY
                font.pointSize: 20
            }
        }
        MusicBannerView{
            id: bannerView
            Layout.preferredHeight: (window.width-200)*0.3
            Layout.preferredWidth: window.width-200
            //width: 200
            //height:60
            Layout.fillWidth: true
            Layout.fillHeight: true

        }

        Rectangle{
            //border.width: 0
            Layout.fillWidth: true
            width: parent.width
            height: 50
            color: "#00000000"
            Text{
                x: 10
                verticalAlignment: Text.AlignBottom
                text: qsTr("热门歌单")
                font.family: window.mFONT_FAMILY
                font.pointSize: 20
            }
        }
        MusicGridHotView{
            id: hotView
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: (window.width-250)*0.2*4+30*4+20
            Layout.bottomMargin: 20
        }

        Rectangle{
            //border.width: 0
            Layout.fillWidth: true
            width: parent.width
            height: 50
            color: "#00000000"
            Text{
                x: 10
                verticalAlignment: Text.AlignBottom
                text: qsTr("新歌推荐")
                font.family: window.mFONT_FAMILY
                font.pointSize: 20
            }
        }
        MusicGridLatestView{
            id: latestView
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.preferredHeight: (window.width-230)*0.1*10+20
            Layout.bottomMargin: 20
        }


    }

    Component.onCompleted: {
        getBannerList()
    }

    function getBannerList(){
        function onReply(reply){
            console.log(reply)
            http.onReplySignal.disconnect(onReply)

            var banners = JSON.parse(reply).banners
            bannerView.bannerList = banners
            getHotList()
        }
        http.onReplySignal.connect(onReply)
        http.connet("banner");
    }

    function getHotList(){
        function onReply(reply){
            //console.log(reply)
            http.onReplySignal.disconnect(onReply)

            var playLists = JSON.parse(reply).playlists
            hotView.list = playLists
            getLastestList()
        }
        http.onReplySignal.connect(onReply)
        http.connet("top/playlist/highquality?limit=20");
    }

    function getLastestList(){
        function onReply(reply){
            //console.log(reply)
            http.onReplySignal.disconnect(onReply)
            var latestLists = JSON.parse(reply).data
            latestView.list = latestLists.slice(0, 30)
        }
        http.onReplySignal.connect(onReply)
        http.connet("top/song");
    }
}

