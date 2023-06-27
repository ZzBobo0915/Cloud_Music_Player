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
                text: qsTr("我喜欢的")
                font.family: window.mFONT_FAMILY
                font.pointSize: 20
            }
        }
    }
}

