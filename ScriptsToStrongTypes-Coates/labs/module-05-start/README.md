# Module 05 Starter — Testing the Module

This is the completed state of Module 04. `Get-Greeting` has validation
attributes, two named parameter sets (`ByName` / `ByTemplate`), a `Count`
parameter, and `ValueFromPipelineByPropertyName` on `Name`. Your job in
Module 05 is to add an xUnit test project and Pester integration tests.

## What's here

- `src/PsStrongTypes/PsStrongTypes.csproj`
- `src/PsStrongTypes/GetGreetingCmdlet.cs` — two param sets, validation, pipeline input
- `src/PsStrongTypes/GreetingResult.cs` — typed output class

## Verify the starting point

```pwsh
dotnet build src/PsStrongTypes
Import-Module ./src/PsStrongTypes/bin/Debug/netstandard2.0/PsStrongTypes.dll -Force

# ByName set
Get-Greeting -Name 'World'

# ByTemplate set
Get-Greeting -Template 'Greetings, earthling!'

# Count parameter
Get-Greeting -Name 'World' -Count 3

# Pipeline input by property name
Get-Greeting -Name 'Alice' | Get-Greeting

# Validation — both should error
Get-Greeting -Name ''
Get-Greeting -Name 'World' -Count 0
```
