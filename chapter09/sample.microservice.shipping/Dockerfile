FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

COPY ["sample.microservice.common/sample.microservice.common.csproj", "sample.microservice.common/"]
COPY ["sample.microservice.dto.shipping/sample.microservice.dto.shipping.csproj", "sample.microservice.dto.shipping/"]
COPY ["sample.microservice.shipping/sample.microservice.shipping.csproj", "sample.microservice.shipping/"]
RUN dotnet restore "sample.microservice.common/sample.microservice.common.csproj"
RUN dotnet restore "sample.microservice.dto.shipping/sample.microservice.dto.shipping.csproj"
RUN dotnet restore "sample.microservice.shipping/sample.microservice.shipping.csproj"
COPY . .
WORKDIR "/src/sample.microservice.shipping"
RUN dotnet publish "sample.microservice.shipping.csproj" -c Release -o /app/publish --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "sample.microservice.shipping.dll"]

# workaround to https://github.com/dotnet/dotnet-docker/issues/3274
ARG Logging__Console__FormatterName=""
ENV Logging__Console__FormatterName=$Logging__Console__FormatterName

ARG BUILD_DATE
ARG BUILD_VERSION
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.version=$BUILD_VERSION
LABEL org.label-schema.description="Practical Microservices with Dapr and .NET sample, Shipping microservice"
LABEL org.label-schema.description=".NET 6.0 and Dapr 1.8"
LABEL org.label-schema.schema-version="1.0"