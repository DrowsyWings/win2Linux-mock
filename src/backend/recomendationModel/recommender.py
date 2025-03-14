import json
from pathlib import Path
import numpy as np
from PySide6.QtCore import QObject, Signal, Slot

class Recommender(QObject):
    rankingsChanged = Signal(list)

    def __init__(self):
        super().__init__()
        self.responses = self.load_response()
        self.distro_vectors = self.load_distro_vectors()
        self.user_vector = self.load_user_vector()
        self.user_binary_preferences = self.load_binary_preferences()
        self.rankings = []

    def load_response(self):
        response_path = Path(__file__).parent.parent / "questionnaire" / "responses.json"
        if response_path.exists():
            with open(response_path, "r") as f:
                return json.load(f)
        return {}

    def load_user_vector(self):
        marking_path = Path(__file__).parent / "marking.json"
        if not marking_path.exists():
            return []
        
        with open(marking_path, "r") as f:
            marking_data = json.load(f)
        
        user_vector = []
        for question in marking_data["user_vector"]["questions"]:
            question_id = str(question["question_id"])
            if question_id in self.responses:
                option_id = self.responses[question_id]
                score = question["option_id_to_score"].get(option_id, 0)
                user_vector.append(score)
        
        return user_vector
    
    def load_binary_preferences(self):
        marking_path = Path(__file__).parent / "marking.json"
        if not marking_path.exists():
            return {}

        with open(marking_path, "r") as f:
            marking_data = json.load(f)

        binary_preferences = {}
        binary_params = {"updates", "UI_Look"}

        for question in marking_data["user_vector"]["questions"]:
            question_id = str(question["question_id"])
            param_name = question.get("parameter_name")

            if param_name in binary_params and question_id in self.responses:
                option_id = self.responses[question_id]
                score = question["option_id_to_score"].get(option_id, 0)
                binary_preferences[param_name] = score

        return binary_preferences

    def load_distro_vectors(self):
        distro_vector_path = Path(__file__).parent.parent / "distro.json"

        if distro_vector_path.exists():
            with open(distro_vector_path, "r") as f:
                data = json.load(f)
                
                distro_vectors = {
                    distro_name: {
                        "scores": list(distro_info["scores"].values()),
                        "raw_scores": distro_info["scores"] 
                    }
                    for distro_name, distro_info in data["distributions"].items()
                }
    
                return distro_vectors

        return {}

    @Slot()
    def calculate_rankings(self):
        self.responses = self.load_response()
        self.user_vector = self.load_user_vector()
        self.user_binary_preferences = self.load_binary_preferences()
        
        raw_rankings = self.recommend()
        self.rankings = [{"distro": str(name), "score": float(score)} for name, score in raw_rankings]
        self.rankingsChanged.emit(self.rankings)

    @Slot(result="QVariantList")
    def get_rankings(self):
        return self.rankings
    
    def recommend(self, penalty_factor=0.5):
        if not self.user_vector or not self.distro_vectors:
            return []  # Return an empty list instead of a string

        scores = {}
        user_vector_np = np.array(self.user_vector)
        binary_params = {"updates", "UI_Look"}

        for distro, data in self.distro_vectors.items():
            distro_vector_np = np.array(data["scores"])
            final_score = np.dot(user_vector_np, distro_vector_np)

            for param in binary_params:
                if param in self.user_binary_preferences and param in data["raw_scores"]:
                    if self.user_binary_preferences[param] != data["raw_scores"][param]:
                        final_score *= penalty_factor

            scores[distro] = final_score

        return sorted(scores.items(), key=lambda x: x[1], reverse=True)
