using System.Management.Automation;

namespace PsGreet;

[Cmdlet(VerbsCommon.Get, "Greeting")]
public class Class1 : PSCmdlet
{
    protected override void ProcessRecord()
    {
        var greeting = new Greet.Greeting();
        var result = greeting.GetGreetingByName("PowerShell");
        WriteObject(result);
    }

}
