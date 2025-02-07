import QtQuick
import org.kde.kirigami as Kirigami

Kirigami.ApplicationWindow {
    id: root

    title: qsTr("Win2Linux:Chooser")

    minimumWidth: Kirigami.Units.gridUnit * 30
    minimumHeight: Kirigami.Units.gridUnit * 25
    width: minimumWidth * 1.5
    height: minimumHeight * 1.5

    pageStack.initialPage: Qt.createComponent("pages/welcomePage.qml")
}
