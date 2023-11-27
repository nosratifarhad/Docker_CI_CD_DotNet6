FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["/src/TestWebApplication.csproj","API/"]
RUN dotnet restore "API/TestWebApplication.csproj"
COPY . .
RUN dotnet build "src/TestWebApplication.csproj" -c Release -o /app/build

FROM build AS publish 
RUN dotnet build "src/TestWebApplication.csproj" -c Release -o /app/publish

FROM base AS final 
WORKDIR /app/build
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet","TestWebApplication.dll"]

