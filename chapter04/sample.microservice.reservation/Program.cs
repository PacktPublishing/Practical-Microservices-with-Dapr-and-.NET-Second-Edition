var builder = WebApplication.CreateBuilder(args);

var jsonOpt = new JsonSerializerOptions()
{
    PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
    PropertyNameCaseInsensitive = true,
};

// Add services to the container.
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddDaprClient(opt => opt.UseJsonSerializationOptions(jsonOpt));

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

//app.UseHttpsRedirection();

app.MapPost("/reserve", ([FromServices] DaprClient client, [FromBody] Item item) =>
{
    app.Logger.LogInformation("Enter Reservation");

    /* a specific type is used in sample.microservice.reservation and not
    reused the class in sample.microservice.order with the same signature: 
    this is just to not introduce DTO and to suggest that it might be a good idea
    having each service separating the type for persisting store */
    Item storedItem;
    storedItem = new Item();
    storedItem.SKU = item.SKU;
    storedItem.Quantity -= item.Quantity;

    app.Logger.LogInformation($"Reservation of {storedItem.SKU} is now {storedItem.Quantity}");

    return Results.Ok(storedItem);
});

app.Run();

public class Item
{
    public string? SKU {get; set;}

    public int Quantity { get; set; }
}
