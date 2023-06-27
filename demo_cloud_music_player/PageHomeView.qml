import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtQml 2.12

RowLayout{
    property int defaultIndex: 0

    property var qmlList: [
        {icon: "recommend", value: "发现音乐", qml:"DetailRecommendPageView", menu: true},
        {icon: "cloud", value: "搜索音乐", qml:"DetailSearchPageView", menu: true},
        {icon: "local", value: "本地音乐", qml:"DetailLocalPageView", menu: true},
        {icon: "history", value: "播放历史", qml:"DetailHistoryPageView", menu: true},
        {icon: "favorite-big", value: "我喜欢的", qml:"DetailFavoritePageView", menu: true},
        {icon: "", value: "", qml:"DetailPlayListPageView", menu: false}
    ]

    spacing: 0

    Frame {
        Layout.preferredWidth: 200
        Layout.fillHeight: true
        //Layout.fillWidth: true
        background: Rectangle{
            //color: "#AA00AAAA"
            color: "#ffffff"
        }
        padding: 0  // 内边距

        ColumnLayout{
            anchors.fill: parent

            Item{
                Layout.fillWidth: true
                Layout.preferredHeight: 150
                MusicBorderImage{
                    anchors.centerIn: parent
                    height: 100
                    width: 100
                    borderRadius: 100
                }
            }

            // 列表菜单
            ListView{
                //id: menuListView
                id: menuView
                height: parent.height
                Layout.fillHeight: true
                Layout.fillWidth: true
                model: ListModel{
                    id: menuViewModel
                }
                delegate: menuViewDelegate
                highlight: Rectangle{
                    color: "#f1efed"
                }
                highlightMoveDuration: 10    // 设置切换列表中的变形时间
                highlightResizeDuration: 10  // 设置下拉列表的变形时间
            }
        }

        Component {
            id: menuViewDelegate
            Rectangle{
                id: menuViewDelegateItem
                width: 200
                height: 50
                color: menuView.isCurrentItem?"#f1efed":"#ffffff"
                RowLayout{
                    anchors.fill: parent
                    anchors.centerIn: parent
                    spacing: 15
                    Item{
                       width: 30
                    }
                    Image{
                        source: "qrc:/images/"+icon
                        Layout.preferredHeight: 20
                        Layout.preferredWidth: 20
                    }
                    Text{
                        text: value
                        Layout.fillWidth: true
                        height: 50
                        font.family: window.mFONT_FAMILY
                        font.pointSize: 12
                        color: "#000000"
                    }
                }
                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        color = "#f1efed"//"#aa73a7ab"
                    }
                    onExited: {
                        color = "#ffffff"//index===menuViewDelegateItem.ListView.view.currentIndex?"#f1efed":"#ffffff"
                    }
                    onClicked: {
                        hidePlayList()
                        repeater.itemAt(menuViewDelegateItem.ListView.view.currentIndex).visible = false
                        menuViewDelegateItem.ListView.view.currentIndex = index
                        var loader = repeater.itemAt(index)
                        loader.visible = true
                        loader.source = qmlList[index].qml + ".qml"
                        console.log(menuView.isCurrentItem)
                        color = "#f1efed"
                    }
                    onCanceled: {
                        color = "#ffffff"
                    }
                }
            }
        }
        Component.onCompleted: {
            menuViewModel.append(qmlList.filter(item=>item.menu))
            var loader = repeater.itemAt(defaultIndex)
            loader.visible = true
            loader.source = qmlList[defaultIndex].qml + ".qml"

            menuView.currentIndex = defaultIndex
        }
    }



    Repeater{  // 重复构造
        id: repeater
        model: qmlList.length  // filter过滤
        Loader {
           visible: false
           Layout.fillWidth: true
           Layout.fillHeight: true

        }
    }

    function showPlayList(targetId="", targetType="1000"){
        repeater.itemAt(menuView.currentIndex).visible = false
        var loader = repeater.itemAt(5)
        loader.visible = true
        loader.source = qmlList[5].qml + ".qml"
        // 这里type一定要放在id之前，不然id先改变会直接触发idchange
        loader.item.targetType = targetType
        loader.item.targetId = targetId
    }

    function hidePlayList(){
        repeater.itemAt(menuView.currentIndex).visible = true
        var loader = repeater.itemAt(5)
        loader.visible = false
    }


}

