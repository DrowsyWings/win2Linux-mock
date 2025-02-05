import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami

Kirigami.ApplicationWindow {
    id: root

    title: qsTr("Win2Linux:Chooser")

    minimumWidth: Kirigami.Units.gridUnit * 30
    minimumHeight: Kirigami.Units.gridUnit * 25
    width: minimumWidth * 1.5
    height: minimumHeight * 1.5

    pageStack.initialPage: initPage

    Component {
        id: initPage

        Kirigami.Page {
            id: welcomePage
            title: qsTr("Welcome to Win2Linux")

            ColumnLayout {
                anchors {
                    fill: parent
                    margins: Kirigami.Units.largeSpacing
                }

                Kirigami.Page {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Kirigami.Units.gridUnit * 8

                    header: Kirigami.Heading {
                        text: qsTr("Start Your Linux Journey")
                        level: 2
                        padding: Kirigami.Units.largeSpacing
                    }

                    contentItem: ColumnLayout {
                        spacing: Kirigami.Units.largeSpacing
                        Controls.Label {
                            text: qsTr("This assistant will help you choose the right Linux distribution and tools based on your needs. We'll ask you a few questions about how you use your computer to provide personalized recommendations.")
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                            padding: Kirigami.Units.largeSpacing
                        }
                    }
                }

                Kirigami.Card {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Kirigami.Units.gridUnit * 12
                    Layout.topMargin: Kirigami.Units.largeSpacing

                    header: Kirigami.Heading {
                        text: qsTr("Before We Begin")
                        level: 3
                        padding: Kirigami.Units.largeSpacing
                    }

                    contentItem: ColumnLayout {
                        spacing: Kirigami.Units.largeSpacing

                        Controls.Label {
                            text: qsTr("We'll help you with:")
                            font.bold: true
                        }

                        Repeater {
                            model: [
                                "Finding the right Linux distribution for your needs",
                                "Identifying Linux alternatives to your Windows software",
                                "Getting started with the installation process"
                            ]

                            delegate: RowLayout {
                                Layout.fillWidth: true
                            
                                spacing: Kirigami.Units.smallSpacing

                                Kirigami.Icon {
                                    source: "checkmark"
                                    Layout.preferredWidth: Kirigami.Units.iconSizes.small
                                    Layout.preferredHeight: Kirigami.Units.iconSizes.small
                                }

                                Controls.Label {
                                    text: modelData
                                    Layout.fillWidth: true
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

                    Item {
                        Layout.fillWidth: true
                    }

                    Controls.Button {
                        text: qsTr("Exit")
                        icon.name: "dialog-cancel"
                        onClicked: Qt.quit()
                    }

                    Controls.Button {
                        text: qsTr("Start Questionnaire")
                        icon.name: "arrow-right"
                        onClicked: {
                            // TODO: Navigate to first question page
                            // pageStack.push(firstQuestionPage)
                        }
                    }
                }
            }
        }
    }
}