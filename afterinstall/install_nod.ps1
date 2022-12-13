### NOD32 Installation ###

Write-Verbose -Message 'Installing NOD32' -Verbose

Set-Location w:\soft\av\nod\_office\
Start-Process msiexec -ArgumentList '/i eavbe_nt64_rus_42713.msi /passive' -Wait

Write-Verbose -Message 'OK' -Verbose