FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

COPY ["sample.microservice.reservationactor.interfaces/sample.microservice.reservationactor.interfaces.csproj", "sample.microservice.reservationactor.interfaces/"]
COPY ["sample.microservice.reservationactor.service/sample.microservice.reservationactor.service.csproj", "sample.microservice.reservationactor.service/"]
RUN dotnet restore "sample.microservice.reservationactor.interfaces/sample.microservice.reservationactor.interfaces.csproj"
RUN dotnet restore "sample.microservice.reservationactor.service/sample.microservice.reservationactor.service.csproj"
COPY . .
WORKDIR "/src/sample.microservice.reservationactor.service"
RUN dotnet publish "sample.microservice.reservationactor.service.csproj" -c Release -o /app/publish --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "sample.microservice.reservationactor.service.dll"]

# workaround to https://github.com/dotnet/dotnet-docker/issues/3274
ARG Logging__Console__FormatterName=""
ENV Logging__Console__FormatterName=$Logging__Console__FormatterName

ARG BUILD_DATE
ARG BUILD_VERSION
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.version=$BUILD_VERSION
LABEL org.label-schema.name="Practical Microservices with Dapr and .NET - sample: reservationactor microservice"
LABEL org.label-schema.description=".NET 6.0 and Dapr 1.8"
LABEL org.label-schema.schema-version="1.0"
