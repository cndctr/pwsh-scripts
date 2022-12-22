Write-Verbose -Message 'Removing UWP apps' -Verbose

# create a list of provisioned applications to be removed
$UWPApps = @(
	"Microsoft.549981C3F5F10"
	"Clipchamp.Clipchamp"
	"Microsoft.BingNews"
	"Microsoft.BingWeather"
	"Microsoft.GetHelp"
	"Microsoft.Getstarted"
	"Microsoft.Microsoft3DViewer"
	"Microsoft.MicrosoftOfficeHub"
	"Microsoft.MicrosoftSolitaireCollection"
	"Microsoft.MicrosoftStickyNotes"
	"Microsoft.MixedReality.Portal"
	"Microsoft.Office.OneNote"
	"Microsoft.People"
	"Microsoft.Wallet"
	"Microsoft.SkypeApp"
	"Microsoft.Todos"
	"microsoft.Windowscommunicationsapps"
	"Microsoft.WindowsFeedbackHub"
	"Microsoft.WindowsMaps"
	"Microsoft.WindowsSoundRecorder"
	"Microsoft.Xbox.TCUI"
	"Microsoft.XboxApp"
	"Microsoft.XboxGameOverlay"
	"Microsoft.XboxGamingOverlay"
	"Microsoft.XboxIdentityProvider"
	"Microsoft.XboxSpeechToTextOverlay"
	"Microsoft.YourPhone"
	"Microsoft.ZuneMusic"
	"Microsoft.ZuneVideo"
	"MicrosoftCorporationII.MicrosoftFamily"
	"MicrosoftCorporationII.QuickAssist"
	"MicrosoftTeams"
	)
# remove apps from both the Windows 10 image and all local user profiles
foreach ($UWPApp in $UWPApps) {
	Get-AppxPackage -Name $UWPApp -AllUsers | Remove-AppxPackage
	Get-AppXProvisionedPackage -Online | Where-Object DisplayName -eq $UWPApp | Remove-AppxProvisionedPackage -Online
}

Write-Verbose -Message 'OK' -Verbose
