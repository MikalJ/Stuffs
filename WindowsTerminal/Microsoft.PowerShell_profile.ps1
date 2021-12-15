oh-my-posh --init --shell pwsh --config "C:\src\Stuffs\WindowsTerminal\Mikal.omp.json" | Invoke-Expression
Import-Module -Name Terminal-Icons
Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows
Import-Module ZLocation
#Add-Content -Value "`r`n`r`nImport-Module ZLocation`r`n" -Encoding utf8 -Path $PROFILE.CurrentUserAllHosts
Write-Host -Foreground Green "[ZLocation] knows about $((Get-ZLocation).Keys.Count) locations."