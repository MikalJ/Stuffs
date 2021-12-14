oh-my-posh --init --shell pwsh --config "C:\src\Stuffs\WindowsTerminal\Mikal.omp.json" | Invoke-Expression
if ($host.Name -eq 'ConsoleHost')
{
    Import-Module PSReadLine
}
Import-Module -Name Terminal-Icons