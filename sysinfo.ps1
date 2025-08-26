param (
    [switch]$verbose,
    [switch]$cpu,
    [switch]$gpu
)

$os = Get-CimInstance Win32_OperatingSystem # used in Get-OsInfo and Get-MemInfo
function Get-OsInfo {
    Write-Host "`nOS: $($os.Caption) $($os.Version) ($($os.OSArchitecture))"
    Write-Host "User: $($os.CSName)"
    Write-Host "Sys Clock: $($os.LocalDateTime)"
    Write-Host "Last Boot Time: $($os.LastBootUpTime)"
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
    Write-Host "`nTotal Memory: $memGb GB" -ForegroundColor Yellow
    Write-Host "Available Memory: $freeMem GB" -ForegroundColor Green
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
if ($cpu) {
    Get-CpuInfo
}
elseif ($gpu) {
    Get-GpuInfo
} else {
    Get-OsInfo
    Get-CpuInfo
    Get-MemInfo
    if ($verbose) {
        Get-GpuInfo
        Get-DriveInfo 
    }
}