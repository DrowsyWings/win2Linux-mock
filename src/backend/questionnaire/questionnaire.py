import json
from pathlib import Path
from PySide6.QtCore import QObject, Property, Signal, Slot

class QuestionnaireModel(QObject):
    questionsChanged = Signal()
    currentIndexChanged = Signal()

    def __init__(self):
        super().__init__()
        self._questions = []
        self._currentIndex = 0
        self.load_questions()

    def load_questions(self):
        json_path = Path(__file__).parent / "questionnaire.json"
        with open(json_path, 'r') as f:
            data = json.load(f)
            self._questions = data["questions"]

    @Property(list, notify=questionsChanged)
    def questions(self):
        return self._questions

    @Property(int, notify=currentIndexChanged)
    def currentIndex(self):
        return self._currentIndex

    @currentIndex.setter
    def currentIndex(self, value):
        if 0 <= value < len(self._questions):
            self._currentIndex = value
            self.currentIndexChanged.emit()

    @Slot(int)
    def setCurrentIndex(self, index):
        self.currentIndex = index