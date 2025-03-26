import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Kirigami.Page {
    id: hardwarePage
    title: qsTr("Hardware Information")
    padding: 0
    
    // Property to track if hardware info has been collected
    property bool hardwareInfoCollected: false
    property var hardwareVector: []

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Kirigami.Units.gridUnit * 2
        spacing: Kirigami.Units.gridUnit * 2

        // Header with logo
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

        // Main content
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Kirigami.Units.gridUnit * 20
            
            ColumnLayout {
                anchors.fill: parent
                spacing: Kirigami.Units.gridUnit

                Kirigami.Heading {
                    text: qsTr("Hardware Compatibility")
                    level: 2
                    Layout.alignment: Qt.AlignLeading
                }

                Controls.Label {
                    text: qsTr("Let's check your hardware compatibility with Linux. Click the button below to scan your system and get a detailed report.")
                    font.pixelSize: Kirigami.Theme.defaultFont.pixelSize * 1.1
                    Layout.fillWidth: true
                    wrapMode: Text.Wrap
                    elide: Text.ElideNone
                    Layout.alignment: Qt.AlignLeading
                }

                // Hardware Info Button
                Controls.Button {
                    id: scanButton
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: Kirigami.Units.gridUnit * 12
                    Layout.preferredHeight: Kirigami.Units.gridUnit * 3
                    focus: true
                    
                    Keys.onReturnPressed: clicked()
                    Keys.onEnterPressed: clicked()
                    KeyNavigation.tab: outputArea

                    background: Rectangle {
                        color: parent.enabled ? (parent.hovered || parent.activeFocus ? "#8CE743" : "#96F948") : "#CCCCCC"
                        radius: height / 4
                    }

                    contentItem: Controls.Label {
                        text: qsTr("Scan Hardware")
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: "#000000"
                    }

                    onClicked: hardwareInfo.collect_hardware_info()
                }

                // Results area in a scrollable container
                Kirigami.ScrollablePage {
                    id: scrollContainer
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    padding: 0
                    
                    Controls.TextArea {
                        id: outputArea
                        width: parent.width
                        wrapMode: Controls.TextArea.Wrap
                        readOnly: true
                        text: qsTr("Hardware information will appear here after scanning.")
                        background: Rectangle {
                            color: Kirigami.Theme.backgroundColor
                            border.color: Kirigami.Theme.disabledTextColor
                            border.width: 1
                            radius: 4
                        }
                        KeyNavigation.tab: backButton
                    }
                }
            }
        }

        // Navigation buttons (Back, Skip, Proceed)
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: Kirigami.Units.gridUnit * 2
            Layout.topMargin: Kirigami.Units.gridUnit

            // Back Button (to questionnaire)
            Controls.Button {
                id: backButton
                text: qsTr("Back")
                Layout.alignment: Qt.AlignVCenter
                focus: true
                
                Keys.onReturnPressed: clicked()
                Keys.onEnterPressed: clicked()
                KeyNavigation.tab: skipButton

                onClicked: {
                    var url = Qt.resolvedUrl("questionnaire.qml")
                    if (url) {
                        pageStack.pop()
                        pageStack.push(url)
                    } else {
                        console.error("Failed to resolve URL")
                    }
                }
            }

            Item {
                // Spacer
                Layout.fillWidth: true
                Layout.minimumWidth: Kirigami.Units.gridUnit * 5
            }

            // Skip Button
            Controls.Button {
                id: skipButton
                text: qsTr("Skip")
                Layout.alignment: Qt.AlignVCenter
                
                Keys.onReturnPressed: clicked()
                Keys.onEnterPressed: clicked()
                KeyNavigation.tab: proceedButton

                onClicked: {
                    var url = Qt.resolvedUrl("resultPage.qml")
                    if (url) {
                        pageStack.pop()
                        pageStack.push(url)
                    } else {
                        console.error("Failed to resolve URL")
                    }
                }
            }

            // Proceed Button
            Controls.Button {
                id: proceedButton
                text: qsTr("Proceed")
                enabled: hardwarePage.hardwareInfoCollected
                Layout.alignment: Qt.AlignVCenter
                
                Keys.onReturnPressed: clicked()
                Keys.onEnterPressed: clicked()
                KeyNavigation.tab: mainMenuButton

                onClicked: {
                    if (hardwarePage.hardwareInfoCollected) {
                        var url = Qt.resolvedUrl("resultPage.qml")
                        if (url) {
                            pageStack.pop()
                            pageStack.push(url,{hardwareVector: hardwareVector})
                        } else {
                            console.error("Failed to resolve URL")
                        }
                    }
                }
            }
        }

        // Back to main menu Button
        Controls.Button {
            id: mainMenuButton
            text: qsTr("Back to Main Menu")
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: Kirigami.Units.gridUnit * -1
            Layout.bottomMargin: Kirigami.Units.gridUnit * 2
            focus: true

            onClicked: {
                var url = Qt.resolvedUrl("welcomePage.qml")
                if (url) {
                    pageStack.pop()
                    pageStack.push(url)
                } else {
                    console.error("Failed to resolve URL")
                }
            }
            KeyNavigation.tab: scanButton
        }

        // Connections to update the text area
        Connections {
            target: hardwareInfo
            function onDataUpdated(jsonData) {
                outputArea.text = jsonData
                hardwarePage.hardwareVector = hardwareClassifier.classify_hardware()
                hardwarePage.hardwareInfoCollected = true
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
