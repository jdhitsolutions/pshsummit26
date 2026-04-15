function Export-LogicAppDefinition {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]
        $Name,

        [Parameter()]
        [ValidateScript(
            {
                (Test-Path -Path $_) ? $true : $false
            },
            ErrorMessage = "'{0}' is not a valid path."
        )]
        [string]
        $FilePath = (Get-Location),

        [Parameter()]
        [ValidatePattern("\.json$", ErrorMessage = "'{0}' should have a .json file extension.")]
        [string]
        $FileName
    )

    $exportFilePath = Join-Path -Path $FilePath -ChildPath $FileName
    $logicApp = Get-AzLogicApp -Name $Name    
    $logicApp.Definition.ToString() | Out-File -FilePath $exportFilePath
}

Export-LogicAppDefinition -Name "<logic app name>" -FilePath C:\idontexist -FileName "<logic app name>".json
Export-LogicAppDefinition -Name "<logic app name>" -FileName "<logic app name>".csv