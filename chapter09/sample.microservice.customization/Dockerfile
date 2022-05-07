FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

COPY ["sample.microservice.common/sample.microservice.common.csproj", "sample.microservice.common/"]
COPY ["sample.microservice.dto.customization/sample.microservice.dto.customization.csproj", "sample.microservice.dto.customization/"]
COPY ["sample.microservice.dto.order/sample.microservice.dto.order.csproj", "sample.microservice.dto.order/"]
COPY ["sample.microservice.customization/sample.microservice.customization.csproj", "sample.microservice.customization/"]
RUN dotnet restore "sample.microservice.common/sample.microservice.common.csproj"
RUN dotnet restore "sample.microservice.dto.customization/sample.microservice.dto.customization.csproj"
RUN dotnet restore "sample.microservice.dto.order/sample.microservice.dto.order.csproj"
RUN dotnet restore "sample.microservice.customization/sample.microservice.customization.csproj"
COPY . .
WORKDIR "/src/sample.microservice.customization"
RUN dotnet publish "sample.microservice.customization.csproj" -c Release -o /app/publish --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "sample.microservice.customization.dll"]

# workaround to https://github.com/dotnet/dotnet-docker/issues/3274
ARG Logging__Console__FormatterName=""
ENV Logging__Console__FormatterName=$Logging__Console__FormatterName

ARG BUILD_DATE
ARG BUILD_VERSION
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.version=$BUILD_VERSION
LABEL org.label-schema.name="Practical Microservices with Dapr and .NET - sample: customization microservice"
LABEL org.label-schema.description=".NET 6.0 and Dapr 1.7"
LABEL org.label-schema.schema-version="1.0"
