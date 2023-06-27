import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item {
    ColumnLayout{
        Rectangle{
            Layout.fillWidth: true
            width: parent.width
            height: 50
            color: "#000000"
            Text{
                x: 10
                verticalAlignment: Text.AlignBottom
                text: qsTr("历史播放")
                font.family: window.mFONT_FAMILY
                font.pointSize: 20
            }
        }
    }
}
