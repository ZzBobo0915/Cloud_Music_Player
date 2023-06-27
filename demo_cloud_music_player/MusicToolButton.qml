import QtQuick 2.12
import QtQuick.Controls 2.12

ToolButton{
    property string iconSource: ""

    property string toolTip: ""

    property bool isCheckable: false
    property bool isChecked: false

    id: self
    width: 32
    height: 32
    icon.source: iconSource
    icon.color: self.down||(isCheckable&&self.checked)?"#000000":"#eeeeee"

    ToolTip.text: toolTip
    ToolTip.visible: hovered

    background: Rectangle{
        color: self.down||(isCheckable&&self.checked)?"#eeeeee":"#000000"  // 是否被按下
    }
    checkable: isCheckable
    checked: isChecked
}
