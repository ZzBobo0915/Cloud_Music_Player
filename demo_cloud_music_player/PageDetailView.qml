import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQml 2.12
import QtQuick.Layouts 1.12


Item {
    Layout.fillHeight: true
    Layout.fillWidth: true

    property alias lyrics : lyricsView.lyrics
    property alias current: lyricsView.current

    RowLayout{
        anchors.fill: parent
        Frame{

            Layout.preferredWidth: parent.width * 0.45
            Layout.fillHeight: true
            Text{
                id: name
                text: layoutBottomView.musicName
                anchors{
                    bottom: artist.top
                    bottomMargin: 20
                    horizontalCenter: parent.horizontalCenter
                }
                font{
                    family: window.mFONT_FAMILY
                    pointSize: 16
                }
            }
            Text{
                id: artist
                text: layoutBottomView.musicArtist
                anchors{
                    bottom: cover.top
                    topMargin: 50
                    bottomMargin: 20
                    horizontalCenter: parent.horizontalCenter
                }
                font{
                    family: window.mFONT_FAMILY
                    pointSize: 12
                }

            }

            MusicBorderImage{
                id: cover
                anchors.centerIn: parent
                width: parent.width * 0.6
                height: width
                borderRadius: width
                imgSrc: layoutBottomView.musicCover
                isRotating: layoutBottomView.playingState === 1
            }
        }

        Frame{
            Layout.preferredWidth: parent.width * 0.55
            Layout.fillHeight: true

            MusicLyricsView{
                id: lyricsView
                anchors.fill: parent
            }

        }
    }
}
