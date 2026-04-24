using System.Net.Http;
using System.Threading.Tasks;
using System.Management.Automation;

[Cmdlet(VerbsCommon.Get, "OnlineGreeting")]
public class GetOnlineGreetingCmdlet : PSCmdlet
{
    [Parameter(Position = 0)]
    public string Name { get; set; } = "PowerShell";

    [Parameter(Position = 1)]
    public string Salutation { get; set; } = "Welcome";

    protected override void ProcessRecord()
    {
        var url = $"http://localhost:5107/hello/{Name}/{Salutation}";

        using var client = new HttpClient();

        try
        {
            var response = client.GetAsync(url).GetAwaiter().GetResult();
            response.EnsureSuccessStatusCode();

            var result = response.Content.ReadAsStringAsync().GetAwaiter().GetResult();

            WriteObject(result);
        }
        catch (Exception ex)
        {
            WriteError(new ErrorRecord(ex, "ApiCallFailed", ErrorCategory.ConnectionError, url));
        }
    }
}