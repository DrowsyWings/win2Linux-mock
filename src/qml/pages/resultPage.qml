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

    Component.onCompleted: {
        // Hardcoded data for UI testing
        rankingsModel.clear();
        rankingsModel.append({ 
            rank: 1, 
            distro: "Kubuntu", 
            logo: "../../../assets/kubuntu.png",
            features: ["Windows-like flow", "Seamless setup"],
            learnMore: "https://kubuntu.org/getkubuntu/"
        });
        rankingsModel.append({ 
            rank: 2, 
            distro: "Arch Linux", 
            logo: "../../../assets/arch.png",
            features: ["Matches tinkering needs", "Bragging rights"],
            learnMore: "https://archlinux.org/download/"
        });
        rankingsModel.append({ 
            rank: 3, 
            distro: "Linux Mint", 
            logo: "../../../assets/mint.png",
            features: ["Big community", "Excellent software support"],
            learnMore: "https://linuxmint.com/download.php"
        });
           rankingsModel.append({ 
            rank: 4, 
            distro: "Linux Mint", 
            logo: "../../../assets/mint.png",
            features: ["Big community", "Excellent software support"],
            learnMore: "https://linuxmint.com/download.php"
        });
           rankingsModel.append({ 
            rank: 5, 
            distro: "Linux Mint", 
            logo: "../../../assets/mint.png",
            features: ["Big community", "Excellent software support"],
            learnMore: "https://linuxmint.com/download.php"
        });
        
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
                            source: model.logo
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
                                visible: model.learnMore !== ""
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