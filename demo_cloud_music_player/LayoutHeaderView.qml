import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtQuick.Window 2.12

ToolBar{
    background: Rectangle{
        //color: "#00AAAA"
        color: "#ff5656"
    }

    Layout.fillWidth: true

    width: parent.width

   property var dragPosition: Qt.point(0,0)  // 拖动时点击的鼠标位置

    RowLayout{
        anchors.fill: parent

        MusicToolButton{
            iconSource: "qrc:/images/music"
            toolTip: "关于"
            background: Rectangle{
                color: "transparent"
            }
            onClicked: {
                aboutPop.open()
            }
        }
        MusicToolButton{
            iconSource: "qrc:/images/about"
            toolTip: "朱智博的博客"
            background: Rectangle{
                color: "transparent"
            }
            onClicked: {
                Qt.openUrlExternally("https://zzboayu.com/")
            }
        }
        MusicToolButton{
            id: smallWindow
            iconSource: "qrc:/images/small-window"
            toolTip: "小窗播放"
            onClicked: {
                // 设置窗口大小
                setWindowSize(330, 650)
                smallWindow.visible = false
                normalWindow.visible = true
            }

            background: Rectangle{
                color: "transparent"
            }
        }
        MusicToolButton{
            id: normalWindow
            iconSource: "qrc:/images/exit-small-window"
            toolTip: "退出小窗口播放"
            visible: false
            onClicked: {
                // 设置窗口大小
                setWindowSize()
                normalWindow.visible = false
                smallWindow.visible = true
            }

            background: Rectangle{
                color: "transparent"
            }
        }
        Item{
            Layout.fillWidth: true  // 自动填充
            height: 32
            Text {
                anchors.centerIn: parent
                text: qsTr("ZzBoAYU")
                font.family: window.mFONT_FAMILY
                font.pointSize: 15
                color: "#ffffff"
            }
            // 设置点击拖动
            MouseArea{
                anchors.fill: parent
                //acceptedButtons: Qt.LeftButton  // 只处理鼠标左键事件
                onPressed: {
                    dragPosition = Qt.point(mouse.x, mouse.y)
                }
                onPositionChanged: {
                    var delta = Qt.point(mouse.x-dragPosition.x, mouse.y-dragPosition.y)
                    window.setX(window.x+delta.x)
                    window.setY(window.y+delta.y)
                }
            }
        }
        MusicToolButton{
            iconSource: "qrc:/images/minimize-screen"
            toolTip: "最小化"
            width: 32
            height: 32
            background: Rectangle{
                color: "transparent"
            }
            onClicked: {
                window.minimize()
                //window.hide()
            }
        }
        MusicToolButton{
            id: maxWindow
            iconSource: "qrc:/images/full-screen"
            toolTip: "全屏"
            background: Rectangle{
                color: "transparent"
            }
            onClicked: {
                window.visibility = Window.Maximized
                maxWindow.visible = false
                resize.visible = true
            }
        }
        MusicToolButton{
            id: resize
            iconSource: "qrc:/images/small-screen"
            toolTip: "退出全屏"
            visible: false
            background: Rectangle{
                color: "transparent"
            }
            onClicked: {
                setWindowSize()
                window.visibility = Window.AutomaticVisibility
                maxWindow.visible = true
                resize.visible = false
            }
        }
        MusicToolButton{
            iconSource: "qrc:/images/power"
            toolTip: "退出"
            background: Rectangle{
                color: "transparent"
            }
            onClicked: {
                quitDialog.open()
            }
        }
    }

    Popup{
        id: aboutPop

        topInset: 0
        leftInset: 0
        rightInset: 0
        bottomInset: 0

        parent: Overlay.overlay
        width: 250
        height: 230
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        background: Rectangle{
            color: "#e9f4ff"
            radius: 5
            border.color: "#2273a7ab"
        }
        contentItem: ColumnLayout{
            width: parent.width
            height: parent.height
            Layout.alignment: Qt.AlignHCenter
            Image {
                Layout.preferredHeight: 60
                source: "qrc:/images/music"
                Layout.fillWidth: true
                fillMode: Image.PreserveAspectFit
            }
            Text {
                text: "朱智博"
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 18
                color: "#8573a7ab"
                font.family: window.mFONT_FAMILY
                font.bold: true
            }
            Text {
                text: "Cloud Music Palyer"
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 16
                color: "#8573a7ab"
                font.family: window.mFONT_FAMILY
                font.bold: true
            }
            Text {
                text: "www.zzboayu.com"
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 12
                color: "#8573a7ab"
                font.family: window.mFONT_FAMILY
                font.bold: true
            }
        }
    }

    function setWindowSize(width=window.mWINDOW_WIDTH, height=window.mWINDOW_HEIGHT){
        // 居中显示
        window.height = height
        window.width = width
        window.x = (Screen.desktopAvailableWidth - window.width)/2
        window.y = (Screen.desktopAvailableHeight - window.height)/2
    }
}
