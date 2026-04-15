function Export-LogicAppDefinition {
    $logicApp = Get-AzLogicApp -Name "<logic app name>"
    $logicApp.Definition.ToString() | Out-File -FilePath .\mylogicappbackup.json
}
