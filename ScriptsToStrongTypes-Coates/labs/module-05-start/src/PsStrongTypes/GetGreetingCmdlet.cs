using System.Management.Automation;

namespace PsStrongTypes;

[Cmdlet(VerbsCommon.Get, "Greeting", DefaultParameterSetName = "ByName")]
[OutputType(typeof(GreetingResult))]
public class GetGreetingCmdlet : PSCmdlet
{
    [ValidateNotNullOrEmpty]
    [Parameter(Mandatory = true, ParameterSetName = "ByName",
               ValueFromPipelineByPropertyName = true)]
    public string Name { get; set; } = string.Empty;

    [ValidateNotNullOrEmpty]
    [Parameter(Mandatory = true, ParameterSetName = "ByTemplate")]
    public string Template { get; set; } = string.Empty;

    [ValidateRange(1, 100)]
    [Parameter]
    public int Count { get; set; } = 1;

    protected override void ProcessRecord()
    {
        for (int i = 0; i < Count; i++)
        {
            var result = ParameterSetName == "ByName"
                ? new GreetingResult(Name, $"Hello, {Name}!")
                : new GreetingResult("(template)", Template);

            WriteObject(result);
        }
    }
}
