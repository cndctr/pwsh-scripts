### Activate Windows and MS Office ###

$SoftPath = 'W:\soft\'
$InstallPath = 'd:\install\'

$unrar = $SoftPath + '_utils\7z\7z.exe'
$unrarArgs = ' -p2021 x ' + $SoftPath + 'ms_windows\kms.7z -o' + $InstallPath 

Write-Verbose -Message 'Activating OS and Office' -Verbose
if (-not (Test-Path -Path $InstallPath))
			{
				New-Item -ItemType Directory $InstallPath -Force
			}
Set-Location $InstallPath
if (-not (Test-Path $InstallPath'KMS_VL_ALL_AIO.cmd'))
			{
				Start-Process $unrar $unrarArgs
				Get-Process 7z | Wait-Process
			}
Start-Process $InstallPath'KMS_VL_ALL_AIO.cmd' -Wait

Write-Host 'OK'