# =========================
# STAGE 1 - BUILD
# =========================
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# (Opcional) NuGet config
COPY nuget.config ./

# Copia os csproj (mantendo hierarquia)
COPY src/Users.Events.Consumer/Users.Events.Consumer.csproj Users.Events.Consumer/
COPY src/Users.Events.Contracts/Users.Events.Contracts.csproj Users.Events.Contracts/

# ❗ RESTORE CORRETO (SEM ./src)
RUN dotnet restore Users.Events.Consumer/Users.Events.Consumer.csproj

# Copia o restante do código
COPY src/Users.Events.Consumer/ Users.Events.Consumer/
COPY src/Users.Events.Contracts/ Users.Events.Contracts/

# Publish
RUN dotnet publish Users.Events.Consumer/Users.Events.Consumer.csproj \
    -c Release \
    -o /app/publish \
    /p:UseAppHost=false

# =========================
# STAGE 2 - LAMBDA
# =========================
FROM public.ecr.aws/lambda/dotnet:8
WORKDIR /var/task

COPY --from=build /app/publish .

CMD ["Users.Events.Consumer::Users.Events.Consumer.Function::FunctionHandler"]
