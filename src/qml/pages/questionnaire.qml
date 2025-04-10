import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Kirigami.Page {
    function allQuestionsAnswered() {
    return questionnaireModel.currentIndex === questionnaireModel.questions.length - 1
}
    id: questionnairePage
    title: qsTr("Question " + (questionnaireModel.currentIndex + 1) + "/" + questionnaireModel.questions.length)
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

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Kirigami.Units.gridUnit * 20
            
            ColumnLayout {
                anchors.fill: parent
                spacing: Kirigami.Units.gridUnit

                Kirigami.Heading {
                    text: qsTr("Question " + (questionnaireModel.currentIndex + 1) + "/" + questionnaireModel.questions.length)
                    level: 2
                    Layout.alignment: Qt.AlignLeading
                }

                Controls.Label {
                    text: questionnaireModel.questions[questionnaireModel.currentIndex].description
                    font.pixelSize: Kirigami.Theme.defaultFont.pixelSize * 1.1
                    Layout.fillWidth: true
                    wrapMode: Text.Wrap 
                    elide: Text.ElideNone
                    Layout.alignment: Qt.AlignLeading
                }

                Kirigami.ScrollablePage {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true

                    ColumnLayout {
                        width: parent.width
                        spacing: Kirigami.Units.smallSpacing

                        Repeater {
                            model: Object.keys(questionnaireModel.questions[questionnaireModel.currentIndex].options)
                            delegate: Controls.RadioButton {
                                text:  questionnaireModel.questions[questionnaireModel.currentIndex].options[modelData]
                                Controls.ButtonGroup.group: optionsGroup
                                Layout.fillWidth: true
                                KeyNavigation.tab: index === model.length - 1 ? prevButton : null
                                checked: questionnaireModel.responses[String(questionnaireModel.questions[questionnaireModel.currentIndex].id)] === modelData
                                focus: index === 0

                                onClicked: {
                                    questionnaireModel.setResponse(questionnaireModel.currentIndex,modelData)
                                }
                            }
                        }
                    }
                }
            }
        }

        Controls.ButtonGroup {
            id: optionsGroup
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: Kirigami.Units.gridUnit * -5
            spacing: Kirigami.Units.gridUnit * 2

            // Previous Button
            Controls.Button {
                id: prevButton
                enabled: questionnaireModel.currentIndex > 0
                Layout.preferredWidth: Kirigami.Units.gridUnit * 7
                Layout.preferredHeight: Kirigami.Units.gridUnit * 3
                Layout.alignment: Qt.AlignVCenter
                focus: true
                
                Keys.onReturnPressed: clicked()
                Keys.onEnterPressed: clicked()
                KeyNavigation.tab: indicatorGrid

                background: Rectangle {
                    color: parent.enabled ? (parent.hovered || parent.activeFocus ? "#8CE743" : "#96F948") : "#CCCCCC"
                    radius: height / 4
                }

                contentItem: Controls.Label {
                    text: qsTr("Previous")
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "#000000"
                }

                onClicked: if (questionnaireModel.currentIndex > 0) {
                    questionnaireModel.setCurrentIndex(questionnaireModel.currentIndex - 1)
                }
            }

            // Question Numbers in Grid Layout
            Grid {
                id: indicatorGrid
                Layout.alignment: Qt.AlignVCenter
                columns: questionnaireModel.questions.length / 2 
                spacing: Kirigami.Units.smallSpacing
                Layout.preferredHeight: Kirigami.Units.gridUnit * 5
                KeyNavigation.tab: nextButton

                Repeater {
                    model: questionnaireModel.questions.length
                    delegate: Rectangle {
                        width: Kirigami.Units.gridUnit * 2
                        height: Kirigami.Units.gridUnit * 2
                        color: index === questionnaireModel.currentIndex ? "#96F948" : 
                               index < questionnaireModel.currentIndex ? "#8CE743" : Kirigami.Theme.disabledTextColor
                        radius: width / 4

                        Controls.Label {
                            anchors.centerIn: parent
                            text: (index + 1)
                            color: "#000000"
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: questionnaireModel.setCurrentIndex(index)
                        }
                    }
                }
            }

            // Next Button
            Controls.Button {
                id: nextButton
                enabled: questionnaireModel.currentIndex < questionnaireModel.questions.length - 1 || allQuestionsAnswered()
                Layout.preferredWidth: Kirigami.Units.gridUnit * 7
                Layout.preferredHeight: Kirigami.Units.gridUnit * 3
                Layout.alignment: Qt.AlignVCenter
                focus: true
                
                Keys.onReturnPressed: clicked()
                Keys.onEnterPressed: clicked()
                KeyNavigation.tab: backButton

                background: Rectangle {
                    color: parent.enabled ? (parent.hovered || parent.activeFocus ? "#8CE743" : "#96F948") : "#CCCCCC"
                    radius: height / 4
                }

                contentItem: Controls.Label {
                    text: qsTr("Next")
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "#000000"
                }

                onClicked: {
                    if (allQuestionsAnswered()) {
                        // Navigate to the Result Page
                        var resultPage = Qt.resolvedUrl("HardwareInfo.qml")
                        
                        if (resultPage) {
                            pageStack.pop()
                            pageStack.push(resultPage)
                        } else {
                            console.error("Failed to resolve ResultPage.qml")
                        }
                    } else {
                        questionnaireModel.setCurrentIndex(questionnaireModel.currentIndex + 1)
                    }
                }
            }
        }


        // Back to main menu Button
        Controls.Button {
            id: backButton
            Layout.alignment: Qt.AlignHCenter
            flat: true
            Layout.topMargin: Kirigami.Units.gridUnit
            focus: true

            contentItem: Controls.Label {
                text: qsTr("Back to Main Menu")
                color: Kirigami.Theme.linkColor
                horizontalAlignment: Text.AlignHCenter
                font.underline: true
            }

            onClicked: {
                var url = Qt.resolvedUrl("welcomePage.qml")
                if (url) {
                    pageStack.pop()
                    pageStack.push(url)
                } else {
                    console.error("Failed to resolve URL")
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }
}