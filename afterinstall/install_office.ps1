### MS Office install ###

$SoftPath = 'w:\soft\'
$InstallPath = 'D:\install\'

Write-Verbose -Message "Installing Office 2016" -Verbose

$ImagePath = $SoftPath + 'ms_office\Office2016.img'
$DriveLetter = 'O:'
$diskImg = Mount-DiskImage -ImagePath $ImagePath -NoDriveLetter
$volInfo = $diskImg | Get-Volume
mountvol $driveLetter $volInfo.UniqueId
if (-not (Test-Path -Path $InstallPath))
			{
				New-Item -ItemType Directory $InstallPath -Force
			}
Copy-Item $SoftPath'ms_office\Office2016_basic.ini' -destination $InstallPath'C2R_Config.ini'
Copy-Item $SoftPath'ms_office\installer.cmd' -destination $InstallPath'installer.cmd'
Start-Process $InstallPath'installer.cmd' -Wait
Dismount-DiskImage -ImagePath $ImagePath

Write-Verbose -Message 'OK' -Verbose