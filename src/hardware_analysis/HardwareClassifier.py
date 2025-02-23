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

        import re

        # Static declaration
        if not hasattr(classify_gpu, "high_performance_patterns"):
            classify_gpu.high_performance_patterns = [
                r"RTX\s?\d{3,}",        # RTX series
                r"RX\s?(6|7|8)\d{2,}",  # RX 7xxx and 6xxx, also 8xxx as it's due soon (?)
                r"Arc\s?(A7|B5)\d{2,}"  # Arc A700/B500
            ]

            classify_gpu.mid_tier_patterns = [
                r"GTX\s?(9|1[0-6])\d{2,}",  # GTX 9xx - 16xx
                r"RX\s?(4|5)\d{2,}",        # RX 4xxx and 5xxx
                r"R(9|7)\s?\d{3,}",         # Radeon R9 and R7 series
                r"Arc\s?A5\d{2,}"           # Arc A500
            ]

            classify_gpu.low_end_patterns = [
                r"GTX\s?[1-8]\d{2,}",   # GTX 1xx-8xx
                r"R5\s?\d{3,}",         # R5 series
                r"HD\s?\d{3,4}",        # Radeon HD series
                r"Intel\s?(UHD|HD)",    # Intel UHD/HD Graphics
                r"Vega\s?\d{1,2}"       # AMD Vega integrated GPUs
            ]

        gpu_name = gpu_name.strip()

        if any(re.search(p, gpu_name, re.IGNORECASE) for p in classify_gpu.high_performance_patterns):
            return 3
        if any(re.search(p, gpu_name, re.IGNORECASE) for p in classify_gpu.mid_tier_patterns):
            return 2
        if any(re.search(p, gpu_name, re.IGNORECASE) for p in classify_gpu.low_end_patterns):
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