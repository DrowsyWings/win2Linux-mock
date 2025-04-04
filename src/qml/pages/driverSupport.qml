import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Kirigami.Page {
    id: nvidiaInfoPage
    title: qsTr("Win2Linux")
    font.weight: 700
    padding: 0
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Kirigami.Units.gridUnit * 2
        spacing: Kirigami.Units.gridUnit * 2

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

        Kirigami.ScrollablePage {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: Kirigami.Units.gridUnit * -2 
            Layout.minimumHeight: Kirigami.Units.gridUnit * 18  
            
            ColumnLayout {
                width: parent.width
                spacing: Kirigami.Units.gridUnit
                anchors.margins: Kirigami.Units.gridUnit * 3
                
                Kirigami.Heading {
                    text: qsTr("Understanding Nvidia Drivers on Linux")
                    level: 1
                    Layout.topMargin: Kirigami.Units.gridUnit
                    
                }
                
                Controls.Label {
                    text: qsTr("Nvidia graphics cards can sometimes be challenging to set up on Linux systems due to proprietary driver requirements. Here's what you should know:")
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }
                
                Repeater {
                    model: [
                        "Nvidia provides proprietary drivers that offer better performance but may require manual installation",
                        "Open-source alternatives (nouveau) are available but may have limited features",
                        "Different distributions handle Nvidia drivers differently",
                        "Additional configuration may be needed for optimal performance"
                    ]

                    delegate: RowLayout {
                        Layout.alignment: Qt.AlignLeading
                        spacing: Kirigami.Units.smallSpacing
                        Layout.fillWidth: true

                        Kirigami.Icon {
                            source: "dialog-information"
                            Layout.preferredWidth: Kirigami.Units.iconSizes.small
                            Layout.preferredHeight: Kirigami.Units.iconSizes.small
                            color: Kirigami.Theme.highlightColor
                        }

                        Controls.Label {
                            text: modelData
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                        }
                    }
                }
                
                Kirigami.Heading {
                    text: qsTr("Driver Installation Resources")
                    level: 2
                    Layout.topMargin: Kirigami.Units.gridUnit
                }
                
                Kirigami.Card {
                    Layout.fillWidth: true
                    
                    header: Kirigami.Heading {
                        text: qsTr("Official NVIDIA Driver Resources")
                        level: 3
                        padding: Kirigami.Units.largeSpacing
                    }
                    
                    contentItem: ColumnLayout {
                        spacing: Kirigami.Units.smallSpacing
                        
                        Controls.Label {
                            text: qsTr("For the best compatibility and performance, we recommend visiting NVIDIA's official driver pages:")
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                        }
                        
                        RowLayout {
                            Layout.fillWidth: true
                            Layout.topMargin: Kirigami.Units.smallSpacing
                            
                            Controls.Button {
                                text: qsTr("NVIDIA Windows/Linux Drivers")
                                icon.name: "globe"
                                Layout.fillWidth: true
                                
                                onClicked: {
                                    Qt.openUrlExternally("https://www.nvidia.com/en-us/drivers/")
                                }
                            }
                            
                            Controls.Button {
                                text: qsTr("NVIDIA Unix Drivers")
                                icon.name: "globe"
                                Layout.fillWidth: true
                                
                                onClicked: {
                                    Qt.openUrlExternally("https://www.nvidia.com/en-us/drivers/unix/")
                                }
                            }
                        }
                        
                        Controls.Label {
                            text: qsTr("These official sources provide the latest drivers for your specific GPU model and operating system. We recommend consulting your distribution's documentation for integration instructions.")
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                            Layout.topMargin: Kirigami.Units.smallSpacing
                        }
                    }
                }
                
                Item {
                    // Spacer
                    Layout.preferredHeight: Kirigami.Units.gridUnit * 2
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

            // Recommended KDE Apps Button
            Controls.Button {
                id: appsButton
                text: qsTr("Recommended KDE Apps")
                Layout.alignment: Qt.AlignVCenter

                Keys.onReturnPressed: clicked()
                Keys.onEnterPressed: clicked()
                KeyNavigation.tab: backButton
                
                onClicked: {
                    var url = Qt.resolvedUrl("SoftwareAlternatives.qml");
                    if (url) {
                        pageStack.pop()
                        pageStack.push(url);
                    } else {
                        console.error("Failed to resolve URL");
                    }
                }
            }
        }
        
        Item {
            Layout.fillHeight: true
        }
    }
}