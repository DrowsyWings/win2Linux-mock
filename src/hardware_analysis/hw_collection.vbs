Set obj_wmi_service = GetObject("winmgmts:\\.\root\cimv2")

' ***********************************
' Manufacturer & System Details & RAM
' ***********************************
Set col_sys = obj_wmi_service.ExecQuery("Select * from Win32_ComputerSystem")
For Each item In col_sys
    WScript.Echo "Manufacturer: " & item.Manufacturer
    WScript.Echo "System Architecture: " & LCase(item.SystemType)
    WScript.Echo "Total RAM: " & FormatMemory(item.TotalPhysicalMemory)
Next

' ***********************************
' CPU Information
' ***********************************
Set col_cpu = obj_wmi_service.ExecQuery("Select * from Win32_Processor")
For Each item In col_cpu
    WScript.Echo "CPU Name: " & item.Name
    WScript.Echo "Number of Cores: " & item.NumberOfCores
    WScript.Echo "Number of Logical Processors: " & item.NumberOfLogicalProcessors
    WScript.Echo "Clock Speed: " & item.MaxClockSpeed & " MHz"
    WScript.Echo "CPU Architecture: " & GetArchName(item.Architecture)
Next

' ***********************************
' GPU Information
' ***********************************
Set col_gpu = obj_wmi_service.ExecQuery("Select * from Win32_VideoController")
For Each item In col_gpu
    WScript.Echo "GPU Name: " & item.Name
    WScript.Echo "GPU Memory: " & FormatMemory(item.AdapterRAM)
Next

' ***********************************
' Helpers
' ***********************************
Function GetArchName(arch)
    Select Case arch
        ' Map identifiers to their corrsp. CPU architecture
        ' Reference: https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-processor
        Case 0 GetArchName = "x86"
        Case 1 GetArchName = "MIPS"
        Case 2 GetArchName = "Alpha"
        Case 3 GetArchName = "PowerPC"
        Case 6 GetArchName = "Itanium"
        Case 9 GetArchName = "x64"
        Case 5 GetArchName = "ARM"
        Case Else GetArchName = "Unknown"
    End Select
End Function

Function FormatMemory(mem)
    If IsNull(mem) Or mem = "" Then
        FormatMemory = "Not Available"
    Else
        Const BYTE_TO_MB = 1048576  ' 2^20 bytes = 1 MB
        Const MEMORY_UNIT = "MB"
        FormatMemory = Round(CDbl(mem) / BYTE_TO_MB, 2) & " " & MEMORY_UNIT
    End If
End Function
