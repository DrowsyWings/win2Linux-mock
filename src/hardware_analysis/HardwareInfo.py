import subprocess
import json
import platform
from typing import Dict, Optional

class HardwareInfo:
    def __init__(self, vbs_path: str):
        if not self.is_windows():
            raise SystemError("This script is meant for Windows. If you're seeing this, you're all good!")

        self.vbs_path: str = vbs_path
        self.hardware_details: Dict[str, str] = {}

    def is_windows(self) -> bool:
        return platform.system().lower() == "windows"

    # TODO: research if this is sufficient for Win8 or older
    def run_vbscript(self) -> Optional[str]:
        try:
            process_output = subprocess.run(
                ["cscript", "//NoLogo", self.vbs_path],
                capture_output=True,
                text=True,
                check=True
            )

            # Ensure output is not empty
            if not process_output.stdout.strip():
                print("ERROR: VBScript executed successfully but returned no data.")
                return None

            return process_output.stdout
        except FileNotFoundError:
            print(f"ERROR: VBScript file '{self.vbs_path}' not found.")
            return None
        except subprocess.CalledProcessError as e:
            print(f"ERROR: VBScript execution failed.\n{e}")
            return None

    def parse_output(self, raw_output: str) -> None:
        details: Dict[str, str] = {}

        for line in raw_output.splitlines():
            if ": " in line:
                key, value = line.split(": ", 1)
                details[key.strip()] = value.strip()

        self.hardware_details = details

    def display_info(self) -> None:
        if not self.hardware_details:
            print("ERROR: No hardware information to display.")
            return

        print("\n*** HARDWARE INFORMATION ***\n")
        for category, detail in self.hardware_details.items():
            print(f"{category}: {detail}")
        print("\n****************************\n")

    def to_json(self, save_to_file: bool = False, filename: str = "hardware_info.json") -> Optional[str]:
        if not self.hardware_details:
            print("ERROR: No hardware data available, JSON conversion failed.")
            return None

        json_data: str = json.dumps(self.hardware_details, indent=4)

        if save_to_file:
            try:
                with open(filename, "w") as file:
                    file.write(json_data)
                print(f"Hardware info saved as '{filename}'!")
            except IOError as e:
                print(f"ERROR: Unable to write to file '{filename}'.\n{e}")
                return None

        return json_data

    def fetch_and_display(self) -> None:
        raw_output: Optional[str] = self.run_vbscript()
        if raw_output:
            self.parse_output(raw_output)
            self.display_info()

if __name__ == "__main__":
    vbs_path: str = "hw_collection.vbs"

    try:
        hardware_info = HardwareInfo(vbs_path)
        hardware_info.fetch_and_display()

        # Uncomment to allow for JSON formatted output
        # json_output = hardware_info.to_json(save_to_file=True)
        # if json_output:
        #     print("\nJSON Data:\n", json_output)

    except Exception as e:
        print(f"ERROR: {e}")

