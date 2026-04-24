---
marp: true
theme: summit-2026
paginate: true
---

<!-- _class: title -->
<!-- _footer: "" -->
<!-- _header: "" -->

# From Script to<br/>Strong Types

<p class="name">Ryan Coates</p>
<p class="handle">https://rdc.dev </p>

---

## Module 00: Environment Readiness

---

# What You Need

<div class="callout tertiary">

### Three tools. All free. All cross-platform.

</div>
<br/>

| Tool | Minimum Version | Check With |
|------|----------------|------------|
| .NET SDK | **8.0 LTS** | `dotnet --version` |
| PowerShell | **7.4** | `pwsh --version` |
| VS Code | Latest stable | C# Dev Kit extension |

---
<style scoped>section{font-size:28px;}</style>

# ⚠️ PowerShell 7 ≠ Windows PowerShell

<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; margin-top: 0.5rem;">
<div>
<div class="callout">

### `powershell.exe`


Windows PowerShell **5.1**

.NET Framework

❌ Not supported for this workshop

</div>

<br />

<div class="callout primary xsmall">

### `pwsh`

PowerShell **7.4+**

.NET 8

✅ Required

</div>

</div>
</div>
<p class="muted" style="margin-top: 0.8rem;">Always open <strong>pwsh</strong> — not powershell.exe — during this workshop.</p>

---

# Check Your .NET SDK

```powershell
# Confirm you have 8.x or higher
dotnet --version

# See everything installed
dotnet --list-sdks
```

<div class="callout" style="margin-top: 0.8rem;">

Expected output from `dotnet --version`:

```
8.0.404
```

</div>

---

# Confirm PowerShell 7

```powershell
# Launch PowerShell 7
pwsh

# Verify the version table
$PSVersionTable
```

<div class="callout primary" style="margin-top: 0.8rem;">

Look for `PSVersion` → `7.4.x` or higher

</div>

---

# VS Code Extensions

Install both before the workshop:

<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-top: 0.6rem;">

<div class="callout secondary">

### C# Dev Kit
`ms-dotnettools.csharp`

Roslyn IntelliSense, refactoring, and build tasks

</div>
<br />
<div class="callout quaternary">

### PowerShell
`ms-vscode.powershell`

Syntax highlighting, debugging, and Pester support

</div>

</div>

---

# The Smoke Test

Run this **before the workshop day**. If it passes, you're ready.

```powershell
# Create, build, and verify a throwaway project
dotnet new classlib -o smoke-test
cd smoke-test
dotnet build
```

<div class="callout primary" style="margin-top: 0.6rem;">

✅ Build succeeded → **You're good to go**

❌ Error? → See the setup channel or reply to the pre-work email

</div>

---

# Verify IntelliSense in VS Code

```powershell
# Open the smoke-test folder
code .
```

1. Open `Class1.cs`
2. Type `System.`
3. Wait for the Roslyn spinner to clear (up to 60s on first open)
4. Completions should appear ✅

```csharp
// If you can see System.Console, System.IO etc. — you're done
using System.
//           ^ IntelliSense should pop here
```

---

# Pre-Work Checklist

<ul class="checklist">
  <li><code>dotnet --version</code> returns <strong>8.x</strong></li>
  <li><code>pwsh --version</code> returns <strong>7.4+</strong></li>
  <li>VS Code C# Dev Kit and PowerShell extensions installed</li>
  <li>Smoke-test build exits with <strong>Build succeeded</strong></li>
  <li>IntelliSense resolves <code>System.</code> completions in VS Code</li>
</ul>

</div>

---

# You're Set Up.

## See You in Module 01.

---

## Module 01: Project Scaffold

---

# What You'll Build

By the end of this module you'll have a working project scaffold — every later module builds directly on top of it.

<div class="callout gradient" style="margin-top: 0.8rem;">

```
PsStrongTypes/
└── src/
    └── PsStrongTypes/
        ├── PsStrongTypes.csproj   ← references PowerShell SDK
        └── GetGreetingCmdlet.cs   ← stub PSCmdlet class
```

</div>

---

<style scoped>section{font-size:22px;}</style>


# Script Module vs Binary Module

<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.2rem; margin-top: 0.5rem;">

<div class="callout secondary">

### Script Module `.psm1`
- Functions in plain text
- No compiler
- No refactoring tooling
- Hard to unit test
- Great for *small* tools

</div>
<br />
<div class="callout primary">

### Binary Module `.dll`
- Classes compiled to IL
- Full Roslyn toolchain
- xUnit test harness
- IntelliSense everywhere
- Scales with complexity

</div>

</div>

---
<style scoped>section{font-size:26px;}</style>

# The Mental Shift

<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.2rem; margin-top: 0.4rem;">

<div class="callout tertiary">

### PowerShell World
`MyModule.psm1` **is** the module

`Import-Module ./MyModule.psm1`

Functions live in `.ps1` files

</div>
<br />
<div class="callout quaternary">

### .NET World
`.csproj` defines the project

`Import-Module ./bin/.../MyModule.dll`

Cmdlets live in `.cs` **classes**

</div>

</div>

<blockquote style="margin-top: 0.8rem;">
You import the <strong>compiled output</strong>, not the source.
</blockquote>

---

<!-- _class: no_background -->
<!-- _footer: "" -->

<div style="display: flex; align-items: center; justify-content: center; height: 100%; flex-direction: column; gap: 1rem;">

<div style="background: linear-gradient(41deg, rgba(0,174,239,0.9), rgba(43,45,120,0.9), rgba(146,39,143,0.9)); border-radius: 20px; padding: 2rem 3rem; text-align: center; width: 80%;">

<p style="font-size: 0.55rem; text-transform: uppercase; letter-spacing: 0.15em; color: rgba(255,255,255,0.7); margin: 0 0 0.5rem;">Open Discussion</p>

# 🔬 Why Binary Modules?

</div>

</div>

---

# Scaffold the Project

```powershell
# 1. Create the root folder
mkdir PsStrongTypes && cd PsStrongTypes

# 2. Scaffold a Class Library
dotnet new classlib -n PsStrongTypes -o src/PsStrongTypes -f net8.0

# 3. Delete the placeholder file
Remove-Item src/PsStrongTypes/Class1.cs
```

<div class="callout secondary" style="margin-top: 0.6rem;">

`dotnet new classlib` gives you a `.csproj` and a `bin/` output folder — nothing else to configure yet.

</div>

---

# Set the Target Framework

Open `src/PsStrongTypes/PsStrongTypes.csproj` and confirm one line:

```xml
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>

    <!-- Make sure this line says net8.0-->
    <TargetFramework>net8.0</TargetFramework>

    <Nullable>enable</Nullable>
    <ImplicitUsings>enable</ImplicitUsings>
  </PropertyGroup>
</Project>
```

