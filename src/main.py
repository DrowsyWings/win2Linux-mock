import sys
import signal
import os
from PySide6.QtWidgets import QApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QUrl
from backend.questionnaire.questionnaire import QuestionnaireModel

def main():

    app = QApplication(sys.argv)
    engine = QQmlApplicationEngine()

    signal.signal(signal.SIGINT, signal.SIG_DFL)

    if not os.environ.get("QT_QUICK_CONTROLS_STYLE"):
       os.environ["QT_QUICK_CONTROLS_STYLE"] = "org.kde.desktop"

    base_path = os.path.abspath(os.path.dirname(__file__))
    url = QUrl(f"file://{base_path}/qml/main.qml")
    engine.load(url)

    questionnaire_model = QuestionnaireModel()
    engine.rootContext().setContextProperty("questionnaireModel", questionnaire_model)

    if len(engine.rootObjects()) == 0:
        quit()

    app.exec()

if __name__ == "__main__":
    main()