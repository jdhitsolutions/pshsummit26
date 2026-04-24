
namespace Greet;

public class Greeting
{
    public string GetGreetingByName(string name)
    {
        return $"Hello, {name}";
    }

    public string GetGreetingWithSalutationByName(string salutation, string name)
    {
        return $"{salutation}, {name}";
    }
}