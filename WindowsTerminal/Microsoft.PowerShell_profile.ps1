$versionMinimum = [Version]'7.1.999'

oh-my-posh --init --shell pwsh --config "C:\src\Stuffs\WindowsTerminal\Mikal.omp.json" | Invoke-Expression
Import-Module -Name Terminal-Icons
Import-Module PSReadLine

if(($host.Name -eq 'ConsoleHost') -and ($PSVersionTable.PSVersion -ge $versionMinimum))
{
    Set-PSReadLineOption -PredictionSource HistoryAndPlugin
}
else {
    Set-PSReadLineOption -PredictionSource History
}

Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows
Import-Module ZLocation
#Add-Content -Value "`r`n`r`nImport-Module ZLocation`r`n" -Encoding utf8 -Path $PROFILE.CurrentUserAllHosts
Write-Host -Foreground Green "[ZLocation] knows about $((Get-ZLocation).Keys.Count) locations."

# General aliases
Function List-EnvironmentVariables { Get-ChildItem env:* | Sort-Object name }
New-Alias -Force -Name env -Value List-EnvironmentVariables

# Kubectl aliases
Function KubectlGetPods { kubectl get pods }
Function KubectlClusterInfo { kubectl cluster-info }
New-Alias -Force -Name k -Value kubectl
New-Alias -Force -Name pods -Value KubectlGetPods
New-Alias -Force -Name ci -Value KubectlClusterInfo