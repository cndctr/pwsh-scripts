### Radmin install ###

Write-Verbose -Message 'Installing Radmin' -Verbose

Set-Location 'w:\soft\_utils\radmin\'
Start-Process msiexec -ArgumentList '/i rserv35.msi /passive' -Wait
$ServiceStatus = (Get-Service -Name RServer3).Status
if ($ServiceStatus -eq 'Running') {
    Stop-Service RServer3
    reg.exe import 'w:\soft\_utils\radmin\radmin_authNT.reg' # Reg-file sets access rights
    Copy-Item W:\soft\_utils\radmin\radmin_patch\* -Destination C:\Windows\SysWOW64\rserver30
}

Start-Service RServer3

Write-Verbose -Message 'OK' -Verbose
