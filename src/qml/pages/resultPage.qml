import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Kirigami.Page {
    id: resultPage
    title: qsTr("Recommended Linux Distributions")

    property var hardwareVector: []
    ListModel {
        id: rankingsModel
    }

    Connections {
        target: hardwareInfo
        function onHardwareCheckCompleted(success, hardwareVector) {
            if (success) {
                resultPage.hardwareVector = hardwareVector;
                recommenderModel.calculate_rankings(hardwareVector);
            } else {
                recommenderModel.calculate_rankings();
            }
        }
    }

    Connections {
        target: recommenderModel
        function onRankingsUpdated(rankings) {
            rankingsModel.clear();
            for (var i = 0; i < rankings.length; i++) {
                rankingsModel.append(rankings[i]);
            }
        }
    }

    Component.onCompleted: {
        hardwareInfo.runHardwareScript();
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
            model: rankingsModel
            
            delegate: Item {
                width: parent.width
                height: Kirigami.Units.gridUnit * 3

                RowLayout {
                    anchors.fill: parent

                    Controls.Label {
                        text: model.distro.replace("_", " ")
                        Layout.fillWidth: true
                        font.bold: true
                    }

                    Controls.Label {
                        text: model.score !== undefined ? model.score.toFixed(2) + " points" : "N/A"
                        Layout.rightMargin: Kirigami.Units.gridUnit
                    }
                }
            }
        }

        Controls.Button {
            text: qsTr("Back to Main Menu")
            Layout.alignment: Qt.AlignHCenter
            onClicked: {
                var url = Qt.resolvedUrl("welcomePage.qml");
                if (url) {
                    pageStack.pop();
                    pageStack.push(url);
                } else {
                    console.error("Failed to resolve URL");
                }
            }
        }
    }
}
