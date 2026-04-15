function Export-LogicAppDefinition {
    <#
        .SYNOPSIS
            Exports an Azure Logic App definition to a JSON file.

        .DESCRIPTION
            Export-LogicAppDefinition retrieves an Azure Logic App by name and exports its
            definition to a JSON file. The function supports pipeline input, allowing multiple
            Logic App definitions to be exported in a single command. If no file name is
            provided, one is automatically generated using the Logic App name and a UTC
            timestamp.

        .PARAMETER Name
            The name of the Azure Logic App to export. Accepts pipeline input by value or
            by property name, allowing objects with a Name property to be piped directly
            to this function.

        .PARAMETER FilePath
            The directory path where the exported JSON file will be saved. Defaults to the
            current working directory if not specified. The path must already exist.

        .PARAMETER FileName
            The name of the JSON file to write the Logic App definition to. Must have a .json
            file extension. If not specified, the file is named using the format:
            <LogicAppName>_<FileDateTimeUniversal>.json

        .INPUTS
            System.String
                You can pipe a string representing a Logic App name to this function.

        .OUTPUTS
            PSCustomObject
                Returns an object with the following properties for each successfully
                exported Logic App:
                    LogicApp  - The name of the Logic App.
                    File      - The full path of the exported JSON file.

        .EXAMPLE
            Export-LogicAppDefinition -Name "MyLogicApp"

            Exports the definition of the Logic App named "MyLogicApp" to a JSON file in
            the current directory. The file is automatically named using the Logic App name
            and a UTC timestamp.

        .EXAMPLE
            Export-LogicAppDefinition -Name "MyLogicApp" -FilePath "C:\Exports" -FileName "MyLogicApp.json"

            Exports the definition of "MyLogicApp" to C:\Exports\MyLogicApp.json.

        .EXAMPLE
            "MyLogicApp1", "MyLogicApp2" | Export-LogicAppDefinition -FilePath "C:\Exports"

            Pipes multiple Logic App names to the function, exporting each definition to
            a separate auto-named JSON file in C:\Exports.

        .EXAMPLE
            Get-AzLogicApp | Export-LogicAppDefinition -FilePath "C:\Exports"

            Pipes all Logic Apps in the current subscription context to the function,
            exporting each definition to a separate auto-named JSON file in C:\Exports.

        .NOTES
            Requires the Az.Logic PowerShell module and an authenticated Azure session.
            Use Connect-AzAccount and Set-AzContext to ensure you are targeting the
            correct subscription before running this function.
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]
        $Name,

        [Parameter()]
        [ValidateScript(
            {
                if (Test-Path -Path $_) { $true } else { $false }
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

    process {
        $logicApp = Get-AzLogicApp -Name $Name

        # Creating process-specific variable so it can be nulled out when executing across multiple pipeline inputs
        $processFileName = $FileName

        # If the LogicApp exists
        if ($logicApp) {
            Write-Verbose -Message "Processing $Name"

            # Creating a process-loop specific variable
            if (-not $processFileName) {
                $processFileName = "$($Name)_$(Get-Date -Format FileDateTimeUniversal).json"
            }

            try {
                Write-Verbose -Message "Exporting Logic App definition to $processFileName."
                $logicApp.Definition.ToString() | Out-File -FilePath "$FilePath\$processFileName" -ErrorAction STOP
                $file = Get-Item -Path "$FilePath\$processFileName"

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
            finally {
                $processFileName = $null
            }
        }
        else {
            Write-Warning -Message "No Logic Apps found named $Name. Double check your spelling or current subscription context using Get-AzContext."
        }
    } # End process lbock
}