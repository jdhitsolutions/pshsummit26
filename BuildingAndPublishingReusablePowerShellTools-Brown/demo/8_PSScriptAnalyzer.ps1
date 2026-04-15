# Install PSScriptAnalyzer
Install-Module -Name PSScriptAnalyzer -Scope CurrentUser -Force
Import-Module -Name PSScriptAnalyzer

# Test the module
Invoke-ScriptAnalyzer -Path .\9_AddHelp.ps1