---

<!-- _class: no_background -->
<!-- _footer: "" -->

<div style="display: flex; align-items: center; justify-content: center; height: 100%; flex-direction: column; gap: 1rem;">

<div style="background: linear-gradient(41deg, rgba(0,174,239,0.9), rgba(43,45,120,0.9), rgba(146,39,143,0.9)); border-radius: 20px; padding: 2rem 3rem; text-align: center; width: 80%;">

<p style="font-size: 0.55rem; text-transform: uppercase; letter-spacing: 0.15em; color: rgba(255,255,255,0.7); margin: 0 0 0.5rem;">Live Demo</p>

# 🔧 Scaffold + TFM Change

<p style="color: rgba(255,255,255,0.9); font-size: 0.75rem; margin: 0.5rem 0 0;">Run <code>dotnet new classlib</code>, edit the <code>.csproj</code>, run <code>dotnet build</code> — confirm green output</p>

</div>

<div class="callout" style="width: 80%; margin: 0;">

**Watch for:** `Build succeeded` targeting `net8.0` in the build output

</div>

</div>

---

# Add SMA

```powershell
dotnet add src/PsStrongTypes package Microsoft.System.Automation
```

This adds one entry to your `.csproj`:

```xml
<ItemGroup>
  <PackageReference Include="Microsoft.System.Automation" Version="7.4.*" />
</ItemGroup>
```

<div class="callout primary" style="margin-top: 0.6rem;">

**SDK vs SMA:** Use `System.Management.Automation` — not `Microsoft.PowerShell.SDK`. The full SDK gives you a lot more capability but isnt required for everything.

</div>

---

# What SMA Unlocks

```csharp
// These types are now resolvable in your project
using System.Management.Automation;

namespace PsStrongTypes;

public class GetGreetingCmdlet : PSCmdlet   // ← base class
{
    // PSCmdlet, PSObject, WriteObject, WriteError,
    // WriteVerbose, ShouldProcess ... all available
}
```

<p class="muted">Confirm IntelliSense resolves <code>PSCmdlet</code> in VS Code before moving on.</p>

---

<!-- _class: no_background -->
<!-- _footer: "" -->

<div style="display: flex; align-items: center; justify-content: center; height: 100%; flex-direction: column; gap: 1rem;">

<div style="background: linear-gradient(41deg, rgba(0,174,239,0.9), rgba(43,45,120,0.9), rgba(146,39,143,0.9)); border-radius: 20px; padding: 2rem 3rem; text-align: center; width: 80%;">

<p style="font-size: 0.55rem; text-transform: uppercase; letter-spacing: 0.15em; color: rgba(255,255,255,0.7); margin: 0 0 0.5rem;">Live Demo</p>

# 📦 Add the NuGet Package

<p style="color: rgba(255,255,255,0.9); font-size: 0.75rem; margin: 0.5rem 0 0;">Run <code>dotnet add package</code>, open VS Code, type <code>PSCmdlet</code> — watch IntelliSense resolve it</p>

</div>

<div class="callout" style="width: 80%; margin: 0;">

**Point out:** the `PackageReference` that appeared in `.csproj` — same as `Install-Module` but for .NET

</div>

</div>

---

# Build and Verify

```powershell
dotnet build src/PsStrongTypes
```

```
Build succeeded.
    0 Warning(s)
    0 Error(s)
```

```powershell
# The .dll that PowerShell will load lives here:
ls src/PsStrongTypes/bin/Debug/net8.0/
```

<div class="callout secondary" style="margin-top: 0.6rem;">

`PsStrongTypes.dll` in that folder **is** your module. We'll `Import-Module` it in Module 02.

</div>

---

# Module 01 — Done ✅

<ul class="checklist">
  <li>Class Library project scaffolded targeting <strong>net8.0</strong></li>
  <li><code>System.Management.Automation</code> NuGet reference in <code>.csproj</code></li>
  <li><code>PSCmdlet</code> resolves in VS Code IntelliSense</li>
  <li><code>dotnet build</code> exits with <strong>Build succeeded</strong></li>
  <li><code>.dll</code> output visible in <code>bin/Debug/net8.0/</code></li>
</ul>

---

## Module 02: PSCmdlet, Parameters, and WriteObject


---

# The Bridge: PS → C#

| PowerShell | C# Equivalent | Why It Matters |
|---|---|---|
| `[CmdletBinding()]` | `[Cmdlet(...)]` attribute | How PS discovers & names your cmdlet |
| `param([string]$Name)` | `public string Name { get; set; }` | Runtime sets properties before ProcessRecord |
| `Write-Output $val` | `WriteObject(val)` | Participates in the pipeline correctly |
| Function body | `override void ProcessRecord()` | Called once per pipeline input object |

---

# Anatomy of a Cmdlet Class

```csharp
using System.Management.Automation;

namespace PsStrongTypes;

[Cmdlet(VerbsCommon.Get, "Greeting")]            // (1) Name registration
public class GetGreetingCmdlet : PSCmdlet        // (2) Base class
{
    protected override void ProcessRecord()      // (3) Execution entry point
    {
        WriteObject("Hello, World!");            // (4) Pipeline output
    }
}
```

<p class="muted">PowerShell uses reflection to find classes decorated with <code>[Cmdlet]</code> — the attribute IS the registration mechanism.</p>

---
<style scoped>section{font-size:28px;}</style>


# Why Not `return`?

<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.2rem; margin-top: 0.4rem;">

<div class="callout secondary">

### ❌ `return value`

Exits the method.

Does **not** emit to the pipeline.

Breaks pipeline chaining.

</div>
<br />
<div class="callout primary">

### ✅ `WriteObject(value)`

Sends the object downstream.

Respects `-OutVariable`, `| Where-Object`, etc.

Works exactly like `Write-Output`.

</div>

</div>

---

# Use Approved Verbs

```csharp
// ✅ Use verb constant classes — tab-complete in VS Code
[Cmdlet(VerbsCommon.Get,         "Item")]
[Cmdlet(VerbsData.Export,        "Report")]

// ❌ String literals trigger a warning on Import-Module
[Cmdlet("Fetch", "Greeting")]
// WARNING: The verb 'Fetch' in the cmdlet name is not approved
```

<div class="callout tertiary" style="margin-top: 0.6rem;">

Full approved verb list: `Get-Verb` in pwsh, or the MS Docs link in the resources.

</div>

---

<!-- _class: no_background -->
<!-- _footer: "" -->

<div style="display: flex; align-items: center; justify-content: center; height: 100%; flex-direction: column; gap: 1rem;">

<div style="background: linear-gradient(41deg, rgba(0,174,239,0.9), rgba(43,45,120,0.9), rgba(146,39,143,0.9)); border-radius: 20px; padding: 2rem 3rem; text-align: center; width: 80%;">

