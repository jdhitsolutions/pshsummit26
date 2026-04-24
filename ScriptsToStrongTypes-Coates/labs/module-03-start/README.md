# Module 03 Starter — Strong Types and Structured Output

This is the completed state of Module 02. `Get-Greeting` is a working binary
cmdlet that accepts a mandatory `-Name` parameter and writes a string to the
pipeline. Your job in Module 03 is to replace that string output with a
typed `GreetingResult` class.

## What's here

- `src/PsStrongTypes/PsStrongTypes.csproj` — Class Library targeting netstandard2.0
- `src/PsStrongTypes/GetGreetingCmdlet.cs` — working cmdlet, writes `"Hello, {Name}!"`

## Verify the starting point

```pwsh
dotnet build src/PsStrongTypes
Import-Module ./src/PsStrongTypes/bin/Debug/netstandard2.0/PsStrongTypes.dll
Get-Greeting -Name 'World'
# Expected: Hello, World!
```
