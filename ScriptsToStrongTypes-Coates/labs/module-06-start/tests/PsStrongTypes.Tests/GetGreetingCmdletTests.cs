using System.Management.Automation;
using System.Management.Automation.Runspaces;
using PsStrongTypes;
using Xunit;

namespace PsStrongTypes.Tests;

public class GetGreetingCmdletTests
{
    private static PowerShell CreatePowerShell()
    {
        var iss = InitialSessionState.CreateDefault2();
        iss.Commands.Add(new SessionStateCmdletEntry(
            "Get-Greeting",
            typeof(GetGreetingCmdlet),
            null));

        var runspace = RunspaceFactory.CreateRunspace(iss);
        runspace.Open();

        var ps = PowerShell.Create();
        ps.Runspace = runspace;
        return ps;
    }

    [Fact]
    public void GetGreeting_WithName_ReturnsGreetingResult()
    {
        using var ps = CreatePowerShell();
        ps.AddCommand("Get-Greeting").AddParameter("Name", "Alice");

        var results = ps.Invoke<GreetingResult>();

        Assert.Single(results);
        Assert.Equal("Alice", results[0].Name);
        Assert.Contains("Alice", results[0].Message);
    }

    [Fact]
    public void GetGreeting_WithCount3_ReturnsThreeResults()
    {
        using var ps = CreatePowerShell();
        ps.AddCommand("Get-Greeting")
          .AddParameter("Name", "World")
          .AddParameter("Count", 3);

        var results = ps.Invoke<GreetingResult>();

        Assert.Equal(3, results.Count);
    }
}