<p style="font-size: 0.55rem; text-transform: uppercase; letter-spacing: 0.15em; color: rgba(255,255,255,0.7); margin: 0 0 0.5rem;">Live Demo</p>

# 🏗️ Implement the Minimal Cmdlet

<p style="color: rgba(255,255,255,0.9); font-size: 0.75rem; margin: 0.5rem 0 0;">Write the four-line cmdlet, run <code>dotnet build</code>, then <code>Import-Module</code> the <code>.dll</code> — call <code>Get-Greeting</code></p>

</div>

<div class="callout" style="width: 80%; margin: 0;">

**Watch for:** PowerShell finding the class automatically — no module manifest needed yet

</div>

</div>

---

# Add a Typed Parameter

```csharp
[Cmdlet(VerbsCommon.Get, "Greeting")]
public class GetGreetingCmdlet : PSCmdlet
{
    [Parameter(Mandatory = true)]           // ← attribute = declaration
    public string Name { get; set; } = string.Empty;

    protected override void ProcessRecord()
    {
        WriteObject($"Hello, {Name}!");     // ← Name is set before this runs
    }
}
```

<p class="muted">The runtime sets your property values <em>before</em> it calls ProcessRecord — you never parse <code>$args</code> yourself.</p>

---

# Import and Invoke

```powershell
# Build
dotnet build src/PsStrongTypes

# Import the compiled DLL directly
Import-Module ./src/PsStrongTypes/bin/Debug/net8.0/PsStrongTypes.dll

# Use it
Get-Greeting -Name 'World'
# Hello, World!

# See what was imported
Get-Command -Module PsStrongTypes

# Observe mandatory parameter enforcement
Get-Greeting
# cmdlet Get-Greeting at command pipeline position 1
# Supply values for the following parameters: Name:
```

---

<!-- _class: no_background -->
<!-- _footer: "" -->

<div style="display: flex; align-items: center; justify-content: center; height: 100%; flex-direction: column; gap: 1rem;">

<div style="background: linear-gradient(41deg, rgba(0,174,239,0.9), rgba(43,45,120,0.9), rgba(146,39,143,0.9)); border-radius: 20px; padding: 2rem 3rem; text-align: center; width: 80%;">

<p style="font-size: 0.55rem; text-transform: uppercase; letter-spacing: 0.15em; color: rgba(255,255,255,0.7); margin: 0 0 0.5rem;">Live Demo</p>

# ⚡ Parameter + Import + Invoke

<p style="color: rgba(255,255,255,0.9); font-size: 0.75rem; margin: 0.5rem 0 0;">Add the <code>Name</code> parameter, rebuild, re-import, call <code>Get-Greeting -Name 'World'</code> — then call it with <em>no</em> arguments</p>

</div>

<div class="callout" style="width: 80%; margin: 0;">

**Discussion:** Why does PS prompt for the missing parameter instead of throwing immediately?

</div>

</div>

---

# The Cmdlet Lifecycle

```csharp
protected override void BeginProcessing()   // Once — before pipeline input
{
    WriteVerbose("[BeginProcessing] called");
}

protected override void ProcessRecord()     // Once per input object
{
    WriteVerbose("[ProcessRecord] called");
    WriteObject($"Hello, {Name}!");
}

protected override void EndProcessing()     // Once — after all input
{
    WriteVerbose("[EndProcessing] called");
}
```

---

<style scoped>section{font-size:22px;}</style>

# Lifecycle Mental Model

<div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 1rem; margin-top: 0.5rem;">

<div class="callout tertiary xsmall">

### BeginProcessing
**Setup**

Open connections, initialize state, validate context

</div>

<br />

<div class="callout primary xsmall">

### ProcessRecord
**The loop body**

Called for every piped object — this is where your work happens

</div>

<br />

<div class="callout quaternary">

### EndProcessing
**Teardown**

Aggregate results, close connections, flush buffers

</div>

</div>

<p class="muted" style="margin-top: 0.8rem;">Think: <em>setup → foreach → teardown</em></p>

---

<!-- _class: no_background -->
<!-- _footer: "" -->

<div style="display: flex; align-items: center; justify-content: center; height: 100%; flex-direction: column; gap: 1rem;">

<div style="background: linear-gradient(41deg, rgba(0,174,239,0.9), rgba(43,45,120,0.9), rgba(146,39,143,0.9)); border-radius: 20px; padding: 2rem 3rem; text-align: center; width: 80%;">

<p style="font-size: 0.55rem; text-transform: uppercase; letter-spacing: 0.15em; color: rgba(255,255,255,0.7); margin: 0 0 0.5rem;">Live Demo</p>

# 🔄 Observe the Lifecycle

<p style="color: rgba(255,255,255,0.9); font-size: 0.75rem; margin: 0.5rem 0 0;">Add <code>WriteVerbose</code> to all three overrides, rebuild, run <code>Get-Greeting -Name 'Test' -Verbose</code></p>

</div>

<div class="callout" style="width: 80%; margin: 0;">

**Watch for:** Begin → Process → End ordering in the verbose stream — then pipe two names and watch Process fire twice

</div>

</div>

---

# ProcessRecord Is the Pipeline Loop

```powershell
# Each piped object triggers one ProcessRecord call
'Alice', 'Bob', 'Carol' | ForEach-Object { Get-Greeting -Name $_ }

# The runtime is doing this on your behalf:
# BeginProcessing()  ← once
# ProcessRecord()    ← 'Alice'
# ProcessRecord()    ← 'Bob'
# ProcessRecord()    ← 'Carol'
# EndProcessing()    ← once
```

<p class="muted">This is why you don't accumulate <code>$input</code> yourself — hand the runtime one object at a time and let the pipeline do the looping.</p>

---

# Module 02 — Done ✅

<ul class="checklist">
  <li><code>GetGreetingCmdlet</code> decorated with <code>[Cmdlet(VerbsCommon.Get, "Greeting")]</code></li>
  <li>Mandatory <code>Name</code> parameter declared as a public property</li>
  <li><code>WriteObject</code> used for pipeline output — not <code>return</code></li>
  <li><code>Get-Greeting -Name 'World'</code> works in a live <code>pwsh</code> session</li>
  <li>Lifecycle methods (Begin / Process / End) understood and demonstrated</li>
</ul>

---

## Module 03: Custom Classes and OutputType

---

# String Output Is a Dead End

```powershell
# What can you do with a string?
'Hello, World!' | Select-Object -Property Length
# Result: just a character count — not what you wanted

# What can you do with a typed object?
[PSCustomObject]@{ Name='World'; Message='Hello, World!' } |
    Select-Object -Property Message
# Result: "Hello, World!" — direct, clean, composable
```

