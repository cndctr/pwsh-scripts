### Total Commander install ###

Write-Verbose -Message 'Installing portable Total Commander' -Verbose
Copy-Item -Path 'W:\soft\_utils\totalcmd\' -Recurse -Destination c:\ -Force
Copy-Item 'w:\soft\_utils\totalcmd\Total Commander.lnk' -Destination C:\Users\Public\Desktop
Write-Verbose -Message 'OK' -Verbose