Set obj_wmi_service = GetObject("winmgmts:\\.\root\cimv2")

Const BYTE_TO_MB = 1048576  ' 2^20 bytes = 1 MB
Const MEMORY_UNIT = "MB"

' Manufacturer & System Architecture
Set col_sys = obj_wmi_service.ExecQuery("Select * from Win32_ComputerSystem")
For Each obj_item In col_sys
    WScript.Echo "Manufacturer: " & obj_item.Manufacturer
    WScript.Echo "System Architecture: " & obj_item.SystemType
Next

' CPU details
Set col_cpu = obj_wmi_service.ExecQuery("Select * from Win32_Processor")
For Each obj_item In col_cpu
    WScript.Echo "CPU Name: " & obj_item.Name
    WScript.Echo "Number of Cores: " & obj_item.NumberOfCores
    WScript.Echo "Number of Logical Processors: " & obj_item.NumberOfLogicalProcessors
    WScript.Echo "Clock Speed: " & obj_item.MaxClockSpeed & " MHz"
    WScript.Echo "CPU Architecture: " & obj_item.Architecture
Next

' RAM
Set col_ram = obj_wmi_service.ExecQuery("Select * from Win32_ComputerSystem")
For Each obj_item In col_ram
    WScript.Echo "Total RAM: " & Round(obj_item.TotalPhysicalMemory / BYTE_TO_MB, 2) & " " & MEMORY_UNIT
Next

' GPU details
Set col_gpu = obj_wmi_service.ExecQuery("Select * from Win32_VideoController")
For Each obj_item In col_gpu
    WScript.Echo "GPU Name: " & obj_item.Name
    ' VRAM
    WScript.Echo "GPU Memory: " & Round(obj_item.AdapterRAM / BYTE_TO_MB, 2) & " " & MEMORY_UNIT
Next
