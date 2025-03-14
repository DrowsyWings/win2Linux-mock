import json
from pathlib import Path
from PySide6.QtCore import QObject, Property, Signal, Slot

class QuestionnaireModel(QObject):
    questionsChanged = Signal()
    currentIndexChanged = Signal()
    responsesChanged = Signal()

    def __init__(self):
        super().__init__()
        self._questions = []
        self._currentIndex = 0
        self._responses = {}
        self.load_questions()
        self.load_responses()

    def load_questions(self):
        json_path = Path(__file__).parent / "questionnaire.json"
        with open(json_path, 'r') as f:
            data = json.load(f)
            self._questions = data["questions"]

    def load_responses(self):
        response_path = Path(__file__).parent / "responses.json"
        if response_path.exists():
            with open(response_path, 'r') as f:
                self._responses = json.load(f)

    def save_responses(self):
        response_path = Path(__file__).parent / "responses.json"
        with open(response_path, 'w') as f:
            json.dump(self._responses, f, indent=4)

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

    @Property(dict, notify=responsesChanged)
    def responses(self):
        return self._responses

    @Slot(int, str)
    def setResponse(self, index, option_id):
        if 0 <= index < len(self._questions):
            question_id = str(self._questions[index]["id"])
            self._responses[question_id] = option_id 
            self.responsesChanged.emit()
            self.save_responses()

    @Slot(int)
    def setCurrentIndex(self, index):
        self.currentIndex = index