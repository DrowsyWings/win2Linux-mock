import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Kirigami.Page {
    id: resultPage
    title: qsTr("Recommended Linux Distributions")
    
    property var rankingsList: []
    
    Connections {
        target: recommenderModel
        function onRankingsChanged(rankings) {
            rankingsList = rankings;
        }
    }
    
    Component.onCompleted: {
        recommenderModel.calculate_rankings();
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Kirigami.Units.gridUnit * 2
        spacing: Kirigami.Units.gridUnit * 2

        Kirigami.Heading {
            text: qsTr("Your Recommended Linux Distributions")
            level: 2
            Layout.alignment: Qt.AlignHCenter
        }

        Controls.Label {
            text: qsTr("Based on your answers, here are your top Linux recommendations:")
            wrapMode: Text.Wrap
            Layout.fillWidth: true
        }

        ListView {
            id: recommendationsList
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: rankingsList.length > 0 ? rankingsList : recommenderModel.get_rankings()
            
            delegate: Item {
                width: parent.width
                height: Kirigami.Units.gridUnit * 3

                RowLayout {
                    anchors.fill: parent

                    Controls.Label {
                        text: modelData.distro.replace("_", " ")
                        Layout.fillWidth: true
                        font.bold: true
                    }

                    Controls.Label {
                        text: {
                            var scoreNum = Number(modelData.score);
                            return isNaN(scoreNum) ? "N/A" : scoreNum.toFixed(2) + " points";
                        }
                        Layout.rightMargin: Kirigami.Units.gridUnit
                    }
                }
            }
        }

        Controls.Button {
            text: qsTr("Back to Main Menu")
            Layout.alignment: Qt.AlignHCenter
            onClicked:{
                var url = Qt.resolvedUrl("welcomePage.qml")
                if(url){
                    pageStack.pop()
                    pageStack.push(url)
                } else {
                    console.error("Failed to resolve URL")
                }
                
            }
        }
    }
}