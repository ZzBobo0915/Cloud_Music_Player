import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import MyUtils 1.0  // 导入注册的qml文件
import QtMultimedia 5.12  // 提供媒体播放
import Qt.labs.settings 1.1
import Qt.labs.platform 1.0
import QtQuick.Dialogs 1.2

ApplicationWindow{
    id: window
    flags: Qt.Window | Qt.FramelessWindowHint  // 隐藏菜单栏

    function minimize(){
        window.visibility = ApplicationWindow.Minimized
    }


    property int mWINDOW_WIDTH: 1200
    property int mWINDOW_HEIGHT: 800
    property string mFONT_FAMILY : "微软雅黑"

    visible: true
    width: 1200
    height: 800
    title: qsTr("Demo Cloud Music Player")


    // 退出提示
    MessageDialog{
        id: quitDialog
        visible: false
        //modality: Qt.NonModal  // 非模态
        title: qsTr("退出应用")
        text: "是否退出?"
        RowLayout{
            Layout.fillWidth: true
            anchors.centerIn: parent
            Button{
                text: "退出"
                font.pointSize: 10
                enabled: true
                background: Rectangle{
                    color: "#ffffff"
                    radius: 5
                    border.color: "#000000"
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked:{
                        Qt.quit()
                    }
                }
            }
            Button{
                text: "缩放至托盘"
                font.pointSize: 10
                enabled: true
                background: Rectangle{
                    color: "#ffffff"
                    radius: 5
                    border.color: "#000000"
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked:{
                        window.hide()
                        quitDialog.close()
                    }
                }
            }
        }
    }

    // 状态栏
    SystemTrayIcon{
        visible: true
        iconSource: "qrc:/images/music.png"
        tooltip: "MusicPlayer"
        onActivated: {

        }
        menu: Menu{
            MenuItem{
                text: qsTr("打开")
                iconSource: "qrc:/images/music.png"  // 这里的图片加载不出来
                onTriggered: {
                    window.show()
                    window.raise()
                    window.requestActivate()
                }
            }
            MenuItem{
                text: qsTr("关闭播放器")
                iconSource: "qrc:/images/power.png"
                onTriggered: {
                    Qt.quit()
                }
            }
        }
    }

    HttpUtils{
        id: http
    }

    Settings{
        id: settings
        fileName: "conf/settings.ini"
    }

    ColumnLayout{


        anchors.fill: parent
        spacing: 0  // ColumnLayout的边距

        LayoutHeaderView{
            id: layoutHeaderView
        }


        PageHomeView{
            id: pageHomeView
            //visible: false
        }

        PageDetailView{
            visible: false
            id: pageDetailView
        }


        LayoutBottomView{
            id: layoutBottomView
        }

    }

    MediaPlayer{
        id: mediaPlayer
        property var times: []
        onPositionChanged: {
            layoutBottomView.setSlider(0, duration, position)
            if (times.length>0) {
                var count = times.filter(item=>item<position).length
                pageDetailView.current = (count===0)?0:count-1
            }
        }

        onPlaybackStateChanged: {
            layoutBottomView.playingState = playbackState===MediaPlayer.PlayingState?1:0
            if (playbackState === MediaPlayer.StoppedState && layoutBottomView.playbackStateChangeCallbackEnabled) {
                layoutBottomView.playNext()
            }
        }
    }
}


