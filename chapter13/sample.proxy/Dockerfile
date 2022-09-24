FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

COPY ["sample.proxy/sample.proxy.csproj", "sample.proxy/"]
RUN dotnet restore "sample.proxy/sample.proxy.csproj"
COPY . .
WORKDIR "/src/sample.proxy"
RUN dotnet publish "sample.proxy.csproj" -c Release -o /app/publish --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "sample.proxy.dll"]

# workaround to https://github.com/dotnet/dotnet-docker/issues/3274
ARG Logging__Console__FormatterName=""
ENV Logging__Console__FormatterName=$Logging__Console__FormatterName

ARG BUILD_DATE
ARG BUILD_VERSION
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.version=$BUILD_VERSION
LABEL org.label-schema.name="Practical Microservices with Dapr and .NET - sample: proxy with YARP"
LABEL org.label-schema.description=".NET 6.0, Yarp 1.1 and Dapr 1.8"
LABEL org.label-schema.schema-version="1.0"
