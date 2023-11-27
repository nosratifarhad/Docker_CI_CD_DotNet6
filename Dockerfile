FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["TestCors.csproj","API/"]
RUN dotnet restore "API/TestCors.csproj"
COPY . .
#WORKDIR "/src/API/"
RUN dotnet build "TestCors.csproj" -c Release -o /app/build

FROM build AS publish 
RUN dotnet build "TestCors.csproj" -c Release -o /app/publish

FROM base AS final 
WORKDIR /app/build
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet","TestCors.dll"]

#FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
#WORKDIR /app
#EXPOSE 80
#
#FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
#WORKDIR /src
#COPY ["byebikari.RecruitmentAgency.Api.csproj","./"]
#RUN dotnet restore "./byebikari.RecruitmentAgency.Api.csproj"
#COPY . .
#RUN dotnet build "byebikari.RecruitmentAgency.Api.csproj" -c Release -o /app
#
#FROM build AS publish
#RUN dotnet publish "byebikari.RecruitmentAgency.Api.csproj" -c Release -o /app
#
#FROM base AS final
#WORKDIR /app
#COPY --from=publish /app .
#ENTRYPOINT ["dotnet", "byebikari.RecruitmentAgency.Api.dll"]