using System.Management.Automation;

namespace PsStrongTypes;

[Cmdlet(VerbsCommon.Get, "Greeting")]
[OutputType(typeof(GreetingResult))]
public class GetGreetingCmdlet : PSCmdlet
{
    [Parameter(Mandatory = true)]
    public string Name { get; set; } = string.Empty;

    protected override void ProcessRecord()
    {
        WriteObject(new GreetingResult(Name, $"Hello, {Name}!"));
    }
}
