### Chrome, FSViewer, Winrar, Zoom, SumatraPDF install using winget

Write-Verbose -Message 'Installing Chrome, FSViewer, Winrar, Zoom, SumatraPDF' -Verbose

winget import 'w:\soft\winget\basic_import.json'
Copy-Item 'w:\soft\_utils\winrar\rarreg.key' -destination 'c:\program files\winrar\'
$env:SumatraParams = '/install /s -with-preview -d ""C:\Program Files\SumatraPDF""'
winget install sumatrapdf.sumatrapdf --accept-source-agreements --override $env:SumatraParams

Write-Verbose -Message 'OK' -Verbose