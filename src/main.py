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

def resource_path(relative_path):
    if hasattr(sys, '_MEIPASS'):
        return os.path.join(sys._MEIPASS, relative_path)
    return os.path.join(os.path.abspath("."), relative_path)

def main():
    app = QApplication(sys.argv)
    
    signal.signal(signal.SIGINT, signal.SIG_DFL)
    
    if not os.environ.get("QT_QUICK_CONTROLS_STYLE"):
        os.environ["QT_QUICK_CONTROLS_STYLE"] = "org.kde.desktop"
    
    base_path = os.path.dirname(os.path.abspath(__file__))
    
    if hasattr(sys, '_MEIPASS'):
        print("Running in PyInstaller bundle")
        qml_path = os.path.join(sys._MEIPASS, "qml")
        plugin_path = os.path.join(sys._MEIPASS, "plugins")
        
        app.addLibraryPath(sys._MEIPASS)
        if os.path.exists(plugin_path):
            app.addLibraryPath(plugin_path)
            print(f"Added plugin path: {plugin_path}")
        
        os.environ['QML_IMPORT_PATH'] = qml_path
        os.environ['QML2_IMPORT_PATH'] = qml_path
        print(f"Set QML import paths: {qml_path}")
        
        engine = QQmlApplicationEngine()
        engine.addImportPath(qml_path)
    else:
        print("Running in development environment")
        engine = QQmlApplicationEngine()
        engine.addImportPath(os.path.join(base_path, "qml"))
    
    import_paths = engine.importPathList()
    print("QML import paths:")
    for path in import_paths:
        print(f"  {path}")
    
    url = QUrl.fromLocalFile(resource_path("qml/main.qml"))
    print(f"Loading QML from: {url.toLocalFile()}")
    engine.load(url)

    questionnaire_model = QuestionnaireModel()
    recommender_model = Recommender()
    hardware_info = HardwareInfo()
    hardware_classifier = HardwareClassifier()

    engine.rootContext().setContextProperty("questionnaireModel", questionnaire_model)
    engine.rootContext().setContextProperty("recommenderModel", recommender_model)
    engine.rootContext().setContextProperty("hardwareInfo", hardware_info)
    engine.rootContext().setContextProperty("hardwareClassifier", hardware_classifier)
    
    if len(engine.rootObjects()) == 0:
        print("Failed to load QML application!")
        sys.exit(-1)

    return app.exec()

if __name__ == "__main__":
    sys.exit(main())