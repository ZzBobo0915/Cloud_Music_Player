import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import Qt.labs.platform 1.0
import Qt.labs.settings 1.1
import QtQml 2.12

ColumnLayout{

    // 保存本地文件
    Settings{
        id: localSettings
        fileName: "conf/local.ini"
    }

    Rectangle{
        Layout.fillWidth: true
        width: parent.width
        height: 50
        color: "#00000000"
        Text{
            x: 10
            verticalAlignment: Text.AlignBottom
            text: qsTr("本地音乐")
            font.family: window.mFONT_FAMILY
            font.pointSize: 20
        }
    }

    RowLayout{
        height: 80
        width: parent.width
        Item {
            width: 5
        }
        MusicTextButton{
            btnText: "添加本地音乐"
            btnHeight: 50
            btnWidth: 200
            onClicked:{
                fileDialog.open()
            }
        }
        MusicTextButton{
            btnText: "刷新记录"
            btnHeight: 50
            btnWidth: 120
            onClicked:{
                getLocal()
            }
        }
        MusicTextButton{
            btnText: "清空记录"
            btnHeight: 50
            btnWidth: 120
            onClicked:{
                // 空值保存，saveLocal的参数值list默认为为空
                saveLocal()
            }
        }
    }

    MusicListView{
        id: localListView

    }

    Component.onCompleted: {
        getLocal()
    }
    // 获取Settings
    function getLocal(){
        var list = localSettings.value("local", [])
        localListView.musicList = list
        return list
    }
    // 保存到Settings中
    function saveLocal(list=[]){
        localSettings.setValue("local", list)
        getLocal()
    }


    // 文件系统
    FileDialog{
        id: fileDialog
        fileMode: FileDialog.OpenFiles
        nameFilters: ["MP3 music Files(*.mp3)", "FLAC Music Files(*.flac)"]  // 类型
        folder: StandardPaths.standardLocations(StandardPaths.MusicLocation)[0]  //设置默认路径,这里是系统音乐文件夹
        acceptLabel: "确定"
        rejectLabel: "取消"
        onAccepted: {
            var list = getLocal()
            for (var index in files) {
                var path = files[index]
                var arr = path.split("/")
                var fileNameArr = arr[arr.length-1].split(".")
                // 去掉后缀
                fileNameArr.pop()
                // 歌手-名称.mp3
                var fileName = fileNameArr.join(".")
                var nameArr = fileName.split("-")
                var name = "朱智博"
                var artist = "朱智博"
                if (nameArr.length>1) {
                    artist = nameArr[0]
                    nameArr.shift()  // 去掉第一个元素
                }
                name = nameArr.join("-")
                // 判断歌曲是否存在
                if (list.filter(item=>item.id === path).length<1) {
                    list.push({
                                  id: path+"",
                                  artist: artist,
                                  name: name,
                                  url: path+"",
                                  album: "本地音乐",
                                  type: "1" // 1表示本地音乐，0表示网络音乐
                              })
                }
                saveLocal(list)
            }
        }
    }
}



