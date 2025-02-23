import json
import logging
import re
from typing import Dict, Any, Union

class HardwareClassifier:
    def __init__(self, hardware_data: str):
        """
        Inits the classifier with JSON string data.
        
        Args:
            hardware_data (str): JSON string with hardware information.
        """
        try:
            parsed_data: Dict[str, Any] = json.loads(hardware_data) if hardware_data else {}
            self.hardware_data: Dict[str, Any] = parsed_data if isinstance(parsed_data, dict) else {}
        except json.JSONDecodeError:
            logging.error("Invalid JSON data.")
            self.hardware_data = {}
        
        self.classification: str = "Unknown"
    
    def classify_hardware(self) -> str:
        """
        Classifies hardware as Old, Medium, or New based on CPU, RAM, and GPU performance using a weighted formula:
        S = Σ(w * s)
            S := final classification score;
            w := weight of the hardware component classification (40% for CPU, 30% for RAM and GPU each);
            s := subscore of the corresponding hardware component.
        
        Returns:
            str: The classification result ("Old", "Medium", or "New").
        """
        try:
            num_cores: int = self.hardware_data.get("Number of Cores", 0)
            ram: int = self.hardware_data.get("Total RAM", 0)
            gpu_name: str = self._extract_gpu_name()
            gpu_memory: int = self._extract_gpu_memory()
            
            # Weights
            W_CPU, W_RAM, W_GPU = 0.4, 0.3, 0.3
            
            # Subscores
            S_CPU = self._classify_cpu(num_cores)
            S_RAM = self._classify_ram(ram)
            S_GPU = self._classify_gpu(gpu_name, gpu_memory)
            
            # Final score
            S_final = (W_CPU * S_CPU) + (W_RAM * S_RAM) + (W_GPU * S_GPU)
            
            if S_final >= 2.5:
                self.classification = "New"
            elif S_final >= 1.5:
                self.classification = "Medium"
            else:
                self.classification = "Old"
            
            return self.classification

        except Exception as e:
            logging.error(f"Error classifying hardware: {e}")
            return "Unknown"
    
    def _classify_cpu(self, num_cores: int) -> int:
        """
        Assign score to the CPU based on physical core count.

        Returns:
            int: Subscore for the CPU (0 to 3).
        """
        cpu_score_map = {
            (8, float("inf")): 3,
            (4, 7): 2,
            (2, 3): 1,
            (0, 1): 0
        }

        for (low, high), score in cpu_score_map.items():
            if low <= num_cores <= high:
                return score

        return 0
    
    def _classify_ram(self, ram: int) -> int:
        """
        Assign score to RAM.

        Returns:
            int: Subscore for the RAM (0 to 3).
        """
        ram_score_map = {
            (8000, float("inf")): 3,  # High-end
            (4000, 7999): 2,          # Mid-tier, can run any distribution/DE comfortably
            (2000, 3999): 1,          # Low-end, suitable for lightweight Linux distros
            (0, 1999): 0              # Low-end, may struggle with modern DE's
        }

        for (low, high), score in ram_score_map.items():
            if low <= ram <= high:
                return score

        return 0
    
    def _classify_gpu(self, gpu_name: str, gpu_memory: int) -> int:
        """
        Assign a score to the GPU based on its performance tier.

        Considerations:
            1. Should handle multiple GPUs, integrated or discrete;
            2. Workstations with only integrated GPUs shouldn't be misclassified as "outdated hardware";
            3. May necessitate updates as new GPU models are released.
            4. VRAM alone is not a reliable performance indicator (e.g., 4GB VRAM RTX 30XX cards), so it's used only as a fallback.

        Returns:
            int: Subscore for the GPU (0 to 3).
        """

        high_performance_gpus = (
            "RTX", "Radeon RX 5", "Radeon RX 6", "Radeon RX 7", "Iris Xe", "Radeon 780M", "Radeon 680M",
            "GTX 1080", "GTX 980 Ti", "GTX 970", "Radeon R9 Fury", "Radeon R9 390X", "Quadro P5000", "FirePro W9000"
        )
        mid_tier_gpus = (
            "GTX 1060", "GTX 1050 Ti", "GTX 1650", "GTX 1660", "GTX 970", "GTX 960", "GTX 950",
            "Radeon R9 380", "Radeon R9 370", "RX 470", "RX 570", "Quadro P2000", "Radeon Pro WX"
        )
        low_end_gpus = (
            "GTX 750", "GTX 660", "GT 1030", "Radeon R7", "Radeon R5", "RX 460", "HD 7770",
            "Intel UHD", "Vega 3", "Vega 5"
        )

        if any(key in gpu_name for key in high_performance_gpus):
            return 3
        elif any(key in gpu_name for key in mid_tier_gpus):
            return 2
        elif any(key in gpu_name for key in low_end_gpus):
            return 1

        # Fallback: Classification based on VRAM
        if gpu_memory >= 6000: 
            return 3
        elif gpu_memory >= 4000: 
            return 2 
        elif gpu_memory >= 2000: 
            return 1
        return 0

    def _extract_gpu_name(self) -> str:
        """
        Extracts GPU name from hardware data.
        
        Returns:
            str: The GPU name, or "Unknown" if not found.
        """
        gpu_data: Union[Dict[str, Any], list] = self.hardware_data.get("GPU") or self.hardware_data.get("GPUs", [])

        if isinstance(gpu_data, dict):
            return gpu_data.get("GPU Name", "Unknown")
        elif isinstance(gpu_data, list) and gpu_data:
            return gpu_data[0].get("GPU Name", "Unknown")

        return "Unknown"
    
    def _extract_gpu_memory(self) -> int:
        """
        Extracts total GPU memory, and considers multiple GPUs if applicable.
        
        Returns:
            int: Total GPU memory in MB.
        """
        gpu_data: Union[Dict[str, Any], list] = self.hardware_data.get("GPU") or self.hardware_data.get("GPUs", [])

        if isinstance(gpu_data, dict):
            return gpu_data.get("GPU Memory", 0)
        elif isinstance(gpu_data, list):
            return sum(gpu.get("GPU Memory", 0) for gpu in gpu_data)

        return 0
    
    def display_classification(self) -> None:
        """
        Prints the result.
        """
        print(f"\n--- Hardware Classification: {self.classification}! ---\n")>