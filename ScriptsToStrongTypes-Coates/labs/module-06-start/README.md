# Module 06 Starter — Packaging and Publishing

This is the completed state of Module 05. The solution has both the module
project and a passing xUnit test suite. Your job in Module 06 is to create
a `.psd1` manifest, run `dotnet publish`, register a local gallery, and
publish the module so it can be installed with `Install-Module`.

## What's here

```
PsStrongTypes/
├── PsStrongTypes.sln
├── src/
│   └── PsStrongTypes/
│       ├── PsStrongTypes.csproj
│       ├── GetGreetingCmdlet.cs    # Two param sets, validation, pipeline input
│       └── GreetingResult.cs
└── tests/
    ├── PsStrongTypes.Tests/
    │   ├── PsStrongTypes.Tests.csproj
    │   ├── GreetingResultTests.cs
    │   └── GetGreetingCmdletTests.cs
    └── PsStrongTypes.Tests.ps1     # Pester integration tests
```

## Verify the starting point

```pwsh
# C# tests
dotnet test
# Expected: all tests pass

# Pester tests (requires Pester 5.x)
Invoke-Pester tests/PsStrongTypes.Tests.ps1 -Output Detailed
# Expected: all tests pass
```
