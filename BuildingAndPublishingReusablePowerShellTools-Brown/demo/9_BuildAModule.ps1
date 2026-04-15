# Create a directory to host module files
New-Item -Name "MyNewModule" -ItemType Directory
Set-Location -Path ".\MyNewModule"

# Create the module code file
New-Item -Name "MyNewModule.psm1" -ItemType File
Get-Content -Path "..\7_AddHelp.ps1" | Set-Content -Path ".\MyNewModule.psm1"

# Import basic module file (just OK)
Import-Module ".\MyNewModule.psm1"

# Create a module manifest (better)
New-ModuleManifest `
    -Path "MyNewModule.psd1" `
    -RootModule "MyNewModule.psm1" `
    -Author "Jeff Brown" `
    -ModuleVersion "1.0.0" `
    -Description "Module of super awesome PowerShell I Wrote" `
    -FunctionsToExport @('Export-LogicAppDefinition')

# Verify manifest
Test-ModuleManifest -Path "MyNewModule.psd1"

# Copy the module to PSModulePath directory
$env:PSModulePath -split ';'
Copy-Item -Path "..\MyNewModule" -Destination "C:\Users\jeffw\OneDrive\Documents\PowerShell\Modules" -Recurse -Force
Get-ChildItem "C:\Users\jeffw\OneDrive\Documents\PowerShell\Modules\MyNewModule"

# Clean up existing modules
Get-Module -Name MyNewModule | Remove-Module

# Import the module
Import-Module -Name MyNewModule
Get-Module -Name MyNewModule | Format-List