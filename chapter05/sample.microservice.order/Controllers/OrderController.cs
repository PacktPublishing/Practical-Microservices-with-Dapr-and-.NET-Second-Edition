namespace sample.microservice.order.Controllers;

[ApiController]
public class OrderController : ControllerBase
{
    public const string StoreName = "orderstore";

    /// <summary>
    /// Method for submitting a new order.
    /// </summary>
    /// <param name="order">Order info.</param>
    /// <param name="daprClient">State client to interact with Dapr runtime.</param>
    /// <returns>A <see cref="Task{TResult}"/> representing the result of the asynchronous operation.</returns>
    [HttpPost("order")]
    public async Task<ActionResult<Guid>> SubmitOrder(Order order, [FromServices] DaprClient daprClient)
    {
        Console.WriteLine("Enter submit order");
        
        order.Id = Guid.NewGuid();

        var state = await daprClient.GetStateEntryAsync<OrderState>(StoreName, order.Id.ToString());
        state.Value ??= new OrderState() { CreatedOn = DateTime.UtcNow, UpdatedOn = DateTime.UtcNow, Order = order };
        
        foreach (var item in order.Items)
        {
            var data = new Item() { SKU = item.ProductCode, Quantity = item.Quantity };
            var result = await daprClient.InvokeMethodAsync<Item, Item>(HttpMethod.Post, "reservation-service", "reserve", data);
        }
        
        await state.SaveAsync();

        Console.WriteLine($"Submitted order {order.Id}");

        return order.Id;
    }

    /// <summary>
    /// Method for retrieving an order.
    /// </summary>
    /// <param name="orderid">Order Id state info.</param>
    /// <returns>Order information</returns>
    [HttpGet("order/{state}")]
    public ActionResult<Order> Get([FromState(StoreName)]StateEntry<OrderState> state)
    {
        Console.WriteLine("Enter order retrieval");
        
        if (state.Value == null)
        {
            return this.NotFound();
        }
        var result = state.Value.Order;

        Console.WriteLine($"Retrieved order {result.Id} ");

        return result;
    }
}
