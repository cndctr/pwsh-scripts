### Settings ###

# Script variables
# $SoftPath = 'w:\soft\'
# $InstallPath = 'D:\install\'

# Initial user profile cleanup
Write-Verbose -Message 'Deleting USER userprofile, that was created during installation' -Verbose
if (Test-Path 'c:\users\user') {
    Get-CimInstance -classname win32_userprofile | Where-Object localpath -eq 'c:\users\user' | Remove-CimInstance
    Remove-LocalUser -name 'user'
	Write-Verbose -Message 'OK' -Verbose
}
else {
	Write-Verbose -Message 'No such profile' -Verbose
}
# Network settings
Write-Verbose -Message 'Enabling Network Discovery, file and printer Sharing ' -Verbose
# netsh advfirewall firewall set rule group="обнаружение сети" new enable=yes
# Set-NetFirewallRule -displaygroup "общий доступ к файлам и принтерам" -enabled true -profile any
$FirewallRules = @(
    # File and printer sharing
    "@FirewallAPI.dll,-32752",

    # Network discovery
    "@FirewallAPI.dll,-28502"
)
Set-NetFirewallRule -Group $FirewallRules -Profile Any -Enabled True
Set-NetFirewallRule -Profile Any -Name FPS-SMB-In-TCP -Enabled True
Write-Verbose -Message 'OK' -Verbose

# Defender exclutions
Write-Verbose -Message 'Adding Windows Defender exclusions' -Verbose
Add-MpPreference -ExclusionPath 'W:\soft'
Add-MpPreference -ExclusionPath 'D:\install'
Add-MpPreference -ExclusionPath 'C:\Windows\SysWOW64\rserver30'
Add-MpPreference -ExclusionPath '\\nas\soft'
Add-MpPreference -ExclusionPath '\\srv-file\files\soft'
Write-Verbose -Message 'OK' -Verbose


# Start menu layout
Write-Verbose -Message 'Importing Start menu and taskbar layout' -Verbose
Import-StartLayout -LayoutPath 'w:\soft\ms_windows\LayoutModification.xml' -MountPath c:\
Write-Verbose -Message 'OK' -Verbose

# Enabling WinRM 
Write-Verbose -Message 'Enabling  Windows remote management service' -Verbose
winrm quickconfig -quiet
Write-Verbose -Message 'OK' -Verbose

# Powerconfigurations
Write-Verbose -Message 'Setting monitor and standby timeouts' -Verbose
powercfg /x monitor-timeout-ac 60
powercfg /x standby-timeout-ac 0
Write-Verbose -Message 'OK' -Verbose

# Скрипт настройки внешнего вида. Твики
# Названия функций взяты из Sophia-Script-for-Windows (https://github.com/farag2/Sophia-Script-for-Windows)
# Отключить службу "Функциональные возможности для подключенных пользователей и телеметрия" (DiagTrack) и блокировать соединение для исходящего трафик клиента единой телеметрии
Write-Verbose -Message 'Applying some tweaks' -Verbose

# DiagTrackService -Disable
Get-Service -Name DiagTrack | Stop-Service -Force
Get-Service -Name DiagTrack | Set-Service -StartupType Disabled
Get-NetFirewallRule -Group DiagTrack | Set-NetFirewallRule -Enabled False -Action Block

# Установить уровень сбора диагностических данных ОС на минимальный
# DiagnosticDataLevel -Minimal
if (Get-WindowsEdition -Online | Where-Object -FilterScript {($_.Edition -like "Enterprise*") -or ($_.Edition -eq "Education")})
{
    # Security level
    New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection -Name AllowTelemetry -PropertyType DWord -Value 0 -Force
}
else
{
    # Required diagnostic data
    New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection -Name AllowTelemetry -PropertyType DWord -Value 1 -Force
}
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection -Name MaxTelemetryAllowed -PropertyType DWord -Value 1 -Force
New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack -Name ShowedToastAtLevel -PropertyType DWord -Value 1 -Force

