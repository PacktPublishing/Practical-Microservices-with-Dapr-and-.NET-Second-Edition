using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.Threading;
using System.Threading.Tasks;
using Yarp.ReverseProxy.Configuration;

namespace Yarp.Sample;

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
            if (_exp.IsMatch(origAddress))
            {
                // Get the name of the env variable from the destination and lookup value
                var lookup = _exp.Matches(origAddress)[0].Groups[1].Value;
                var newAddress = Environment.GetEnvironmentVariable(lookup);

                if (string.IsNullOrWhiteSpace(newAddress))
                {
                    throw new ArgumentException($"Configuration Filter Error: Substitution for '{lookup}' in cluster '{d.Key}' not found as an environment variable.");
                }

                // using c# 9 "with" to clone and initialize a new record
                var modifiedDest = d.Value with { Address = newAddress };
                newDests.Add(d.Key, modifiedDest);
            }
            else
            {
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