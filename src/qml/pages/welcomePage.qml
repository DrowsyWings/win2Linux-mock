import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Kirigami.Page {
    id: welcomePage
    title: qsTr("Welcome to Win2Linux")

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Kirigami.Units.largeSpacing

        Kirigami.Heading {
            text: qsTr("Start Your Linux Journey")
            level: 2
            Layout.fillWidth: true
        }

        Controls.Label {
            text: qsTr("Let's personalize your Linux experience!")
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
            Layout.topMargin: Kirigami.Units.largeSpacing
        }

        Kirigami.Card {
            Layout.fillWidth: true
            Layout.preferredHeight: Kirigami.Units.gridUnit * 12
            Layout.topMargin: Kirigami.Units.largeSpacing

            header: Kirigami.Heading {
                text: qsTr("Before We Begin")
                level: 3
            }

            contentItem: ColumnLayout {
                Controls.Label {
                    text: qsTr("We'll help you with:")
                    font.bold: true
                }

                Repeater {
                    model: [
                        "Finding the right Linux distribution",
                        "Identifying Linux alternatives to Windows software",
                        "Getting started with installation"
                    ]

                    delegate: RowLayout {
                        Kirigami.Icon {
                            source: "checkmark"
                            Layout.preferredWidth: Kirigami.Units.iconSizes.small
                            Layout.preferredHeight: Kirigami.Units.iconSizes.small
                        }
                        Controls.Label {
                            text: modelData
                            wrapMode: Text.WordWrap
                        }
                    }
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.margins: Kirigami.Units.largeSpacing

            Controls.Button {
                text: qsTr("Exit")
                icon.name: "dialog-cancel"
                onClicked: Qt.quit()
            }

            Item {
                Layout.fillWidth: true
            }

            Controls.Button {
                text: qsTr("Previous")
                icon.name: "arrow-left"
                enabled: false  
            }

            Controls.Button {
                text: qsTr("Start")
                icon.name: "arrow-right"
                onClicked: pageStack.push(Qt.createComponent("pages/questionnaires.qml"))
            }
        }
    }
}