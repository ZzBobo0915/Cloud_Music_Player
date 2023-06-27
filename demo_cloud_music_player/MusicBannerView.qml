import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQml 2.12

Frame{
    property int current: 0

    background: Rectangle{
        border.color: "#ffffff"
    }
    leftPadding: 10

/*--------  轮播图方法一  --------*/
    property alias bannerList: bannerView.model

    PathView{
        id: bannerView
        width: parent.width
        height: parent.height
        clip: true

//        MouseArea{
//            anchors.fill: parent
//            hoverEnabled: true
//            cursorShape: Qt.PointingHandCursor
//            onEntered: {
//                bannerTimer.stop()
//            }
//            onExited: {
//                bannerTimer.start()
//            }
//        }

        delegate: Item{
            id: delegateItem
            width: bannerView.width*0.7
            height: bannerView.height
            z: PathView.z?PathView.z:0
            scale: PathView.scale?PathView.scale:1.0
            MusicRoundImage{
                id: image
                imgSrc: modelData.imageUrl
                width: delegateItem.width
                height: delegateItem.height
            }
            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if(bannerView.currentIndex === index) {
                        var item = bannerView.model[index]
                        var targetId = item.targetId + ""
                        var targetType = item.targetType + ""// 1:单曲 10:专辑 1000:歌单
                        console.log(targetType)
                        switch(targetType){
                        case "1":
                            // 播放歌曲
                            layoutBottomView.current = -1
                            layoutBottomView.playList = [{id:targetId, name:"", artist:"", cover:"", album:""}]
                            layoutBottomView.current = 0
                            break
                        case "10":
                            //pageHomeView.showPlayList(targetId, targetType)
                            //break
                        case "1000":
                            // 打开播放列表
                            pageHomeView.showPlayList(targetId, targetType)
                            break
                        }

                    }else {
                        bannerView.currentIndex = index
                    }
                }
                onEntered: {
                    bannerTimer.stop()
                }
                onExited: {
                    bannerTimer.start()
                }
            }
        }

        // 当前展示的view有几个item
        pathItemCount: 3
        path: bannerPath
        // 设置highlight属性，这里表示最中间的为highlight
        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
    }

    Path{
        id: bannerPath
        startX: 0
        startY: bannerView.height/2-10

        PathAttribute{name:"z"; value:0}
        PathAttribute{name:"scale"; value:0.6}

        PathLine{
            x: bannerView.width/2
            y: bannerView.height/2-10
        }

        PathAttribute{name:"z"; value:2}
        PathAttribute{name:"scale"; value:0.85}

        PathLine{
            x: bannerView.width
            y: bannerView.height/2-10
        }

        PathAttribute{name:"z"; value:0}
        PathAttribute{name:"scale"; value:0.6}
    }

    PageIndicator{
        id: indicator
        anchors{
            top: bannerView.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: -10
        }
        count: bannerView.count
        currentIndex: bannerView.currentIndex
        spacing: 10

        delegate: Rectangle{
            width: 20
            height: 5
            radius: 5
            color: index==bannerView.currentIndex?"balck":"gray"
            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }
            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: {
                    bannerTimer.stop()
                    bannerView.currentIndex = index
                }
                onExited: {
                    bannerTimer.start()
                }
            }
        }
    }

    Timer{
        id: bannerTimer
        running: true
        repeat: true
        interval: 3000
        onTriggered: {
            if (bannerView.count > 0) {
                bannerView.currentIndex = (bannerView.currentIndex+1)%bannerView.count
            }
        }
    }


/*--------  轮播图方法二  --------*/
/*
    property var bannerList: []
    background: Rectangle{
        color: "#00000000"
    }

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            bannerTimer.stop()
        }
        onExited: {
            bannerTimer.start()
        }
    }

    MusicRoundImage{
        id: leftImage
        width: parent.width * 0.6
        height: parent.height * 0.8
        anchors{
            left: parent.left
            bottom: parent.bottom
            bottomMargin: 20
        }
        imgSrc: getLeftImgSrc()

        MouseArea{
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor  // 设置鼠标悬停在这里时的形状
            onClicked: {
                current = current==0?bannerList.length-1:current-1
            }
        }

        // 设置轮播动画效果
        NumberAnimation{
            id: leftImageAnim
            target: leftImage
            property: "scale"  // 缩放
            from: 0.8  // 起始值
            to: 1.0    // 最终值
            duration: 200  // 时间ms
        }
        // 图片改变设置动画效果
        onImgSrcChanged:{
            leftImageAnim.start()
        }
    }
    MusicRoundImage{
        id: centerImage
        width: parent.width * 0.6
        height: parent.height
        anchors.centerIn: parent
        z: 2
        imgSrc: getCenterImgSrc()

        MouseArea{
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
        }

        NumberAnimation{
            id: centerImageAnim
            target: centerImage
            property: "scale"  // 缩放
            from: 0.8  // 起始值
            to: 1.0    // 最终值
            duration: 200  // 时间ms
        }
        onImgSrcChanged:{
            centerImageAnim.start()
        }
    }
    MusicRoundImage{
        id: rightImage
        width: parent.width * 0.6
        height: parent.height * 0.8
        anchors{
            right: parent.right
            bottom: parent.bottom
            bottomMargin: 20
        }
        imgSrc: getRightImgSrc()

        MouseArea{
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                current = current==bannerList.length-1?0:current+1
            }
        }

        NumberAnimation{
            id: rightImageAnim
            target: rightImage
            property: "scale"  // 缩放
            from: 0.8  // 起始值
            to: 1.0    // 最终值
            duration: 200  // 时间ms
        }
        onImgSrcChanged:{
            rightImageAnim.start()
        }
    }

    // 页面指示器，用于轮播图
    PageIndicator{
        anchors{
            top: centerImage.bottom
            horizontalCenter: parent.horizontalCenter
        }
        count: bannerList.length
        interactive: true  // 是否可交互
        // index改变赋值
        onCurrentIndexChanged:{
           current = currentIndex
        }

        delegate: Rectangle{
            width: 20
            height: 5
            radius: 5
            color: current==index?"balck":"gray"
            // 设置悬停在指示器时就跳转
            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onEntered: {
                    bannerTimer.stop()
                    current = index
                }
                onExited: {
                    bannerTimer.start()
                }
            }
        }
    }

    // 轮播图定时器
    Timer{
        id: bannerTimer
        running: true  // 设置运行即开始
        interval: 5000  // 5s
        repeat: true
        // 设置触发
        onTriggered: {
            current = current==bannerList.length-1?0:current+1
        }
    }

    function getLeftImgSrc(){
        return bannerList.length?bannerList[(current-1+bannerList.length)%bannerList.length].imageUrl:""
    }
    function getCenterImgSrc(){
        return bannerList.length?bannerList[current].imageUrl:""
    }
    function getRightImgSrc(){
        return bannerList.length?bannerList[(current+1+bannerList.length)%bannerList.length].imageUrl:""
    }
*/

}
