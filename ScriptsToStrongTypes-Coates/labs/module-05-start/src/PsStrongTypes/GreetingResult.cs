using System;

namespace PsStrongTypes;

public class GreetingResult
{
    public string Name { get; }
    public string Message { get; }
    public DateTimeOffset GeneratedAt { get; }

    public GreetingResult(string name, string message)
    {
        Name = name;
        Message = message;
        GeneratedAt = DateTimeOffset.UtcNow;
    }
}
