function Export-LogicAppDefinition {
    param(
        $Name,
        $FilePath,
        $FileName
    )

    $exportFilePath = Join-Path -Path $FilePath -ChildPath $FileName
    $logicApp = Get-AzLogicApp -Name $Name    
    $logicApp.Definition.ToString() | Out-File -FilePath $exportFilePath
}

Export-LogicAppDefinition -Name "<logic app name>" -FilePath . -FileName "<logic app name>".json