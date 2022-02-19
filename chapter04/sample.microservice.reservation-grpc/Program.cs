var builder = WebApplication.CreateBuilder(args);

var jsonOpt = new JsonSerializerOptions()
{
    PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
    PropertyNameCaseInsensitive = true,
};

// Add services to the container.
builder.Services.AddGrpc();
builder.Services.AddDaprClient(opt => opt.UseJsonSerializationOptions(jsonOpt));

var app = builder.Build();

//app.UseHttpsRedirection();

app.MapGrpcService<ReservationService>();

app.MapGet("/", () => "Communication with gRPC endpoints must be made through a gRPC client. To learn how to create a client, visit: https://go.microsoft.com/fwlink/?linkid=2086909");

app.Run();