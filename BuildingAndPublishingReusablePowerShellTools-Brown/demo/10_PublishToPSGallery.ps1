# Create API key in PowerShell Gallery and save to a secure location

# Test publishing module to the gallery
Publish-Module -Path 'C:\gh\PSH2026-ReusablePowerShellTools\MyNewModule' `
    -Repository PSGallery `
    -NuGetApiKey $(Get-Secret -Name PSGalleryPSH2026Demo -Vault MyLocalSecretStore) `
    -WhatIf `
    -Verbose

# Publish the module to the gallery
Publish-Module -Path 'C:\gh\PSH2026-ReusablePowerShellTools\MyNewModule' `
    -Repository PSGallery `
    -NuGetApiKey $(Get-Secret -Name PSGalleryPSH2026Demo -Vault MyLocalSecretStore) `
    -Verbose

# https://www.powershellgallery.com/account/Packages