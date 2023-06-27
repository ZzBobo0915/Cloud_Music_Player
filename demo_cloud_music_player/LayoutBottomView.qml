import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtMultimedia 5.12
import QtQml 2.12

// 底部工具栏
Rectangle{

    property var playList: []
    property int current: -1
    property int sliderValue: 0
    property int sliderTo: 100
    property int sliderFrom: 0
    property var currentPlayMode: 0
    property var playModeList: [{icon:"single-repeat", name:"单曲循环"}, {icon:"repeat", name:"顺序播放"}, {icon:"random", name:"随机播放"}]

    property string musicCover: "qrc:/images/player"
    property string musicName: "朱智博"
    property string musicArtist: "朱智博"

    property int playingState: 0  // 0暂停 1正在播放

    property bool playbackStateChangeCallbackEnabled: false

    Layout.fillWidth: true
    //color: "#00AAAA"
    color: "#ff5656"
    height: 60

    RowLayout{
        anchors.fill: parent
        Item{
            Layout.preferredWidth: parent.width/10
            Layout.fillWidth: true
        }
        MusicIconButton{
            Layout.preferredWidth: 50
            toolTip: "上一首"
            iconWidth: 32
            iconHeight: 32
            iconSource: "qrc:/images/previous"
            onClicked: playPrevious()
        }
        MusicIconButton{
            Layout.preferredWidth: 50
            toolTip: "暂停/播放"
            iconWidth: 32
            iconHeight: 32
            iconSource: playingState===0?"qrc:/images/stop":"qrc:/images/pause"
            onClicked: {
                if (!mediaPlayer.source) return
                if (mediaPlayer.playbackState === MediaPlayer.PlayingState) {
                    mediaPlayer.pause()
                    //playingState = 0
                }else if (mediaPlayer.playbackState === MediaPlayer.PausedState){
                    mediaPlayer.play()
                    //playingState = 1
                }
            }
        }
        MusicIconButton{
            Layout.preferredWidth: 50
            toolTip: "下一首"
            iconWidth: 32
            iconHeight: 32
            iconSource: "qrc:/images/next"
            onClicked: playNext("click")
        }
        Item{
            Layout.preferredWidth: parent.width/2
            Layout.fillHeight: true
            Layout.topMargin: 20
            Text{
                id: nameText
                anchors.left: slider.left
                anchors.bottom: slider.top
                //anchors.bottomMargin: 5
                anchors.leftMargin: 5
                text: musicName+"-"+musicArtist
                font.family: window.mFONT_FAMILY
                color: "#ffffff"
            }
            Text{
                id: timeText
                anchors.right: slider.right
                anchors.bottom: slider.top
                //anchors.bottomMargin: 5
                anchors.rightMargin: 5
                text:"00:00/05:20"
                font.family: window.mFONT_FAMILY
                color: "#ffffff"
            }

            Slider{
                id: slider
                width: parent.width
                Layout.fillWidth: true
                height: 30
                to: sliderTo
                from: sliderFrom
                value: sliderValue
                onMoved:{
                    //if(mediaPlayer.playbackState == MediaPlayer.PlayingState)
                    mediaPlayer.seek(value)
                }

                background: Rectangle{
                    x: slider.leftPadding
                    y: slider.topPadding+(slider.availableHeight-height)/2
                    width: slider.availableWidth  // 可用长度
                    height: 4
                    radius: 2  // 圆角
                    color: "#e9f4ff"
                    Rectangle{
                        width: slider.visualPosition*parent.width
                        height: parent.height
                        color: "#73a7ab"
                        radius: 2
                    }
                }

                handle:Rectangle{
                    x: slider.leftPadding+(slider.availableWidth-width)*slider.visualPosition
                    y: slider.topPadding+(slider.availableHeight-height)/2
                    width: 15
                    height: 15
                    border.color: "#73a7ab"
                    border.width: 0.5
                    radius: 5
                    color: "#f0f0f0"
                }
            }
        }

        MusicBorderImage{
            width: 50
            height: 45
            imgSrc: musicCover
            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onPressed: {
                    musicCover.scale = 0.9
                }
                onReleased: {
                    musicCover.scale = 1.0
                }

                onClicked: {
                    pageDetailView.visible = !pageDetailView.visible
                    pageHomeView.visible = !pageHomeView.visible

                }
            }
        }

        MusicIconButton{
            Layout.preferredWidth: 50
            toolTip: "我喜欢"
            iconWidth: 32
            iconHeight: 32
            iconSource: "qrc:/images/favorite"
        }
        MusicIconButton{
            id: playMode
            Layout.preferredWidth: 50
            toolTip: playModeList[currentPlayMode].name
            iconWidth: 32
            iconHeight: 32
            iconSource: "qrc:/images/"+playModeList[currentPlayMode].icon
            onClicked: changePlayMode()
        }
        Item{
            Layout.preferredWidth: parent.width/10
            Layout.fillWidth: true
        }    
    }

    Component.onCompleted: {
        currentPlayMode = settings.value("currentPlayMode",0)
    }

    onCurrentChanged: {
        playbackStateChangeCallbackEnabled = false
        playMusic(current)
    }
    // 播放下一首
    function playNext(type ="natural"){
        if (playList.length<1)return
        switch(currentPlayMode){
        case 0:
            if (type === "natural"){
                mediaPlayer.play()
                break
            }
        case 1:
            current = (current+1)%playList.length
            break
        case 2:
            var random = parseInt(Math.random()*playList.length)
            current = current===random?((random+1)%playList.length):random
            break
        }
    }
    // 播放上一首
    function playPrevious(){
        if (playList.length<1)return
        switch(currentPlayMode){
        case 0:
        case 1:
            current = (current+playList.length-1)%playList.length
            break
        case 2:
            var random = parseInt(Math.random()*playList.length)
            current = current===random?((random+1)%playList.length):random
            break
        }
    }
    // 改变播放模式
    function changePlayMode(){
        currentPlayMode = (currentPlayMode+1)%playModeList.length
        settings.setValue("currentPlayMode", currentPlayMode)
    }
    // ***播放音乐***
    function playMusic(){
        if (current < 0) return
        if (playList.length<current+1) return
        if (playList[current].type === "1"){
            // 播放本地音乐
            playLocalMusic()
            console.log(playList[current].type)
        }
        else {
            // 播放网络音乐
            playWebMusic()
            console.log(playList[current].type)
        }
    }
    // 播放本地音乐
    function playLocalMusic(){
        var currentItem = playList[current]
        mediaPlayer.source = currentItem.url
        mediaPlayer.play()
        musicName = currentItem.name
        musicArtist = currentItem.artist
    }

    // 播放网络音乐(获取播放链接)
    function playWebMusic(){
        var id = playList[current].id
        if (!id) return

        // 设置详情
        musicName = playList[current].name
        musicArtist = playList[current].artist
        function onReply(reply){

            http.onReplySignal.disconnect(onReply)

            var data = JSON.parse(reply).data
            var url = data[0].url
            var time = data.time
            //设置slider
            setSlider(0, time, 0)

            if (!url) return
            // 请求专辑
            var cover = playList[current].cover
            if (cover.length<1) {
                getCover(id)
            }else{
                musicCover = cover
                getLyric(id)
            }

            //console.log("mediaPlayer play:"+ url)
            mediaPlayer.source = url
            mediaPlayer.play()

            playbackStateChangeCallbackEnabled = true

        }
        http.onReplySignal.connect(onReply)
        http.connet("song/url?id="+id);
    }
    function getCover(id){
        function onReply(reply){
            http.onReplySignal.disconnect(onReply)
            getLyric(id)
            var song = JSON.parse(reply).songs[0]
            var cover = song.al.picUrl
            musicCover = cover
            if (musicName.length < 1) musicName = song.name
            if (musicArtist.length < 1) musicArtist = song.ar[0].name
        }

        http.onReplySignal.connect(onReply)
        http.connet("song/detail?ids="+id)
    }
    function setSlider(from=0, to=100, value=0){
        sliderFrom = from
        sliderTo = to
        sliderValue = value

        var fr_mm = parseInt(value/1000/60) + ""
        fr_mm = fr_mm.length<2?("0"+fr_mm):fr_mm
        var fr_ss = parseInt(value/1000%60) + ""
        fr_ss = fr_ss.length<2?("0"+fr_ss):fr_ss

        var to_mm = parseInt(to/1000/60) + ""
        to_mm = to_mm.length<2?("0"+to_mm):to_mm
        var to_ss = parseInt(to/1000%60) + ""
        to_ss = to_ss.length<2?("0"+to_ss):to_ss

        timeText.text = fr_mm+":"+fr_ss+"/"+to_mm+":"+to_ss
    }
    function getLyric(id){
        function onReply(reply){
            http.onReplySignal.disconnect(onReply)
            var lyric = JSON.parse(reply).lrc.lyric
            //console.log(lyric)
            if (lyric.length < 1) return
            var lyrics = (lyric.replace(/\[.*\]/gi,"")).split("\n")

            if (lyrics.length>0) pageDetailView.lyrics = lyrics
            var times = []
            lyric.replace(/\[.*\]/gi, function(match, index){
                if (match.length>2) {
                    var time = match.substr(1, match.length-2)
                    var arr = time.split(":")
                    var timeValue = arr.length>1?parseInt(arr[0])*60*1000:0
                    arr = arr.length>1?arr[1].split("."):[0,0]
                    timeValue += arr.length>0?parseInt(arr[0])*1000:0
                    timeValue += arr.length>0?parseInt(arr[1])*10:0
                    times.push(timeValue)
                }
            })

            mediaPlayer.times = times
        }
        http.onReplySignal.connect(onReply)
        http.connet("lyric?id="+id)
    }
}
