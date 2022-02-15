var builder = WebApplication.CreateBuilder(args);

var jsonOpt = new JsonSerializerOptions()
{
    PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
    PropertyNameCaseInsensitive = true,
};

// Add services to the container.
builder.Services.AddDaprClient(opt => opt.UseJsonSerializationOptions(jsonOpt));

var app = builder.Build();

//app.UseHttpsRedirection();

app.MapPost("/reserve", async ([FromServices] DaprClient client, HttpContext context) =>
{
    app.Logger.LogInformation("Enter Reservation");

    // DaprClient could be used to interact with State store etc..
    //var client = context.RequestServices.GetRequiredService<DaprClient>();
    var item = await JsonSerializer.DeserializeAsync<Item>(context.Request.Body, jsonOpt);

    // your business logic should be here

    /* a specific type is used in sample.microservice.reservation and not
    reused the class in sample.microservice.order with the same signature: 
    this is just to not introduce DTO and to suggest that it might be a good idea
    having each service separating the type for persisting store */
    Item storedItem;
    // from store? state?
    storedItem = new Item();
    storedItem.SKU = item.SKU;
    storedItem.Quantity -= item.Quantity;

    app.Logger.LogInformation($"Reservation of {storedItem.SKU} is now {storedItem.Quantity}");

    context.Response.ContentType = "application/json";
    await JsonSerializer.SerializeAsync(context.Response.Body, storedItem, jsonOpt);
});

app.Run();