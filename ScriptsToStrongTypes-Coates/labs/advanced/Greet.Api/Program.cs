using Greet;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// GET /hello/ryan
app.MapGet("/hello/{name}", (string name) =>
{
    var greeting = new Greeting();
    return Results.Ok(greeting.GetGreetingByName(name));
});

// GET /hello/ryan/hi
app.MapGet("/hello/{name}/{salutation}", (string name, string salutation) =>
{
    var greeting = new Greeting();
    return Results.Ok(greeting.GetGreetingWithSalutationByName(salutation, name));
});

app.Run();