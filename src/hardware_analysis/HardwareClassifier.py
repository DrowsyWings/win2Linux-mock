import json
import logging
import re
from typing import Dict, Any, List
from PySide6.QtCore import QObject, Signal, Slot

class HardwareClassifier(QObject):
    hardwareClassified = Signal(list)

    def __init__(self):
        super().__init__()
        try:
            with open("hardware_info.json", "r") as file:
                self.hardware_data: Dict[str, Any] = json.load(file)
        except (json.JSONDecodeError, FileNotFoundError) as e:
            logging.error(f"Error loading hardware info: {e}")
            self.hardware_data = {}

    @Slot()
    def classify_hardware(self):
        try:
            num_cores: int = self.hardware_data.get("Number of Cores", 0)
            ram: int = self.hardware_data.get("Total RAM", 0)
            storage_score = self._classify_storage()
            gpu_name: str = self._extract_gpu_name()
            gpu_score = self._classify_gpu(gpu_name)

            hardware_vector = [
                self._classify_cpu(num_cores),
                self._classify_ram(ram),
                storage_score[0],
                storage_score[1],
                gpu_score
            ]

            self.hardwareClassified.emit(hardware_vector)
        except Exception as e:
            logging.error(f"Error classifying hardware: {e}")
            self.hardwareClassified.emit([0, 0, 0, 0, 0])

    def _classify_cpu(self, num_cores: int) -> int:
        if num_cores >= 6:
            return 5
        elif num_cores >= 4:
            return 4
        elif num_cores >= 2:
            return 2
        elif num_cores == 1:
            return 1
        return 0
    
    def _classify_ram(self, ram: int) -> int:
        if ram >= 8000:
            return 4
        elif ram >= 4000:
            return 2
        elif ram > 0:
            return 1
        return 0
    
    def _classify_storage(self) -> List[int]:
        storage_devices = self.hardware_data.get("Storage", [])

        if not storage_devices or not isinstance(storage_devices, list):
            return [0, 0]

        type_score, size_score = 0, 0
        for storage in storage_devices:
            size_gb = storage.get("Size (GB)", 0)
            storage_type = storage.get("Type", "SSD").upper()

            if "SSD" in storage_type:
                type_score = max(type_score, 1)
            else:
                type_score = max(type_score, 0)

            if size_gb >= 1000:
                size_score = max(size_score, 3)
            elif size_gb >= 500:
                size_score = max(size_score, 2)
            else:
                size_score = max(size_score, 1)

        return [type_score, size_score]
    
    def _classify_gpu(self, gpu_name: str) -> int:
        high_perf_patterns = [r"RTX\s?\d{3,}", r"RX\s?(6|7|8)\d{2,}", r"GTX\s?(9|1[0-6])\d{2,}"]
        mid_perf_patterns = [r"GTX\s?[1-8]\d{2,}", r"R5\s?\d{3,}", r"HD\s?\d{3,4}", r"Intel\s?(UHD|HD)"]

        if any(re.search(p, gpu_name, re.IGNORECASE) for p in high_perf_patterns):
            return 3
        if any(re.search(p, gpu_name, re.IGNORECASE) for p in mid_perf_patterns):
            return 2
        return 1 if gpu_name != "Unknown" else 0

    def _extract_gpu_name(self) -> str:
        gpu_data = self.hardware_data.get("GPU") or self.hardware_data.get("GPUs", [])
        if isinstance(gpu_data, dict):
            return gpu_data.get("GPU Name", "Unknown")
        elif isinstance(gpu_data, list) and gpu_data:
            return gpu_data[0].get("GPU Name", "Unknown")
        return "Unknown"
