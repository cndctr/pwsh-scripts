<# 
    Run a bundle of afterinstall scripts 
#>

Set-Location w:\soft\cmd\afterinstall\

# Settings and tweaks
powershell .\settings.ps1

# Uninstalling some unnecessary UWP apps
powershell .\uninstall_uwp_apps.ps1

# Uninstall OneDrive
powershell .\uninstall_onedrive.ps1

# MS Office install
powershell .\install_office.ps1

# Basic programs install using winget (Chrome, FSViewer, WinRAR, Zoom, SumatraPDF)
powershell .\install_basic_programs.ps1

# Total Commander portable install
powershell .\install_totalcmd.ps1

# Radmin install
powershell .\install_radmin.ps1

# Activate Windows and MS Office
powershell .\activate.ps1

# NOD32 install
powershell .\install_nod.ps1

Read-Host -Prompt 'Press any key to exit'