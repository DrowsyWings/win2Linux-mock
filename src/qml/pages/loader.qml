import QtQuick 
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami

Kirigami.Page {
    visible: true
    width: 640
    height: 480

    Item {
        id: loaderRoot
        width: Kirigami.Units.gridUnit * 20
        height: Kirigami.Units.gridUnit * 25  
        anchors.centerIn: parent  

        Canvas {
            id: staticRing
            anchors.centerIn: parent
            width: Kirigami.Units.gridUnit * 14
            height: width
            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);
                ctx.lineWidth = Kirigami.Units.gridUnit; 
                ctx.strokeStyle = "#4285F4"; 

                ctx.beginPath();
                ctx.arc(width / 2, height / 2, width / 2.5, 0, Math.PI * 2);
                ctx.stroke();
            }
        }

        Rectangle {
            id: rotatingRectangle
            width: staticRing.width
            height: staticRing.height
            color: "transparent"
            anchors.centerIn: staticRing

            // Rotation logic
        }

        Item {
            id: charactersContainer
            anchors.centerIn: staticRing
            width: staticRing.width * 0.7
            height: width

            Row {
                anchors.centerIn: parent
                spacing: Kirigami.Units.largeSpacing

                Image {
                    id: konqiImage
                    source: "../../../assets/konqi.png"  
                    width: Kirigami.Units.gridUnit * 6
                    height: width
                    fillMode: Image.PreserveAspectFit
                }

                Image {
                    id: katieImage
                    source: "../../../assets/katie.png"  
                    width: Kirigami.Units.gridUnit * 6
                    height: width
                    fillMode: Image.PreserveAspectFit
                }
            }
        }

        Controls.Label {
            anchors {
                top: staticRing.bottom
                topMargin: Kirigami.Units.largeSpacing * 2
                horizontalCenter: parent.horizontalCenter
            }
            text: qsTr("Konqi and Katie are thinking about\nyour answer...")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: Kirigami.Theme.defaultFont.pixelSize * 1.5
            wrapMode: Text.Wrap
        }

        property bool isLoading: true
        visible: isLoading
    }
}
