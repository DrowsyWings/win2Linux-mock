import sys
import signal
import os
from PySide6.QtWidgets import QApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QUrl
from backend.questionnaire.questionnaire import QuestionnaireModel
from backend.recomendationModel.recommender import Recommender
from hardware_analysis.HardwareInfo import HardwareInfo
from hardware_analysis.HardwareClassifier import HardwareClassifier

def main():
    app = QApplication(sys.argv)
    engine = QQmlApplicationEngine()

    signal.signal(signal.SIGINT, signal.SIG_DFL)

    if not os.environ.get("QT_QUICK_CONTROLS_STYLE"):
        os.environ["QT_QUICK_CONTROLS_STYLE"] = "org.kde.desktop"

    base_path = os.path.dirname(os.path.abspath(__file__))
    url = QUrl.fromLocalFile(os.path.join(base_path, "qml", "main.qml"))
    engine.load(url)


    questionnaire_model = QuestionnaireModel()
    recommender_model = Recommender()
    hardware_info = HardwareInfo()
    hardware_classifier = HardwareClassifier()

    engine.rootContext().setContextProperty("questionnaireModel", questionnaire_model)
    engine.rootContext().setContextProperty("recommenderModel", recommender_model)
    engine.rootContext().setContextProperty("hardwareInfo",hardware_info)
    engine.rootContext().setContextProperty("hardwareClassifier",hardware_classifier)
    

    if len(engine.rootObjects()) == 0:
        quit()

    app.exec()

if __name__ == "__main__":
    main()