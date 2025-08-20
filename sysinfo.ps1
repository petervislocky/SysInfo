param (
    [switch]$verbose
)

function Get-OsInfo {
    $os = Get-CimInstance Win32_OperatingSystem
    Write-Host "`nOS: $($os.Caption) $($os.Version)"
    Write-Host "User: $($os.CSName)"
}

function Get-CpuInfo {
    $cpu = Get-CimInstance Win32_Processor
    Write-Host "`nCPU: $($cpu.Name)"
    Write-Host "Cores/Threads: $($cpu.NumberOfCores) / $($cpu.ThreadCount)"
    Write-Host "L2 Cache $($cpu.L2CacheSize) KB L3 Cache $($cpu.L3CacheSize) KB"
    Write-Host "CPU Load: $($cpu.LoadPercentage)%"
    Write-Host "Clock Speed: $($cpu.CurrentClockSpeed) mhz Max Boost: $($cpu.MaxClockSpeed) mhz"
    Write-Host "Current Voltage: $($cpu.CurrentVoltage)"
}

function Get-MemInfo {
    $memGb = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
    $freeMem = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
    Write-Host "`nTotal Memory: $($memGb) GB"
    Write-Host "Available Memory: $($freeMem) GB"
}

function Get-GpuInfo {
    $gpu = Get-CimInstance Win32_VideoController
    Write-Host "`nGPU: $($gpu.Name)"
    Write-Host "Driver Version: $($gpu.DriverVersion)"
    Write-Host "Driver Date: $($gpu.DriverDate)"
}

function Get-DriveInfo {
    $drives = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"
    Write-Host "`nDrives:"
    foreach ($disk in $drives) {
        $free = [math]::Round($disk.FreeSpace / 1GB, 2)
        $size = [math]::Round($disk.Size / 1GB, 2)
        Write-Host " $($disk.DeviceID): $free GB free / $size GB total"
    }
}

# Main
Write-Host "==========System Info==========" -ForegroundColor Blue
Get-OsInfo
Get-CpuInfo
Get-MemInfo
if ($verbose) {
    Get-GpuInfo
    Get-DriveInfo 
}