# Открывать проводник для "Этот компьютер"
# OpenFileExplorerTo -ThisPC
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -PropertyType DWord -Value 1 -Force

# Скрыть папку "Объемные объекты" в "Этот компьютер" и панели быстрого доступа
# 3DObjects -Hide
if (-not (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"))
{
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" -Force
}
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" -Name ThisPCPolicy -PropertyType String -Value Hide -Force

# Скрыть недавно использовавшиеся файлы на панели быстрого доступа
# QuickAccessRecentFiles -Hide
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name ShowRecent -PropertyType DWord -Value 0 -Force

# Скрыть недавно используемые папки на панели быстрого доступа
# QuickAccessFrequentFolders -Hide
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name ShowFrequent -PropertyType DWord -Value 0 -Force


# Скрыть поле или значок поиска на панели задач
# TaskbarSearch -Hide
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search -Name SearchBoxTaskbarMode -Value 0 -Type DWord -Force

# Скрывать кнопку Кортаны на панели задач
# CortanaButton -Hide
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowCortanaButton -Value 0 -Type DWord -Force

# Скрыть кнопку Просмотра задач
# TaskViewButton -Hide
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowTaskViewButton -Value 0 -Type DWord -Force

# Скрыть панель "Люди" на панели задач
# PeopleTaskbar -Hide
if (-not (Test-Path -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People))
{
	New-Item -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People -Force
}
New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People -Name PeopleBand -PropertyType DWord -Value 0 -Force


# Скрыть главное в поиске
# SearchHighlights -Hide
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds\DSB -Name ShowDynamicContent -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings -Name IsDynamicSearchBoxEnabled -PropertyType DWord -Value 0 -Force


# Всегда отображать все значки в области уведомлений
# NotificationAreaIcons -Show
New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name EnableAutoTray -PropertyType DWord -Value 0 -Force

# Скрыть иконку "Провести собрание" в области уведомлений
# MeetNow -Hide
# $Settings = Get-ItemPropertyValue -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3 -Name Settings -ErrorAction Ignore
# $Settings[9] = 128
# New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3 -Name Settings -PropertyType Binary -Value $Settings -Force

# Скрыть кнопку Windows Ink Workspace на панели задач
# WindowsInkWorkspace -Hide
# New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PenWorkspace -Name PenWorkspaceButtonDesiredVisibility -PropertyType DWord -Value 0 -Force

# Отключить "Новости и интересы" на панели задач
# NewsInterests -Disable
if (-not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds"))
{
	New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" -Force
}
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" -Name EnableFeeds -PropertyType DWord -Value 0 -Force

# Скрыть пункт "Передать на устройство" из контекстного меню медиа-файлов и папок
# CastToDeviceContext -Hide
if (-not (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked"))
{
	New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Force
}
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{7AD84985-87B4-4a16-BE58-8B72A5B390F7}" -PropertyType String -Value "Play to menu" -Force	

# Скрыть пункт "Отправить" (поделиться) из контекстного меню
# ShareContext -Hide
if (-not (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked"))
{
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Force
}
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{E2BF9676-5F8F-435C-97EB-11607A5BEDF7}" -PropertyType String -Value "" -Force

# Скрыть пункт "Изменить с помощью Paint 3D" из контекстного меню медиа-файлов
# EditWithPaint3DContext -Hide
$Extensions = @(".bmp", ".gif", ".jpe", ".jpeg", ".jpg", ".png", ".tif", ".tiff")
foreach ($Extension in $Extensions)
{
    New-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\$Extension\Shell\3D Edit" -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
}

# Скрыть пункт "Изменить с помощью приложения "Фотографии"" из контекстного меню медиа-файлов
# EditWithPhotosContext -Hide
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\AppX43hnxtbyyps62jhe9sqpdzxn1790zetc\Shell\ShellEdit -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force

# Перезапустить explorer
Stop-Process -ProcessName Explorer

Write-Verbose -Message 'OK' -Verbose
