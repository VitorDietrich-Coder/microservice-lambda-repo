# =========================
# STAGE 1 - BUILD
# =========================
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copia TODOS os csproj necessários (mantendo paths relativos)
COPY src/Users.Events.Consumer/Users.Events.Consumer.csproj src/Users.Events.Consumer/
COPY src/Users.Events.Contracts/Users.Events.Contracts.csproj src/Users.Events.Contracts/

# Restore (agora funciona)
RUN dotnet restore src/Users.Events.Consumer/Users.Events.Consumer.csproj

# Copia o restante do código
COPY src/Users.Events.Consumer/ src/Users.Events.Consumer/
COPY src/Users.Events.Contracts/ src/Users.Events.Contracts/

# Publish
RUN dotnet publish src/Users.Events.Consumer/Users.Events.Consumer.csproj \
    -c Release \
    -o /app/publish \
    /p:UseAppHost=false

# =========================
# STAGE 2 - LAMBDA RUNTIME
# =========================
FROM public.ecr.aws/lambda/dotnet:8
WORKDIR /var/task

COPY --from=build /app/publish .

CMD ["Users.Events.Consumer::Users.Events.Consumer.Function::FunctionHandler"]