<blockquote>
Typed objects let consumers filter, sort, and transform your data <strong>without parsing text</strong>.
</blockquote>

---

<!-- _class: no_background -->
<!-- _footer: "" -->

<div style="display: flex; align-items: center; justify-content: center; height: 100%; flex-direction: column; gap: 1rem;">

<div style="background: linear-gradient(41deg, rgba(0,174,239,0.9), rgba(43,45,120,0.9), rgba(146,39,143,0.9)); border-radius: 20px; padding: 2rem 3rem; text-align: center; width: 80%;">

<p style="font-size: 0.55rem; text-transform: uppercase; letter-spacing: 0.15em; color: rgba(255,255,255,0.7); margin: 0 0 0.5rem;">Live Demo</p>

# 🔍 String vs Object in the Pipeline

<p style="color: rgba(255,255,255,0.9); font-size: 0.75rem; margin: 0.5rem 0 0;">Run the two <code>Select-Object</code> snippets side by side — let the contrast speak for itself</p>

</div>

<div class="callout" style="width: 80%; margin: 0;">

**Ask the room:** Which output would you rather consume in a script two months from now?

</div>

</div>

---

<style scoped>section{font-size:22px;}</style>


# PSCustomObject vs Typed Class

<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.2rem; margin-top: 0.4rem;">

<div class="callout secondary">

### PSCustomObject
```powershell
[PSCustomObject]@{
  Name    = 'World'
  Message = 'Hello!'
}
```
Dynamic bag — no IntelliSense, no compile-time safety

</div>
<br />
<div class="callout primary">

### C# Class
```csharp
public class GreetingResult
{
    public string Name { get; }
    public string Message { get; }
}
```
Stable contract — IntelliSense, refactoring, testable

</div>

</div>

---

# Define the Output Class

```csharp
// src/PsStrongTypes/GreetingResult.cs
namespace PsStrongTypes;

public class GreetingResult
{
    public string Name { get; }
    public string Message { get; }
    public DateTimeOffset GeneratedAt { get; }

    public GreetingResult(string name, string message)
    {
        Name        = name;
        Message     = message;
        GeneratedAt = DateTimeOffset.UtcNow;
    }
}
```

<p class="muted">Keep output classes simple, flat, and serialization-friendly — they're data containers, not logic hosts.</p>

---

# Apply [OutputType] and Emit

```csharp
[Cmdlet(VerbsCommon.Get, "Greeting")]
[OutputType(typeof(GreetingResult))]               // ← promise to tooling
public class GetGreetingCmdlet : PSCmdlet
{
    [Parameter(Mandatory = true)]
    public string Name { get; set; } = string.Empty;

    protected override void ProcessRecord()
    {
        WriteObject(new GreetingResult(Name, $"Hello, {Name}!"));
    }
}
```

<p class="muted"><code>[OutputType]</code> is a hint to IntelliSense and <code>Get-Help</code> — it does <em>not</em> enforce types at runtime.</p>

---

# What [OutputType] Gives You

<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.2rem; margin-top: 0.4rem;">

<div class="callout tertiary">

### At Design Time
IDE IntelliSense on the output object

`(Get-Command Get-Greeting).OutputType` shows the type

Tab-complete on piped properties

</div>
<br />

<div class="callout quaternary">

### At Runtime
No enforcement — **a promise, not a constraint**

Breaking it silently confuses consumers

Keeping it makes your module a good citizen

</div>

</div>

---

<!-- _class: no_background -->
<!-- _footer: "" -->

<div style="display: flex; align-items: center; justify-content: center; height: 100%; flex-direction: column; gap: 1rem;">

<div style="background: linear-gradient(41deg, rgba(0,174,239,0.9), rgba(43,45,120,0.9), rgba(146,39,143,0.9)); border-radius: 20px; padding: 2rem 3rem; text-align: center; width: 80%;">

<p style="font-size: 0.55rem; text-transform: uppercase; letter-spacing: 0.15em; color: rgba(255,255,255,0.7); margin: 0 0 0.5rem;">Live Demo</p>

# 🧱 Create GreetingResult + OutputType

<p style="color: rgba(255,255,255,0.9); font-size: 0.75rem; margin: 0.5rem 0 0;">Add the class, update the cmdlet, rebuild, re-import — run <code>Get-Greeting -Name 'World'</code> and observe the formatted table</p>

</div>

<div class="callout" style="width: 80%; margin: 0;">

**Then run:** `(Get-Help Get-Greeting).returnValues` — show the OutputType surfacing in help

</div>

</div>

---

# Consuming Typed Output

```powershell
# Expand a single property
Get-Greeting -Name 'World' | Select-Object -ExpandProperty Message
# Hello, World!

# Filter on a typed property
'Alice','Bob','Charlie' |
    ForEach-Object { Get-Greeting -Name $_ } |
    Where-Object { $_.Name.StartsWith('A') }

# Sort on a typed property
'Charlie','Alice','Bob' |
    ForEach-Object { Get-Greeting -Name $_ } |
    Sort-Object Name
```

---

<!-- _class: no_background -->
<!-- _footer: "" -->

<div style="display: flex; align-items: center; justify-content: center; height: 100%; flex-direction: column; gap: 1rem;">

<div style="background: linear-gradient(41deg, rgba(0,174,239,0.9), rgba(43,45,120,0.9), rgba(146,39,143,0.9)); border-radius: 20px; padding: 2rem 3rem; text-align: center; width: 80%;">

<p style="font-size: 0.55rem; text-transform: uppercase; letter-spacing: 0.15em; color: rgba(255,255,255,0.7); margin: 0 0 0.5rem;">Live Demo</p>

# 🔗 Typed Output in the Pipeline

<p style="color: rgba(255,255,255,0.9); font-size: 0.75rem; margin: 0.5rem 0 0;">Pipe multiple names through <code>Get-Greeting</code>, then chain <code>Where-Object</code> and <code>Sort-Object</code> — no text parsing needed</p>

</div>

<div class="callout" style="width: 80%; margin: 0;">

**Foreshadow Module 04:** "Next module we'll remove the <code>ForEach-Object</code> wrapper entirely with <code>ValueFromPipelineByPropertyName</code>"

</div>

</div>

---

# Module 03 — Done ✅

<ul class="checklist">
  <li><code>GreetingResult</code> class with <code>Name</code>, <code>Message</code>, <code>GeneratedAt</code> properties</li>
  <li><code>[OutputType(typeof(GreetingResult))]</code> on the cmdlet class</li>
  <li><code>WriteObject</code> emits a typed <code>GreetingResult</code> instance</li>
  <li><code>Select-Object -ExpandProperty Message</code> returns the greeting string</li>
  <li>Output is sortable and filterable without any string parsing</li>
