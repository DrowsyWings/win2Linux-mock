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
            spacing: Kirigami.Units.smallSpacing

            Controls.Label {
                text: qsTr("Curious about our products?")
            }

            Controls.Button {
                contentItem: Controls.Label {
                    text: qsTr("Find out more!")
                    color: Kirigami.Theme.linkColor
                    font.underline: true
                }
                onClicked: Qt.openUrlExternally("https://kde.org/products/")
            }
        }

        Controls.Button {
            text: qsTr("Go Back")
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: Kirigami.Units.gridUnit * 8
            flat: true

            background: Rectangle {
                color: "#96F948"
                radius: height / 4
            }

            onClicked: {
                pageStack.pop()
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
