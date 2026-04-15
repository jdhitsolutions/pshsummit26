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

    if ($logicApp) {
        try {
            $logicApp.Definition.ToString() | Out-File -FilePath $exportFilePath -ErrorAction STOP
            $file = Get-Item -Path $exportFilePath

            $output = [PSCustomObject]@{
                LogicApp = $logicApp.Name
                File     = $file.FullName
            }

            $output
        }
        catch {
            $errorMessage = (Get-Error -Newest 1).Exception.Message
            Write-Warning -Message "There was an issue exporting the Logic App definition for $Name : $errorMessage"
        }
    }
    else {
        Write-Warning -Message "No Logic Apps found named $Name. Double check your spelling or current subscription context using Get-AzContext."
    }
}

Export-LogicAppDefinition -Name "doesnt-exist" -FileName logicappexport.json