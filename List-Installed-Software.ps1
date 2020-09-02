# ------------------------------------------------------------------------- #
# Variables
# ------------------------------------------------------------------------- #

# Change $AppsReportPath to wherever you wish

$Today = Get-Date
$TodayFile = get-date -f yyyy-MM-dd
$AppsReportPath = "$Env:SystemDrive\IT"
$AppsReportFile = "$AppsReportPath" + "\" + "InstalledProgramsList-" + "$TodayFile" + ".csv"


# ------------------------------------------------------------------------- #
# Commands
# ------------------------------------------------------------------------- #

If(!(test-path $AppsReportPath))
{
      New-Item -ItemType Directory -Force -Path $AppsReportPath
}

If (Test-Path $AppsReportFile) {
					Remove-Item $AppsReportFile
}

$list = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*
$list += Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*
$list | Where-Object {$_.DisplayName -and $_.UninstallString } | Select-Object DisplayName, Publisher, DisplayVersion, InstallLocation, InstallDate, URLInfoAbout, UninstallString | Sort-Object Publisher,DisplayName | Export-Csv -delimiter "`t" -encoding "unicode" "$AppsReportFile" -NoTypeInformation

exit $returnStateOK