</ul>

---

## Module 04: Sets, Attributes, and Pipeline Input

---

# The Bridge: PS → C#

| PowerShell | C# Equivalent |
|---|---|
| `[ValidateNotNullOrEmpty()]` | `[ValidateNotNullOrEmpty]` — identical, from SMA |
| `[ValidateRange(1,100)]` | `[ValidateRange(1, 100)]` — same attribute |
| `[Parameter(ParameterSetName='X')]` | `[Parameter(ParameterSetName = "X")]` |
| `[Parameter(ValueFromPipeline=$true)]` | `[Parameter(ValueFromPipeline = true)]` |

<p class="muted">The C# attribute names are <em>identical</em> — PowerShell's parameter system was always C# under the hood.</p>

---

# Validation Is a Free Gift

```csharp
[ValidateNotNullOrEmpty]                        // no null, no empty string
[Parameter(Mandatory = true)]
public string Name { get; set; } = string.Empty;

[ValidateRange(1, 100)]                         // numeric bounds
[Parameter]
public int Count { get; set; } = 1;

[ValidateSet("Formal", "Casual", "Pirate")]     // discrete allowed values
[Parameter]
public string Style { get; set; } = "Formal";
```

<blockquote>
Validation attributes run <strong>before ProcessRecord</strong> — your cmdlet body never sees invalid data. Stop writing null checks.
</blockquote>

---

<!-- _class: no_background -->
<!-- _footer: "" -->

<div style="display: flex; align-items: center; justify-content: center; height: 100%; flex-direction: column; gap: 1rem;">

<div style="background: linear-gradient(41deg, rgba(0,174,239,0.9), rgba(43,45,120,0.9), rgba(146,39,143,0.9)); border-radius: 20px; padding: 2rem 3rem; text-align: center; width: 80%;">

<p style="font-size: 0.55rem; text-transform: uppercase; letter-spacing: 0.15em; color: rgba(255,255,255,0.7); margin: 0 0 0.5rem;">Live Demo</p>

# 🛡️ Validation Attributes in Action

<p style="color: rgba(255,255,255,0.9); font-size: 0.75rem; margin: 0.5rem 0 0;">Add <code>[ValidateNotNullOrEmpty]</code> and <code>[ValidateRange]</code>, rebuild — test with <code>-Name ''</code> and <code>-Count 0</code></p>

</div>

<div class="callout" style="width: 80%; margin: 0;">

**Point out:** the error message comes from the framework — zero lines of validation code written

</div>

</div>

---

# Parameter Sets

```csharp
[Cmdlet(VerbsCommon.Get, "Greeting",
    DefaultParameterSetName = "ByName")]        // ← default set
public class GetGreetingCmdlet : PSCmdlet
{
    [Parameter(Mandatory = true, ParameterSetName = "ByName")]
    public string Name { get; set; } = string.Empty;

    [Parameter(Mandatory = true, ParameterSetName = "ByTemplate")]
    public string Template { get; set; } = string.Empty;

    protected override void ProcessRecord()
    {
        var result = ParameterSetName == "ByName"
            ? new GreetingResult(Name, $"Hello, {Name}!")
            : new GreetingResult("(template)", Template);
        WriteObject(result);
    }
}
```

---

# Parameter Sets: The Payoff

```powershell
# Two distinct usage modes, one cmdlet
Get-Greeting -Name 'World'
Get-Greeting -Template 'Greetings, earthling!'

# Conflict caught at runtime — before your code runs
Get-Greeting -Name 'World' -Template 'Hi'
# ERROR: Parameter set cannot be resolved

# Help shows both syntaxes automatically
Get-Help Get-Greeting -Full
```

<p class="muted">Parameter sets are how you give one cmdlet multiple personalities — each set is a distinct usage mode.</p>

---

<!-- _class: no_background -->
<!-- _footer: "" -->

<div style="display: flex; align-items: center; justify-content: center; height: 100%; flex-direction: column; gap: 1rem;">

<div style="background: linear-gradient(41deg, rgba(0,174,239,0.9), rgba(43,45,120,0.9), rgba(146,39,143,0.9)); border-radius: 20px; padding: 2rem 3rem; text-align: center; width: 80%;">

<p style="font-size: 0.55rem; text-transform: uppercase; letter-spacing: 0.15em; color: rgba(255,255,255,0.7); margin: 0 0 0.5rem;">Live Demo</p>

# 🎭 Two Parameter Sets

<p style="color: rgba(255,255,255,0.9); font-size: 0.75rem; margin: 0.5rem 0 0;">Add the <code>ByTemplate</code> set, rebuild — run both modes, then run <code>Get-Help Get-Greeting -Full</code></p>

</div>

<div class="callout" style="width: 80%; margin: 0;">

**Watch for:** Two distinct SYNTAX blocks in the help output — generated entirely from attributes

</div>

</div>

---

# Pipeline Input by Property Name

```csharp
[Parameter(
    Mandatory = true,
    ParameterSetName = "ByName",
    ValueFromPipelineByPropertyName = true)]   // ← the magic
public string Name { get; set; } = string.Empty;
```

```powershell
# GreetingResult.Name → binds to -Name automatically
Get-Greeting -Name 'Alice' | Get-Greeting

# Any object with a Name property works
'Bob','Carol' |
    ForEach-Object { [PSCustomObject]@{ Name = $_ } } |
    Get-Greeting
```

---

# Why ByPropertyName Is Powerful

<div class="callout gradient" style="margin-top: 0.3rem;">

### The Secret to Composable Cmdlets

Your **typed output class property names** become implicit pipeline glue.

`GreetingResult.Name` → matches → `-Name` parameter

No explicit binding. No adapters. It just works.

</div>

<p class="muted" style="margin-top: 0.8rem;">This is why naming your output class properties consistently with parameter names pays off in Module 3's design decisions.</p>

---

<!-- _class: no_background -->
<!-- _footer: "" -->

<div style="display: flex; align-items: center; justify-content: center; height: 100%; flex-direction: column; gap: 1rem;">

<div style="background: linear-gradient(41deg, rgba(0,174,239,0.9), rgba(43,45,120,0.9), rgba(146,39,143,0.9)); border-radius: 20px; padding: 2rem 3rem; text-align: center; width: 80%;">

<p style="font-size: 0.55rem; text-transform: uppercase; letter-spacing: 0.15em; color: rgba(255,255,255,0.7); margin: 0 0 0.5rem;">Live Demo</p>

# 🔗 Pipeline by Property Name

<p style="color: rgba(255,255,255,0.9); font-size: 0.75rem; margin: 0.5rem 0 0;">Add <code>ValueFromPipelineByPropertyName</code>, rebuild — pipe <code>Get-Greeting 'Alice'</code> into <code>Get-Greeting</code> with no explicit <code>-Name</code></p>

