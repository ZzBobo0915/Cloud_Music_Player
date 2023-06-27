import QtQuick 2.12
import QtQuick.Controls 2.12

Button{
    property alias btnText: self.text

    property alias btnHeight: self.height
    property alias btnWidth: self.width

    property alias isCheckable: self.checkable
    property alias isChecked: self.checked

    id: self
    text: "Button"
    width: 50
    height: 50
    checkable: false
    checked: false

    font.family: window.mFONT_FAMILY
    font.pointSize: 12

    background: Rectangle{
        implicitHeight: self.height
        implicitWidth: self.width
        color: self.down||(self.checkable&&self.checked)?"#e2f0f8":"#ff5656"  // 是否被按下
        radius: 3
    }

}
