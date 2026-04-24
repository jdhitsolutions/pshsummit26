# Module 04 Starter — Parameter Handling and Validation

This is the completed state of Module 03. `Get-Greeting` now emits a typed
`GreetingResult` object and declares `[OutputType]`. Your job in Module 04
is to add validation attributes, parameter sets, and pipeline input binding.

## What's here

- `src/PsStrongTypes/PsStrongTypes.csproj`
- `src/PsStrongTypes/GetGreetingCmdlet.cs` — cmdlet with `[OutputType(typeof(GreetingResult))]`
- `src/PsStrongTypes/GreetingResult.cs` — typed output class with Name, Message, GeneratedAt

## Verify the starting point

```pwsh
dotnet build src/PsStrongTypes
Import-Module ./src/PsStrongTypes/bin/Debug/netstandard2.0/PsStrongTypes.dll
Get-Greeting -Name 'World'
# Expected: a GreetingResult table with Name, Message, GeneratedAt columns

Get-Greeting -Name 'World' | Select-Object -ExpandProperty Message
# Expected: Hello, World!
```