</div>

<div class="callout" style="width: 80%; margin: 0;">

**Then try:** piping a plain <code>[PSCustomObject]@{Name='Bob'}</code> — demonstrate any matching object works

</div>

</div>

---

# Module 04 — Done ✅

<ul class="checklist">
  <li><code>[ValidateNotNullOrEmpty]</code> and <code>[ValidateRange]</code> applied and verified</li>
  <li>Two named parameter sets with <code>DefaultParameterSetName</code> on <code>[Cmdlet]</code></li>
  <li><code>this.ParameterSetName</code> used to branch logic at runtime</li>
  <li><code>ValueFromPipelineByPropertyName</code> enables implicit pipeline binding</li>
  <li><code>Get-Help</code> SYNTAX section shows both parameter sets automatically</li>
</ul>

---

# Module 05: xUnit for Logic, Pester for Cmdlet Behavior

---
<style scoped>section{font-size:22px;}</style>

# The Testing Pyramid

<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.2rem; margin-top: 0.4rem;">

<div class="callout primary">

### xUnit (C#)
**Unit tests** — fast, isolated

Tests your C# logic directly

No PowerShell host required

`dotnet test` — milliseconds

</div>

<br />

<div class="callout quaternary">

### Pester (PS)
**Integration tests** — slower, real

Tests the PowerShell user experience

Imports the actual compiled DLL

`Invoke-Pester` — seconds

</div>

</div>

<p class="muted" style="margin-top: 0.8rem;">Many xUnit + fewer Pester = fast feedback loop with real-world confidence.</p>

---

# The Bridge: PS → C#

| Pester | xUnit |
|---|---|
| `Describe` / `It` blocks | `public class` / `[Fact]` method |
| `Should -Be` | `Assert.Equal(expected, actual)` |
| `Should -HaveCount` | `Assert.Equal(count, list.Count)` |
| `Should -Not -BeNullOrEmpty` | `Assert.NotNull(obj)` |
| `$result.Count` | `Assert.Collection(list, item => ...)` |
| `BeforeAll { Import-Module }` | Class constructor or `IClassFixture<T>` |

---

# Scaffold the Solution

```powershell
# Create a solution file — logical container for all projects
dotnet new sln -n PsStrongTypes

# Add the existing module project
dotnet sln add src/PsStrongTypes/PsStrongTypes.csproj

# Create the xUnit test project
dotnet new xunit -n PsStrongTypes.Tests -o tests/PsStrongTypes.Tests

# Add test project to solution
dotnet sln add tests/PsStrongTypes.Tests/PsStrongTypes.Tests.csproj

# Wire test project → module project
dotnet add tests/PsStrongTypes.Tests reference src/PsStrongTypes/PsStrongTypes.csproj
```

---

<!-- _class: no_background -->
<!-- _footer: "" -->

<div style="display: flex; align-items: center; justify-content: center; height: 100%; flex-direction: column; gap: 1rem;">

<div style="background: linear-gradient(41deg, rgba(0,174,239,0.9), rgba(43,45,120,0.9), rgba(146,39,143,0.9)); border-radius: 20px; padding: 2rem 3rem; text-align: center; width: 80%;">

<p style="font-size: 0.55rem; text-transform: uppercase; letter-spacing: 0.15em; color: rgba(255,255,255,0.7); margin: 0 0 0.5rem;">Live Demo</p>

# 🏗️ Scaffold Solution + Test Project

<p style="color: rgba(255,255,255,0.9); font-size: 0.75rem; margin: 0.5rem 0 0;">Run the five scaffold commands, then <code>dotnet build</code> and <code>dotnet test</code> — the default generated test should pass</p>

</div>

<div class="callout" style="width: 80%; margin: 0;">

**Point out:** <code>dotnet test</code> from the repo root now builds and tests every project in the solution in one command

</div>

</div>

---

<style scoped>section{font-size:26px;}</style>

# Unit Test the Output Model

```csharp
using PsStrongTypes;
using Xunit;

public class GreetingResultTests
{
    [Fact]
    public void Constructor_SetsNameAndMessage()
    {
        var result = new GreetingResult("Alice", "Hello, Alice!");

        Assert.Equal("Alice", result.Name);
        Assert.Equal("Hello, Alice!", result.Message);
    }

    [Fact]
    public void Constructor_SetsGeneratedAtToUtcNow()
    {
        var before = DateTimeOffset.UtcNow.AddSeconds(-1);
        var result = new GreetingResult("Alice", "Hello, Alice!");

        Assert.InRange(result.GeneratedAt, before, DateTimeOffset.UtcNow.AddSeconds(1));
    }
}
```

---

# Test the Cmdlet with PowerShell.Create()

```csharp
using System.Management.Automation;

public class GetGreetingCmdletTests
{
    [Fact]
    public void GetGreeting_WithName_ReturnsGreetingResult()
    {
        using var ps = PowerShell.Create();
        ps.AddCommand("Get-Greeting").AddParameter("Name", "Alice");

        var results = ps.Invoke<GreetingResult>();

        Assert.Single(results);
        Assert.Equal("Alice", results[0].Name);
    }
}
```

<p class="muted">Add the SDK to test project first: <code>dotnet add tests/PsStrongTypes.Tests package Microsoft.PowerShell.SDK</code></p>

---

# Why PowerShell.Create()?

<div class="callout gradient" style="margin-top: 0.3rem;">

### A Real Runspace, In-Process

`PowerShell.Create()` gives you a full PowerShell host inside your test.

Your cmdlet runs **exactly as it would in production** — parameter binding, validation, pipeline, all of it.

No subprocess. No file system. Millisecond feedback.

</div>

---

<!-- _class: no_background -->
<!-- _footer: "" -->

<div style="display: flex; align-items: center; justify-content: center; height: 100%; flex-direction: column; gap: 1rem;">

<div style="background: linear-gradient(41deg, rgba(0,174,239,0.9), rgba(43,45,120,0.9), rgba(146,39,143,0.9)); border-radius: 20px; padding: 2rem 3rem; text-align: center; width: 80%;">

<p style="font-size: 0.55rem; text-transform: uppercase; letter-spacing: 0.15em; color: rgba(255,255,255,0.7); margin: 0 0 0.5rem;">Live Demo</p>

# 🧪 Write and Run xUnit Tests

<p style="color: rgba(255,255,255,0.9); font-size: 0.75rem; margin: 0.5rem 0 0;">Write <code>GreetingResultTests</code> and <code>GetGreetingCmdletTests</code>, run <code>dotnet test</code> — watch all tests go green</p>

</div>

<div class="callout" style="width: 80%; margin: 0;">

