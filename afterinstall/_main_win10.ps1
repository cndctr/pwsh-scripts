<# 
    Run a bundle of afterinstall scripts 
#>

Set-Location w:\soft\cmd\afterinstall\

# Settings and tweaks
.\settings_win10.ps1

# Uninstalling some unnecessary UWP apps
.\uninstall_uwp_apps_win10.ps1

# Uninstall OneDrive
.\uninstall_onedrive.ps1

# MS Office install
.\install_office.ps1

# Basic programs install using winget (Chrome, FSViewer, WinRAR, Zoom, SumatraPDF)
.\install_basic_programs.ps1

# Total Commander portable install
.\install_totalcmd.ps1

# Radmin install
.\install_radmin.ps1

# Activate Windows and MS Office
.\activate.ps1

# NOD32 install
.\install_nod.ps1

Read-Host -Prompt 'Press any key to exit'