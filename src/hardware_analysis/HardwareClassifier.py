import json
import logging
import re
import os
from typing import Dict, Any, List
from PySide6.QtCore import QObject, Signal, Slot

class HardwareClassifier(QObject):
    hardwareClassified = Signal(list)

    def __init__(self):
        super().__init__()
        self.hardware_data: Dict[str, Any] = {}  # Initialize empty, load when needed

    def _load_hardware_data(self):
        """Loads hardware data from hardware_info.json if it exists."""
        if os.path.exists("hardware_info.json"):
            try:
                with open("hardware_info.json", "r") as file:
                    self.hardware_data = json.load(file)
                    logging.info("Hardware data successfully loaded.")
            except (json.JSONDecodeError, FileNotFoundError) as e:
                logging.error(f"Error loading hardware info: {e}")
                self.hardware_data = {}
        else:
            logging.warning("hardware_info.json not found. Waiting for data.")

    @Slot()
    def classify_hardware(self):
        """Loads hardware data and classifies it."""
        self._load_hardware_data()  # Ensure data is loaded before classification

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
            storage_type = storage.get("Type", "").upper()
            interface = storage.get("Interface", "").upper()

            if "SSD" in storage_type or "NVME" in interface:
                type_score = max(type_score, 1)
            else:
                type_score = max(type_score, 0) 

            # Size classification
            if size_gb >= 1000:
                size_score = max(size_score, 3)
            elif size_gb >= 500:
                size_score = max(size_score, 2)
            elif size_gb > 0:
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
