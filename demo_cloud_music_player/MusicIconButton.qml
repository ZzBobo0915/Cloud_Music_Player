import QtQuick 2.12
import QtQuick.Controls 2.12

Button{
    property string iconSource: ""

    property string toolTip: ""

    property int iconHeight: 32
    property int iconWidth: 32

    property bool isCheckable: false
    property bool isChecked: false

    id: self

    icon.source: iconSource
    icon.width: iconWidth
    icon.height: iconHeight
    icon.color: self.down||(isCheckable&&self.checked)?"#ffffff":"#e2f0f8"

    ToolTip.text: toolTip
    ToolTip.visible: hovered

    background: Rectangle{
        color: self.down||(isCheckable&&self.checked)?"#ffffff":"#20000000"//"#497563":"#2939f4ff"  // 是否被按下
        radius: 3
    }

    checkable: isCheckable
    checked: isChecked
}
