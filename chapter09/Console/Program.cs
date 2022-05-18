var connectionString = "# REPLACE";
var eventHubName = "# REPLACE";

Console.WriteLine("Started sender");

var rnd = new System.Random();
var cookies = new List<string>{"bussola1", "bussola8", "rockiecookie", "crazycookie", "cookie43"};
        
// Create a producer client that you can use to send events to an event hub
await using (var producerClient = new EventHubProducerClient(connectionString, eventHubName))
{
    do
    {
        // Create a batch of events 
        using EventDataBatch eventBatch = await producerClient.CreateBatchAsync();

        for (int i = 0; i < 3; i++)
        {
            var item = new  
            {  
                SKU = cookies[rnd.Next(cookies.Count)],  
                Quantity = 1 
            }; 

                var message = JsonSerializer.Serialize(item);
            // Add events to the batch. An event is a represented by a collection of bytes and metadata. 
            eventBatch.TryAdd(new EventData(Encoding.UTF8.GetBytes(message)));
        }

        // Use the producer client to send the batch of events to the event hub
        await producerClient.SendAsync(eventBatch);

        System.Threading.Thread.Sleep(rnd.Next(500,5000));
    } while (true);
}
