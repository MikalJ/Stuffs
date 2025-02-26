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
Function KubectlGetPods { kubectl get pods $args }
Function KubectlClusterInfo { kubectl cluster-info $args }
New-Alias -Force -Name k -Value kubectl
New-Alias -Force -Name pods -Value KubectlGetPods
New-Alias -Force -Name ci -Value KubectlClusterInfo

# Base 64
function FromB64 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Base64String
    )
    process {
        $mod = $Base64String.Length % 4
        if ($mod -eq 2) {
            $Base64String += '=='
        } elseif ($mod -eq 3) {
            $Base64String += '='
        }
        $decodedString = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($Base64String))
        Write-Output $decodedString
    }
}


function ToB64 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$String
    )
    process {
        $encodedString = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($String))
        Write-Output $encodedString
    }
}

function Split-String {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Input,
        
        [Parameter(Mandatory = $true, ValueFromPipeline = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Separator
    )
    process {
        Foreach($item in $Input.Split($Separator, [System.StringSplitOptions]::RemoveEmptyEntries)) {
            Write-Output $item
        }
    }
}