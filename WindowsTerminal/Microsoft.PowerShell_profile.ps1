Import-Module posh-git
Import-Module oh-my-posh
Set-Theme Paradox
if ($host.Name -eq 'ConsoleHost')
{
    Import-Module PSReadLine
}
Import-Module -Name Terminal-Icons