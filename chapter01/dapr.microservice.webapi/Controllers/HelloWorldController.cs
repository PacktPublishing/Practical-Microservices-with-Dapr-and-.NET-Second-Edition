using Microsoft.AspNetCore.Mvc;
using Dapr;

namespace dapr.microservice.webapi.Controllers;

[ApiController]
[Route("[controller]")]
public class HelloController : ControllerBase
{
    private readonly ILogger<HelloController> _logger;

    public HelloController(ILogger<HelloController> logger)
    {
        _logger = logger;
    }

    [HttpGet()]
    public ActionResult<string> Get()
    {
        Console.WriteLine("Hello, World.");
        return "Hello, World";
    }
}