**Show:** test names in the output — descriptive names are documentation that never goes stale

</div>

</div>

---

# Pester Integration Tests

```powershell
# tests/PsStrongTypes.Tests.ps1
BeforeAll {
    dotnet build "$PSScriptRoot/../src/PsStrongTypes" | Out-Null
    Import-Module "$PSScriptRoot/../src/PsStrongTypes/bin/Debug/net8.0/PsStrongTypes.dll" -Force
}

Describe "Get-Greeting" {
    It "returns a GreetingResult for a given name" {
        $result = Get-Greeting -Name "World"
        $result | Should -BeOfType [PsStrongTypes.GreetingResult]
        $result.Name | Should -Be "World"
    }
    It "accepts pipeline input by property name" {
        $result = [PSCustomObject]@{ Name = "Alice" } | Get-Greeting
        $result.Name | Should -Be "Alice"
    }
    It "rejects empty Name" {
        { Get-Greeting -Name "" } | Should -Throw
    }
}
```

---

<!-- _class: no_background -->
<!-- _footer: "" -->

<div style="display: flex; align-items: center; justify-content: center; height: 100%; flex-direction: column; gap: 1rem;">

<div style="background: linear-gradient(41deg, rgba(0,174,239,0.9), rgba(43,45,120,0.9), rgba(146,39,143,0.9)); border-radius: 20px; padding: 2rem 3rem; text-align: center; width: 80%;">

<p style="font-size: 0.55rem; text-transform: uppercase; letter-spacing: 0.15em; color: rgba(255,255,255,0.7); margin: 0 0 0.5rem;">Live Demo</p>

# 🟢 Run the Full Test Suite

<p style="color: rgba(255,255,255,0.9); font-size: 0.75rem; margin: 0.5rem 0 0;">Run <code>dotnet test</code> then <code>Invoke-Pester tests/PsStrongTypes.Tests.ps1 -Output Detailed</code></p>

</div>

<div class="callout" style="width: 80%; margin: 0;">

**Contrast:** xUnit output (fast, internal) vs Pester output (slower, user-experience focused) — both green

</div>

</div>

---

<style scoped>section{font-size:25px;}</style>

# What to Test Where

<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.2rem; margin-top: 0.4rem;">

<div class="callout secondary">

### xUnit
Output class construction

Property values and timestamps

Cmdlet output count and types

Business logic in helper classes

</div>
<br />
<div class="callout quaternary">

### Pester
Pipeline behavior end-to-end

Parameter validation error messages

`BeOfType` assertions on PS types

Behavior a script author would observe

</div>

</div>

---

# Module 05 — Done ✅

<ul class="checklist">
  <li>Solution file (<code>.sln</code>) with both projects registered</li>
  <li>xUnit <code>[Fact]</code> tests pass for <code>GreetingResult</code> properties</li>
  <li>Cmdlet invoked in-process with <code>PowerShell.Create()</code></li>
  <li>Pester integration tests import the DLL and assert on pipeline behavior</li>
  <li><code>dotnet test</code> and <code>Invoke-Pester</code> both exit green</li>
</ul>

---

# Module 06: Manifests, dotnet publish, and Gallery Deployment

---

# The Bridge: PS → .NET

| Concept | What It Means |
|---|---|
| `.psm1` is the module | Binary module **requires** a `.psd1` manifest to declare the `.dll` |
| `dotnet build` | Compiles the code |
| `dotnet publish` | Compiles **and** copies all runtime dependencies into an output folder |
| `Publish-Module` to PSGallery | Same command — swap `-Repository` for local or private feeds |

<p class="muted">Publish produces a complete, portable artifact — build output may rely on packages still in the NuGet cache.</p>

---

# Create the Module Manifest

```powershell
New-ModuleManifest `
  -Path src/PsStrongTypes/PsStrongTypes.psd1 `
  -RootModule PsStrongTypes.dll `
  -ModuleVersion '1.0.0' `
  -Author 'Workshop Attendee' `
  -Description 'Binary PS module from the From Script to Strong Types workshop' `
  -CmdletsToExport 'Get-Greeting' `
  -PowerShellVersion '7.0'

# Verify it
Test-ModuleManifest src/PsStrongTypes/PsStrongTypes.psd1
```

<p class="muted">The manifest is the shipping label on your module — without it, PowerShell Gallery and <code>Install-Module</code> can't handle your package.</p>

---

# Key Manifest Fields

```powershell
# Key fields in PsStrongTypes.psd1
RootModule        = 'PsStrongTypes.dll'    # ← points to the DLL
ModuleVersion     = '1.0.0'
GUID              = '<auto-generated>'
Author            = 'Workshop Attendee'
PowerShellVersion = '7.0'
CmdletsToExport   = @('Get-Greeting')      # ← explicit allowlist, NOT '*'
```

<div class="callout tertiary" style="margin-top: 0.6rem;">

⚠️ Never ship `CmdletsToExport = '*'` — it leaks internal types and breaks tab-completion performance.

</div>

---

<!-- _class: no_background -->
<!-- _footer: "" -->

<div style="display: flex; align-items: center; justify-content: center; height: 100%; flex-direction: column; gap: 1rem;">

<div style="background: linear-gradient(41deg, rgba(0,174,239,0.9), rgba(43,45,120,0.9), rgba(146,39,143,0.9)); border-radius: 20px; padding: 2rem 3rem; text-align: center; width: 80%;">

<p style="font-size: 0.55rem; text-transform: uppercase; letter-spacing: 0.15em; color: rgba(255,255,255,0.7); margin: 0 0 0.5rem;">Live Demo</p>

# 📋 Create and Validate the Manifest

<p style="color: rgba(255,255,255,0.9); font-size: 0.75rem; margin: 0.5rem 0 0;">Run <code>New-ModuleManifest</code>, open the generated <code>.psd1</code>, then run <code>Test-ModuleManifest</code></p>

</div>

<div class="callout" style="width: 80%; margin: 0;">

**Walk through:** RootModule, ModuleVersion, CmdletsToExport — explain what each field unlocks for consumers

</div>

</div>

---

# dotnet publish

```powershell
# Compile + bundle all runtime dependencies
dotnet publish src/PsStrongTypes -c Release -o publish/PsStrongTypes

# Copy the manifest into the publish output
Copy-Item src/PsStrongTypes/PsStrongTypes.psd1 publish/PsStrongTypes/

