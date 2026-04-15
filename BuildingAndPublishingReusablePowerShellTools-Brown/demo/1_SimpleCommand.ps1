# Start with fundamental task and determine how to accomplish it
# Get logic app resource
$logicApp = Get-AzLogicApp -Name "<logic app name>"

# View definition
$logicApp.Definition

# Convert to string
$logicApp.Definition.ToString()

# Export to a file
$logicApp.Definition.ToString() | Out-File -FilePath .\mylogicappbackup.json