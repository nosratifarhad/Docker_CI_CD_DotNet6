
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
COPY ["/src/TestWebApplication.csproj","API/"]
RUN dotnet restore "API/TestWebApplication.csproj"
COPY . .
RUN dotnet build "src/TestWebApplication.csproj" -c Release -o /app/build
```

The second part of the Dockerfile specifies the build image, which will be used to build the application. It is based on the “mcr.microsoft.com/dotnet/sdk:6.0” image. The WORKDIR command sets the working directory to "/src" within the container. The COPY commands copy the necessary files to the container. The RUN command runs the "dotnet restore" command to restore the dependencies required by the application. The subsequent COPY . . command copies all the remaining files to the container. Finally, the RUN command builds the application using the "dotnet build" command.

### Part 3. Publish image configuration:

```docker
FROM build AS publish 
RUN dotnet build "src/TestWebApplication.csproj" -c Release -o /app/publish
```

The third part of the Dockerfile specifies the publish image, which will be used to publish the application. It is based on the previously created build image. The RUN command publishes the application using the "dotnet publish" command.

### Part 4. Final image configuration:

```docker
FROM base AS final 
WORKDIR /app/build
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet","TestWebApplication.dll"]
```

The final part of the Dockerfile specifies the final image that will be created. It is based on the previously created base image. The WORKDIR command sets the working directory to "/app". The COPY command copies the published application from the previous image to the current image. Finally, the ENTRYPOINT command specifies the command that will be run when a container is started from the image, in this case, "dotnet API.dll".


### Part 4. Now, for the image to be built, you need to execute the following commands in the command line in order.

### Note: Perhaps it might be a bit time-consuming.


```cmd
docker build -t dockerfile image-name .
```

![My Remote Image](https://github.com/nosratifarhad/Docker_CI_CD_DotNet6/blob/main/docs/Annotation1.jpg)


Now, to run the created image, execute the following command.

```cmd
docker run -d -p 5000:80 image-name
```