# Verify the folder is self-contained
Import-Module ./publish/PsStrongTypes/PsStrongTypes.psd1 -Force
Get-Command -Module PsStrongTypes
```

---

# dotnet publish


<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-top: 0.6rem;">

<div class="callout secondary">

### `dotnet build`
Compiles your code.
Dependencies stay in the NuGet cache.

</div>
<br />
<div class="callout primary">

### `dotnet publish`
Compiles **+** copies every dependency.
Output folder is fully self-contained.

</div>

</div>

---

<!-- _class: no_background -->
<!-- _footer: "" -->

<div style="display: flex; align-items: center; justify-content: center; height: 100%; flex-direction: column; gap: 1rem;">

<div style="background: linear-gradient(41deg, rgba(0,174,239,0.9), rgba(43,45,120,0.9), rgba(146,39,143,0.9)); border-radius: 20px; padding: 2rem 3rem; text-align: center; width: 80%;">

<p style="font-size: 0.55rem; text-transform: uppercase; letter-spacing: 0.15em; color: rgba(255,255,255,0.7); margin: 0 0 0.5rem;">Live Demo</p>

# 📦 dotnet publish + Import via .psd1

<p style="color: rgba(255,255,255,0.9); font-size: 0.75rem; margin: 0.5rem 0 0;">Run <code>dotnet publish</code>, inspect the output folder, copy the <code>.psd1</code>, then <code>Import-Module</code> via the manifest</p>

</div>

<div class="callout" style="width: 80%; margin: 0;">

**Point out:** any <code>System.Management.Automation.dll</code> in the publish folder — explain it's a build-time reference, not a runtime copy

</div>

</div>

---

# Register a Local Gallery

```powershell
# Create the gallery folder
New-Item -ItemType Directory -Path ./local-gallery

# Register it as a trusted PS repository
Register-PSRepository `
  -Name LocalGallery `
  -SourceLocation (Resolve-Path ./local-gallery).Path `
  -InstallationPolicy Trusted

# Publish the module
Publish-Module -Path ./publish/PsStrongTypes -Repository LocalGallery

# Confirm the .nupkg was created
Get-ChildItem ./local-gallery
```

<p class="muted">A local gallery is just a folder with a NuGet index — identical to PSGallery from the module's perspective.</p>

---

<!-- _class: no_background -->
<!-- _footer: "" -->

<div style="display: flex; align-items: center; justify-content: center; height: 100%; flex-direction: column; gap: 1rem;">

<div style="background: linear-gradient(41deg, rgba(0,174,239,0.9), rgba(43,45,120,0.9), rgba(146,39,143,0.9)); border-radius: 20px; padding: 2rem 3rem; text-align: center; width: 80%;">

<p style="font-size: 0.55rem; text-transform: uppercase; letter-spacing: 0.15em; color: rgba(255,255,255,0.7); margin: 0 0 0.5rem;">Live Demo</p>

# 🗂️ Register Gallery + Publish

<p style="color: rgba(255,255,255,0.9); font-size: 0.75rem; margin: 0.5rem 0 0;">Create the folder, register, publish — run <code>Get-ChildItem ./local-gallery</code> and show the <code>.nupkg</code> file</p>

</div>

<div class="callout" style="width: 80%; margin: 0;">

**Ask:** What single change would target PSGallery instead? (Answer: swap <code>-Repository LocalGallery</code> and add <code>-NuGetApiKey</code>)

</div>

</div>

---

# Install in a Clean Session

```powershell
# Install from local gallery
Install-Module -Name PsStrongTypes -Repository LocalGallery -Scope CurrentUser

# Open a NEW pwsh terminal — no Import-Module needed
Get-Module PsStrongTypes -ListAvailable
# PsStrongTypes  1.0.0  ...

Import-Module PsStrongTypes
Get-Greeting -Name 'Shipped!'
# Name     Message           GeneratedAt
# ----     -------           -----------
# Shipped! Hello, Shipped!   2026-...
```

---

<!-- _class: no_background -->
<!-- _footer: "" -->

<div style="display: flex; align-items: center; justify-content: center; height: 100%; flex-direction: column; gap: 1rem;">

<div style="background: linear-gradient(41deg, rgba(0,174,239,0.9), rgba(43,45,120,0.9), rgba(146,39,143,0.9)); border-radius: 20px; padding: 2rem 3rem; text-align: center; width: 80%;">

<p style="font-size: 0.55rem; text-transform: uppercase; letter-spacing: 0.15em; color: rgba(255,255,255,0.7); margin: 0 0 0.5rem;">Live Demo — Workshop Payoff</p>

# 🚀 Install and Use from the Gallery

<p style="color: rgba(255,255,255,0.9); font-size: 0.75rem; margin: 0.5rem 0 0;">Open a <em>fresh</em> pwsh terminal, run <code>Install-Module</code>, then <code>Get-Greeting -Name 'Shipped!'</code></p>

</div>

<div class="callout" style="width: 80%; margin: 0;">

**This is the payoff moment** — the module installs and works exactly like anything from PSGallery

</div>

</div>

---

# The CI Build Script

```powershell
#!/usr/bin/env pwsh
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Write-Host "==> Build"   -ForegroundColor Cyan
dotnet build -c Release

Write-Host "==> Test"    -ForegroundColor Cyan
dotnet test --no-build -c Release

Write-Host "==> Publish" -ForegroundColor Cyan
dotnet publish src/PsStrongTypes -c Release -o publish/PsStrongTypes
Copy-Item src/PsStrongTypes/PsStrongTypes.psd1 publish/PsStrongTypes/ -Force

if ($env:PUBLISH -eq 'true') {
    Write-Host "==> Publish-Module" -ForegroundColor Cyan
    Publish-Module -Path ./publish/PsStrongTypes -Repository LocalGallery
}
```

---

<style scoped>section{font-size:20px;}</style>


# CI in One Go

<div style="display: grid; grid-template-columns: 1fr 1fr 1fr 1fr; gap: 0.8rem; margin-top: 0.5rem;">


- Compile
    -  `dotnet build`
- Verify
    - `dotnet test`
- Bundle
    - `dotnet publish`
-  Ship 
    -   `Publish-Module`

<br />
<br />

</div>

<blockquote style="margin-top: 0.8rem;">
The commands you ran by hand today are all a CI pipeline needs.
</blockquote>

---

# Module 06 — Done ✅

<ul class="checklist">
  <li><code>.psd1</code> manifest created with correct <code>RootModule</code>, version, and <code>CmdletsToExport</code></li>
  <li><code>dotnet publish</code> produces a self-contained output folder</li>
  <li>Local <code>PSRepository</code> registered and module published</li>
  <li><code>Install-Module</code> from local gallery works in a fresh session</li>
  <li><code>build.ps1</code> encodes the full build → test → publish pipeline</li>
</ul>

---

<!-- _class: title -->
<!-- _footer: "" -->
<!-- _header: "" -->

# Workshop Complete 🎉

## From Script to Strong Types

<p class="name">You built a binary PowerShell module — from scaffold to published package.</p>
<p class="handle">PowerShell + DevOps Global Summit 2026</p>
