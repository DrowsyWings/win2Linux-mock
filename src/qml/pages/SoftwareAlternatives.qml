import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Kirigami.Page {
    id: appsPage
    title: qsTr("Our Renowned Apps")
    padding: 0

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Kirigami.Units.gridUnit * 2
        spacing: Kirigami.Units.gridUnit * 2

        Controls.Label {
            text: qsTr("Packed with our KDE desktop and available to all Linux users, we ship a large variety of free and powerful applications that cater to a wide range of use cases!")
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            horizontalAlignment: Text.AlignHCenter
        }

        GridLayout {
            Layout.alignment: Qt.AlignHCenter
            columns: 2
            rowSpacing: Kirigami.Units.gridUnit * 3
            columnSpacing: Kirigami.Units.gridUnit * 6

            // Kdenlive
            ColumnLayout {
                spacing: Kirigami.Units.smallSpacing
                Image {
                    source: "../../../assets/kdenlive.png"
                    Layout.preferredWidth: Kirigami.Units.gridUnit * 3
                    Layout.preferredHeight: Kirigami.Units.gridUnit * 3
                    Layout.alignment: Qt.AlignHCenter
                }
                Controls.Label {
                    text: "Kdenlive"
                    font.weight: Font.Bold
                    Layout.alignment: Qt.AlignHCenter
                }
                Controls.Label {
                    text: "Video editor"
                    opacity: 0.7
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            // Krita
            ColumnLayout {
                spacing: Kirigami.Units.smallSpacing
                Image {
                    source: "../../../assets/krita.png"
                    Layout.preferredWidth: Kirigami.Units.gridUnit * 3
                    Layout.preferredHeight: Kirigami.Units.gridUnit * 3
                    Layout.alignment: Qt.AlignHCenter
                }
                Controls.Label {
                    text: "Krita"
                    font.weight: Font.Bold
                    Layout.alignment: Qt.AlignHCenter
                }
                Controls.Label {
                    text: "Digital art"
                    opacity: 0.7
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            // Okular
            ColumnLayout {
                spacing: Kirigami.Units.smallSpacing
                Image {
                    source: "../../../assets/okular.png"
                    Layout.preferredWidth: Kirigami.Units.gridUnit * 3
                    Layout.preferredHeight: Kirigami.Units.gridUnit * 3
                    Layout.alignment: Qt.AlignHCenter
                }
                Controls.Label {
                    text: "Okular"
                    font.weight: Font.Bold
                    Layout.alignment: Qt.AlignHCenter
                }
                Controls.Label {
                    text: "PDF reader"
                    opacity: 0.7
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            // KDE Connect
            ColumnLayout {
                spacing: Kirigami.Units.smallSpacing
                Image {
                    source: "../../../assets/kdeConnect.png"
                    Layout.preferredWidth: Kirigami.Units.gridUnit * 3
                    Layout.preferredHeight: Kirigami.Units.gridUnit * 3
                    Layout.alignment: Qt.AlignHCenter
                }
                Controls.Label {
                    text: "KDE Connect"
                    font.weight: Font.Bold
                    Layout.alignment: Qt.AlignHCenter
                }
                Controls.Label {
                    text: "Device Sync"
                    opacity: 0.7
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: Kirigami.Units.gridUnit
            spacing: Kirigami.Units.largeSpacing
            
            Controls.Label {
                text: qsTr("Curious about our products?")
                Layout.alignment: Qt.AlignVCenter
            }

            Controls.Button {
                text: qsTr("Find out more!")
                flat: true
                
                contentItem: Controls.Label {
                    text: qsTr("Find out more!")
                    color: Kirigami.Theme.linkColor
                    font.underline: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: Qt.openUrlExternally("https://kde.org/products/")
            }
        }

        // Thank you message section
        Rectangle {
            Layout.fillWidth: true
            Layout.margins: Kirigami.Units.gridUnit
            Layout.preferredHeight: thankYouColumn.implicitHeight + Kirigami.Units.gridUnit * 2
            color: Qt.rgba(Kirigami.Theme.backgroundColor.r, 
                          Kirigami.Theme.backgroundColor.g, 
                          Kirigami.Theme.backgroundColor.b, 0.8)
            radius: Kirigami.Units.smallSpacing
            border.width: 1
            border.color: Kirigami.Theme.disabledTextColor

            ColumnLayout {
                id: thankYouColumn
                anchors.centerIn: parent
                width: parent.width - Kirigami.Units.gridUnit * 4
                spacing: Kirigami.Units.largeSpacing

                Kirigami.Heading {
                    level: 3
                    text: qsTr("Thank You for Using Win2Linux!")
                    Layout.alignment: Qt.AlignHCenter
                }

                Controls.Label {
                    text: qsTr("We hope our recommendations help you find the perfect Linux distribution.\n Enjoy your journey into the world of open-source software!")
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }
            }
        }

        // Spacer
        Item {
            Layout.fillHeight: true
        }
    }
}