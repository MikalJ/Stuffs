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

function Sha256 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$String
    )
    process {
        $byteArray = [System.Text.Encoding]::UTF8.GetBytes($String)
        $sha256 = [System.Security.Cryptography.SHA256]::Create()
        $hashBytes = $sha256.ComputeHash($byteArray)
        Write-Output $hashBytes -NoEnumerate
    }
}
function Sha256B64 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$String
    )
    process {
        $byteArray = [System.Text.Encoding]::UTF8.GetBytes($String)
        $sha256 = [System.Security.Cryptography.SHA256]::Create()
        $hashBytes = $sha256.ComputeHash($byteArray)
        $base64String = [Convert]::ToBase64String($hashBytes)
        Write-Output $base64String
    }
}

function ToHex {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, Position = 1, ValueFromPipeline = $true, HelpMessage = "Input as a byte array to encode.")]
        [ValidateNotNullOrEmpty()]
        [byte[]]$ByteArrayInput
    )
    process {
        $hex = [System.Convert]::ToHexString(@($ByteArrayInput;))
        Write-Output $hex
    }
}

function FromHex {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 1, ValueFromPipeline = $true, HelpMessage = "Input as a string to decode.")]
        [ValidateNotNullOrEmpty()]
        [string]$Input
    )
    process {
        $bytes = [System.Convert]::FromHexString($Input)
        Write-Output $bytes -NoEnumerate
    }
}



# Base 64
function FromB64 {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Base64String,
        
        [Parameter(Mandatory = $false, ParameterSetName = 'ToBytes')]
        [switch]$ToBytes,
        
        [Parameter(Mandatory = $false, ParameterSetName = 'ToHex')]
        [switch]$ToHex
    )
    process {
        $mod = $Base64String.Length % 4
        if ($mod -eq 2) {
            $Base64String += '=='
        } elseif ($mod -eq 3) {
            $Base64String += '='
        }
        
        $decodedBytes = [System.Convert]::FromBase64String($Base64String)
        
        if ($ToBytes) {
            Write-Output $decodedBytes -NoEnumerate
        } elseif ($ToHex) {
            $hexString = [System.Convert]::ToHexString($decodedBytes)
            Write-Output $hexString
        } else {
            $utf8string = [System.Text.Encoding]::UTF8.GetString($decodedBytes)
            Write-Output $utf8string
        }
    }
}

function ToB64 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true, HelpMessage = "Input as a string to encode.")]
        [string]$StringInput,

        [Parameter(Mandatory = $false, Position = 1, ValueFromPipeline = $true, HelpMessage = "Input as a byte array to encode.")]
        [byte[]]$ByteArrayInput
    )

    process {
        # Handle if the input is a string
        if ($PSCmdlet.MyInvocation.BoundParameters['StringInput']) {
            $encodedString = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($StringInput))
        }
        # Handle if the input is a byte array
        elseif ($PSCmdlet.MyInvocation.BoundParameters['ByteArrayInput']) {
            $encodedString = [System.Convert]::ToBase64String($ByteArrayInput)
        }
        else {
            throw "You must specify either a string or a byte array."
        }

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
#f45873b3-b655-43a6-b217-97c00aa0db58 PowerToys CommandNotFound module

Import-Module -Name Microsoft.WinGet.CommandNotFound
#f45873b3-b655-43a6-b217-97c00aa0db58

