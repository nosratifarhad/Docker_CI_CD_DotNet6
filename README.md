
# create docker file and build image and create ci/cd

### After installing Docker
After installing Docker, you should create a Dockerfile without an extension in the root path of your project.

Now, to build an image from your project, you should enter Docker commands in it. Here is an example:

```docker
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["TestWebApplication.csproj","API/"]
RUN dotnet restore "API/TestWebApplication.csproj"
COPY . .
#WORKDIR "/src/API/"
RUN dotnet build "TestWebApplication.csproj" -c Release -o /app/build

FROM build AS publish 
RUN dotnet build "TestWebApplication.csproj" -c Release -o /app/publish

FROM base AS final 
WORKDIR /app/build
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet","TestWebApplication.dll"]
```


### Part 1. Base image configuration:

```docker
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
```
The first part of the Dockerfile specifies the base image for the final image that will be created. In this case, it is the “mcr.microsoft.com/dotnet/aspnet:6.0” image. The WORKDIR command sets the working directory for the subsequent commands to be executed in. The EXPOSE command specifies the network ports that the container will listen on at runtime.

### Part 2. Build image configuration:

```docker
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["TestWebApplication.csproj","API/"]
RUN dotnet restore "API/TestWebApplication.csproj"
COPY . .
#WORKDIR "/src/API/"
RUN dotnet build "TestWebApplication.csproj" -c Release -o /app/build
```
