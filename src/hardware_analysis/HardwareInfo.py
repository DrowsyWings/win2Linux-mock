import psutil
import wmi
import json
import logging
import platform
from typing import Dict, List, Optional, Any, Union
from PySide6.QtCore import QObject, Signal, Slot

# Logging setup
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")

class HardwareInfo(QObject):
    dataUpdated = Signal(str)
    def __init__(self):
        super().__init__()
        if not self._is_windows():
            raise SystemError("This script is designed for Windows only.")

        self._wmi_client = wmi.WMI()
        self._hardware_details: Dict[str, Any] = {}

    def _is_windows(self) -> bool:
        """Checks if the current OS is Windows."""
        return platform.system().lower() == "windows"

    def _get_system_info(self) -> None:
        """Collects system details."""
        for item in self._wmi_client.Win32_ComputerSystem():
            self._hardware_details["Manufacturer"] = item.Manufacturer
            self._hardware_details["System Architecture"] = item.SystemType.lower()
            self._hardware_details["Total RAM"] = self._convert_bytes_to_mb(psutil.virtual_memory().total)

    def _get_storage_info(self) -> None:
        """Collects Storage details."""
        self._hardware_details["Storage"] = []
        for disk in self._wmi_client.Win32_DiskDrive():
            self._hardware_details["Storage"].append({
                "Model": disk.Model,
                "Size (GB)": round(int(disk.Size) / (1024**3), 2) if disk.Size else "Unknown",
                "Interface": disk.InterfaceType,
                "Type": "SSD" if "SSD" in disk.Model.upper() else "HDD"
            })
    
    def _get_ram_info(self) -> None:
        """Collects RAM details."""
        self._hardware_details["RAM Details"] = []
        for ram in self._wmi_client.Win32_PhysicalMemory():
            self._hardware_details["RAM Details"].append({
                "Capacity (GB)": round(int(ram.Capacity) / (1024**3), 2),
                "Speed (MHz)": ram.Speed,
                "Type": ram.MemoryType
            })



    def _get_cpu_info(self) -> None:
        """Collects CPU details."""
        cpu_info = psutil.cpu_freq()
        for cpu in self._wmi_client.Win32_Processor():
            self._hardware_details["CPU Name"] = cpu.Name
            self._hardware_details["Number of Cores"] = psutil.cpu_count(logical=False)
            self._hardware_details["Number of Logical Processors"] = psutil.cpu_count(logical=True)
            self._hardware_details["Clock Speed"] = f"{cpu_info.max:.2f} MHz" if cpu_info and cpu_info.max else f"{cpu.MaxClockSpeed} MHz"
            self._hardware_details["CPU Architecture"] = platform.architecture()[0]

    def _get_gpu_info(self) -> None:
        """Collects GPU details."""
        gpus = self._wmi_client.Win32_VideoController()
        if not gpus:
            self._hardware_details["GPU"] = "Not Available"
            return

        if len(gpus) == 1:
            self._hardware_details["GPU"] = {
                "GPU Name": gpus[0].Name,
                "GPU Memory": self._convert_bytes_to_mb(gpus[0].AdapterRAM)
            }
        else:
            self._hardware_details["GPUs"] = [
                {"GPU Name": gpu.Name, "GPU Memory": self._convert_bytes_to_mb(gpu.AdapterRAM)}
                for gpu in gpus
            ]

    @staticmethod
    def _convert_bytes_to_mb(size_in_bytes: Optional[int]) -> float:
        """Converts bytes to MB (2^20 bytes = 1 megabyte)."""
        return 0.0 if not size_in_bytes else round(size_in_bytes / (1024 * 1024), 2)

    @Slot(result=None)
    def collect_hardware_info(self) -> None:
        """Runs all data collection methods."""
        self._get_system_info()
        self._get_cpu_info()
        self._get_gpu_info()
        self._get_ram_info()
        self._get_storage_info()
        self.to_json()

    def display_info(self) -> None:
        """Displays hardware details."""
        if not self._hardware_details:
            logging.error("No hardware information available to display.")
            return

        print("\n*** HARDWARE INFORMATION ***\n")
        for key, value in self._hardware_details.items():
            if key in ["GPU", "GPUs"]:
                print("\nGPU(s):")
                if isinstance(value, dict):
                    print(f"  GPU: {value['GPU Name']}")
                    print(f"  Memory: {value['GPU Memory']} MB")
                elif isinstance(value, list):
                    for idx, gpu in enumerate(value, start=1):
                        print(f"  GPU {idx}: {gpu['GPU Name']}")
                        print(f"  Memory: {gpu['GPU Memory']} MB")
            elif key in ["Number of Cores", "Number of Logical Processors"]:
                print(f"{key}: {value}")
            elif key in ["Total RAM", "GPU Memory", "Clock Speed"]:
                print(f"{key}: {value} MB")
            else:
                print(f"{key}: {value}")
        print("\n****************************\n")

    @Slot(result=str)
    def to_json(self, save_to_file: bool = True, filename: str = "hardware_info.json") -> str:
        """
        Converts hardware details to JSON format.

        Args:
            save_to_file (bool): If True, saves the JSON output to a file in the working directory.
            filename (str): Name of the output file, used iff save_to_file is True.
        Returns:
            str: Hardware details in a JSON string.
        """
        if not self._hardware_details:
            logging.error("No hardware data available, JSON conversion failed.")
            return None

        json_data: str = json.dumps(self._hardware_details, indent=4, sort_keys=True)

        if save_to_file:
            try:
                with open(filename, 'w') as file:
                    file.write(json_data)
                logging.info(f"Hardware info saved as '{filename}'!")

                self.dataUpdated.emit(json_data)
            except IOError as e:
                logging.error(f"Couldn't write to file '{filename}'. Exception: {e}")

    @Slot(result=str)
    def get_json_data(self) -> str:
        """Returns hardware data as JSON string"""
        return json.dumps(self._hardware_details, indent=4) if self._hardware_details else "{}"