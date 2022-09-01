using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.Threading;
using System.Threading.Tasks;
using Yarp.ReverseProxy.Configuration;

public class CustomConfigFilter : IProxyConfigFilter
{
    // Matches {{env_var_name}}
    private readonly Regex _exp = new("\\{\\{(\\w+)\\}\\}");

    // This sample looks at the destination addresses and any of the form {{key}} will be modified, looking up the key
    // as an environment variable. This is useful when hosted in Azure etc, as it enables a simple way to replace
    // destination addresses via the management console
    public ValueTask<ClusterConfig> ConfigureClusterAsync(ClusterConfig origCluster, CancellationToken cancel)
    {
        // Each cluster has a dictionary of destinations, which is read-only, so we'll create a new one with our updates 
        var newDests = new Dictionary<string, DestinationConfig>(StringComparer.OrdinalIgnoreCase);

        foreach (var d in origCluster.Destinations)
        {
            var origAddress = d.Value.Address;
            //replace all regex matches in the address with the environment variable value  
            var newAddress = _exp.Replace(origAddress, match => Environment.GetEnvironmentVariable(match.Groups[1].Value));
            if (origAddress != newAddress)
            {
                // If the address has changed, we'll create a new destination with the new address
                newDests.Add(d.Key, new DestinationConfig { Address = newAddress });
            }
            else
            {
                // If the address hasn't changed, we'll just return the original destination
                newDests.Add(d.Key, d.Value);
            }
        }

        return new ValueTask<ClusterConfig>(origCluster with { Destinations = newDests });
    }

    public ValueTask<RouteConfig> ConfigureRouteAsync(RouteConfig route, ClusterConfig cluster, CancellationToken cancel)
    {
        // Example: do not let config based routes take priority over code based routes.
        // Lower numbers are higher priority. Code routes default to 0.
        if (route.Order.HasValue && route.Order.Value < 1)
        {
            return new ValueTask<RouteConfig>(route with { Order = 1 });
        }

        return new ValueTask<RouteConfig>(route);
    }
}