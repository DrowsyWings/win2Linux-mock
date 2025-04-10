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
        print(user_vector)
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
                        "raw_scores": distro_info["scores"],
                        "hardware_scores": list(distro_info["hardware_scores"].values())
                    }
                    for distro_name, distro_info in data["distributions"].items()
                }
                return distro_vectors

        return {}

    @Slot()
    def calculate_rankings(self, hardware_vector=None):
        self.responses = self.load_response()
        self.user_vector = self.load_user_vector()
        self.user_binary_preferences = self.load_binary_preferences()

        if hardware_vector:
            self.user_vector.extend(hardware_vector)
            self.distro_vectors = self.extend_distro_vectors_with_hardware_scores(hardware_vector)

        raw_rankings = self.recommend(hardware_vector=hardware_vector)
        self.rankings = [{"distro": str(name), "score": float(score)} for name, score in raw_rankings]
        self.rankingsChanged.emit(self.rankings)

    @Slot(result="QVariantList")
    def get_rankings(self):
        return self.rankings
    
    def extend_distro_vectors_with_hardware_scores(self):
        extended_distro_vectors = {}
        for distro, data in self.distro_vectors.items():
            extended_distro_vectors[distro] = {
                "scores": data["scores"] + data["hardware_scores"],
                "raw_scores": data["raw_scores"] + data["hardware_scores"],
            }
        return extended_distro_vectors
    
    def apply_hardware_penalty(self, hardware_vector, penalty_factor=0.5):
        penalty = np.array([1.0] * len(hardware_vector))
        for i, value in enumerate(hardware_vector):
            if i in [0, 1, 3]:
                if value < 2:
                    penalty[i] = penalty_factor
            elif i in [2, 4]:
                if value != 1:
                    penalty[i] = penalty_factor
        return penalty

    def recommend(self, penalty_factor=0.5, hardware_vector=None):
        if not self.user_vector or not self.distro_vectors:
            return []
        scores = {}
        user_vector_np = np.array(self.user_vector)
        binary_params = {"updates", "UI_Look"}

        if hardware_vector:
            hardware_vector_np = np.array(hardware_vector)
            hardware_penalty = self.apply_hardware_penalty(hardware_vector)

        for distro, data in self.distro_vectors.items():
            distro_vector_np = np.array(data["scores"])
            final_score = np.dot(user_vector_np, distro_vector_np)

            for param in binary_params:
                if param in self.user_binary_preferences and param in data["raw_scores"]:
                    if self.user_binary_preferences[param] != data["raw_scores"][param]:
                        final_score *= penalty_factor

            if hardware_vector:
                final_score += np.dot(hardware_vector_np * hardware_penalty, data["hardware_scores"])

            scores[distro] = final_score

        return sorted(scores.items(), key=lambda x: x[1], reverse=True)
