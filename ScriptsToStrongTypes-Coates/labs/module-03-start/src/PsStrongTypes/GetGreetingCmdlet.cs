using System.Management.Automation;

namespace PsStrongTypes;

[Cmdlet(VerbsCommon.Get, "Greeting")]
public class GetGreetingCmdlet : PSCmdlet
{
    [Parameter(Mandatory = true)]
    public string Name { get; set; } = string.Empty;

    protected override void BeginProcessing()
    {
        WriteVerbose("[BeginProcessing] called");
    }

    protected override void ProcessRecord()
    {
        WriteVerbose("[ProcessRecord] called");
        WriteObject($"Hello, {Name}!");
    }

    protected override void EndProcessing()
    {
        WriteVerbose("[EndProcessing] called");
    }
}
