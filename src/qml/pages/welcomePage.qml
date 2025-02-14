import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Kirigami.Page {
    id: welcomePage
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
                Layout.preferredWidth: Kirigami.Units.gridUnit * 5
                Layout.preferredHeight: Kirigami.Units.gridUnit * 5
            }

            ColumnLayout {  
                spacing: Kirigami.Units.smallSpacing
                Layout.alignment: Qt.AlignVCenter

                Kirigami.Heading {
                    text: "Win2Linux"
                    level: 1
                    font.family: "Noto Sans"
                    font.weight: Font.Bold
                    font.pixelSize: Kirigami.Theme.defaultFont.pixelSize * 2
                }

                Controls.Label {
                    text: qsTr("Windows to Linux Transition Helper")
                    font.family: "Noto Sans"
                    opacity: 0.6  
                    font.pixelSize: Kirigami.Theme.defaultFont.pixelSize * 1.1
                }
            }
        }
    ColumnLayout{
        Layout.alignment: Qt.AlignHCenter
        Layout.topMargin: Kirigami.Units.gridUnit
        spacing: Kirigami.Units.gridUnit
        Controls.Label {
            text: qsTr("Let's personalize your Linux experience!")
            font.family: "Noto Sans"
            font.pixelSize: Kirigami.Theme.defaultFont.pixelSize * 1
            Layout.alignment: Qt.AlignLeading
            Layout.topMargin: Kirigami.Units.gridUnit * 0.5
            Layout.bottomMargin: Kirigami.Units.gridUnit * 0.5
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: Kirigami.Units.gridUnit
            spacing: Kirigami.Units.gridUnit

            Controls.Label {
                text: qsTr("We will help you with:")
                font.family: "Noto Sans"
                Layout.alignment: Qt.AlignLeading
            }

            Repeater {
                model: [
                    "Finding the right Linux distribution",
                    "Identifying alternatives to Windows software",
                    "Getting started with installation"
                ]

                delegate: RowLayout {
                    Layout.alignment: Qt.AlignLeading
                    spacing: Kirigami.Units.smallSpacing

                    Kirigami.Icon {
                        source: "checkmark"
                        Layout.preferredWidth: Kirigami.Units.iconSizes.small
                        Layout.preferredHeight: Kirigami.Units.iconSizes.small
                        color: Kirigami.Theme.positiveTextColor
                    }

                    Controls.Label {
                        text: modelData
                        font.family: "Noto Sans"
                    }
                }
            }
        }
    }
        ColumnLayout{
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: Kirigami.Units.gridUnit
            spacing: Kirigami.Units.gridUnit
            
            Controls.Button {
                text: qsTr("Take the test!")
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: Kirigami.Units.gridUnit * 15
                Layout.preferredHeight: Kirigami.Units.gridUnit * 3
                Layout.topMargin: Kirigami.Units.gridUnit
            
                background: Rectangle {
                color: parent.hovered ? "#8CE743" : "#96F948"
                radius: height / 4
            }

            contentItem: Controls.Label {
                text: parent.text
                font.family: "Noto Sans"
                font.pixelSize: Kirigami.Theme.defaultFont.pixelSize * 1
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "#000000"
            }
            onClicked: {

            }
        }

            Controls.Button {
                Layout.alignment: Qt.AlignHCenter
                flat: true
                Layout.topMargin: Kirigami.Units.gridUnit * -0.5
            
            
            contentItem: Controls.Label {
                text: qsTr("New here? Find out more about us!")
                font.family: "Source Sans Pro"
                color: Kirigami.Theme.linkColor
                horizontalAlignment: Text.AlignHCenter
                font.underline: true
            }
            onClicked: {

            }
       }
    }
        Item {
            Layout.fillHeight: true
        }
    }
}