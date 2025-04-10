import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Kirigami.Page {
    id: resultPage
    title: qsTr("Our Verdict")
    property var hardwareVector: []
    padding: 0

    ListModel {
        id: rankingsModel
    }

    // Define distro metadata for UI display
    property var distroInfo: {
        "kubuntu": {
            logo: "../../../assets/kubuntu.png",
            features: ["Windows-like flow", "Seamless setup"],
            learnMore: "https://kubuntu.org/getkubuntu/"
        },
        "linux_mint_xfce": {
            logo: "../../../assets/mint.png",
            features: ["Old Hardware Support", "Excellent software support"],
            learnMore: "https://linuxmint.com/download.php"
        },
        "linux_mint_cinnamon": {
            logo: "../../../assets/mint.png",
            features: ["Big community", "Excellent software support"],
            learnMore: "https://linuxmint.com/download.php"
        },
        "fedora": {
            logo: "../../../assets/fedora.png",
            features: ["Latest technologies", "Enterprise-backed"],
            learnMore: "https://getfedora.org/"
        },
        "pop_os": {
            logo: "../../../assets/popos.png",
            features: ["Great for developers", "Nvidia support"],
            learnMore: "https://pop.system76.com/"
        },
        "lubuntu": {
            logo: "../../../assets/lubuntu.png",
            features: ["Great for developers", "Nvidia support"],
            learnMore: "https://pop.system76.com/"
        },
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
                var distroId = rankings[i].distro.toLowerCase();
                var metadata = distroInfo[distroId] || {
                    logo: "../../../assets/distro.png",
                    features: ["Linux distribution"],
                    learnMore: ""
                };
                
                rankingsModel.append({ 
                    rank: i + 1,
                    distro: rankings[i].distro.replace("_", " "),
                    score: rankings[i].score,
                    logo: metadata.logo,
                    features: metadata.features,
                    learnMore: metadata.learnMore
                });
            }
        }
    }

    Component.onCompleted: {
        // rankings without hardware info
        if (skipMode) {
            recommenderModel.calculate_rankings();
        }
        
        // Hardcoded data if no rankings (will remove after complete testing)
        if (rankingsModel.count === 0) {
            // Sample data 
            var sampleRankings = [
                { distro: "kubuntu", score: 0.92 },
                { distro: "lubuntu", score: 0.88 },
                { distro: "linux_mint_xfce", score: 0.84 },
                { distro: "pop_os", score: 0.80 },
                { distro: "fedora", score: 0.75 }
            ];
            
            for (var i = 0; i < sampleRankings.length; i++) {
                var distroId = sampleRankings[i].distro.toLowerCase();
                var metadata = distroInfo[distroId] || {
                    logo: "../../../assets/distro.png",
                    features: ["Linux distribution"],
                    learnMore: ""
                };
                
                rankingsModel.append({ 
                    rank: i + 1,
                    distro: sampleRankings[i].distro.replace("_", " "),
                    score: sampleRankings[i].score,
                    logo: metadata.logo,
                    features: metadata.features,
                    learnMore: metadata.learnMore
                });
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Kirigami.Units.gridUnit * 2
        spacing: Kirigami.Units.gridUnit * 1

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: Kirigami.Units.largeSpacing

            Image {
                source: "../../../assets/logo-150x150.png"
                Layout.preferredWidth: Kirigami.Units.gridUnit * 3
                Layout.preferredHeight: Kirigami.Units.gridUnit * 3
            }

            ColumnLayout {
                spacing: Kirigami.Units.smallSpacing
                Layout.alignment: Qt.AlignVCenter

                Kirigami.Heading {
                    text: "Win2Linux"
                    level: 1
                    font.pixelSize: Kirigami.Theme.defaultFont.pixelSize * 2
                }
            }
        }

        Kirigami.Heading {
            text: qsTr("Our Verdict")
            level: 2
            Layout.alignment: Qt.AlignLeading
        }

        Controls.Label {
            text: qsTr("Based on your answers, here are your top Linux recommendations:")
            wrapMode: Text.Wrap
            Layout.fillWidth: true
        }

        Kirigami.ScrollablePage {
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentWidth: availableWidth

            ListView {
                id: verdictList
                width: parent.width
                clip: true
                model: rankingsModel
                spacing: Kirigami.Units.smallSpacing
                
                delegate: Kirigami.AbstractCard {
                    width: ListView.view.width
                    padding: Kirigami.Units.largeSpacing
                    
                    contentItem: RowLayout {
                        spacing: Kirigami.Units.largeSpacing
                        
                        Image {
                            source: model.logo || "../../../assets/distro.png"
                            Layout.preferredWidth: Kirigami.Units.gridUnit * 4
                            Layout.preferredHeight: Kirigami.Units.gridUnit * 4
                            fillMode: Image.PreserveAspectFit
                        }
                        
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Kirigami.Units.smallSpacing
                            
                            RowLayout {
                                spacing: Kirigami.Units.smallSpacing
                                
                                Controls.Label {
                                    text: "#" + model.rank
                                    font.bold: true
                                    font.pixelSize: Kirigami.Theme.defaultFont.pixelSize * 1.2
                                }
                                
                                Controls.Label {
                                    text: model.distro
                                    font.bold: true
                                    font.pixelSize: Kirigami.Theme.defaultFont.pixelSize * 1.2
                                }
                            }
                            
                            Repeater {
                                model: features
                                delegate: Controls.Label {
                                    text: "+ " + modelData
                                    visible: modelData !== undefined
                                }
                            }
                            
                            Controls.Label {
                                text: "Learn more: " + model.learnMore
                                font.italic: true
                                visible: model.learnMore !== undefined && model.learnMore !== ""
                                Layout.topMargin: Kirigami.Units.smallSpacing
                            }
                        }
                    }
                }
            }
        }

        // Navigation buttons
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: Kirigami.Units.gridUnit * 2
            Layout.topMargin: Kirigami.Units.gridUnit

            // Back to Main Menu Button
            Controls.Button {
                id: backButton
                text: qsTr("Back to Main Menu")
                Layout.alignment: Qt.AlignVCenter
                focus: true
                
                Keys.onReturnPressed: clicked()
                Keys.onEnterPressed: clicked()
                KeyNavigation.tab: testButton

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

            Item {
                // Spacer
                Layout.fillWidth: true
                Layout.minimumWidth: Kirigami.Units.gridUnit * 6
            }

            // Take the test again Button
            Controls.Button {
                id: testButton
                text: qsTr("Take the test again")
                Layout.alignment: Qt.AlignVCenter
                
                Keys.onReturnPressed: clicked()
                Keys.onEnterPressed: clicked()
                KeyNavigation.tab: appsButton

                onClicked: {
                    var url = Qt.resolvedUrl("questionnaire.qml");
                    if (url) {
                        pageStack.pop();
                        pageStack.push(url);
                    } else {
                        console.error("Failed to resolve URL");
                    }
                }
            }

            Controls.Button {
                id: appsButton
                text: qsTr("Nvidia Driver Info")
                Layout.alignment: Qt.AlignVCenter

                Keys.onReturnPressed: clicked()
                Keys.onEnterPressed: clicked()
                KeyNavigation.tab: backButton
                
                onClicked: {
                    var url = Qt.resolvedUrl("driverSupport.qml");
                    if (url) {
                        pageStack.pop()
                        pageStack.push(url);
                    } else {
                        console.error("Failed to resolve URL");
                    }
                }
            }
        }
    }
}