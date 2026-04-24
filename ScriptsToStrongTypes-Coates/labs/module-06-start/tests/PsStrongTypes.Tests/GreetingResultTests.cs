using System;
using PsStrongTypes;
using Xunit;

namespace PsStrongTypes.Tests;

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
        var after = DateTimeOffset.UtcNow.AddSeconds(1);

        Assert.InRange(result.GeneratedAt, before, after);
    }
}
