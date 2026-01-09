# =========================
# STAGE 1 - BUILD
# =========================
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copia csproj (cria as pastas corretas)
COPY src/Users.Events.Consumer/Users.Events.Consumer.csproj Users.Events.Consumer/
COPY src/Users.Events.Contracts/Users.Events.Contracts.csproj Users.Events.Contracts/

# Restore (PATH CORRETO)
RUN dotnet restore src/src/Users.Events.Consumer/Users.Events.Consumer.csproj

# Copia o restante do código
COPY src/Users.Events.Consumer/ Users.Events.Consumer/
COPY src/Users.Events.Contracts/ Users.Events.Contracts/

# Publish EXPLÍCITO do projeto da Lambda
RUN dotnet publish Users.Events.Consumer/Users.Events.Consumer.csproj \
    -c Release \
    -o /app/publish \
    /p:UseAppHost=false

# =========================
# STAGE 2 - LAMBDA RUNTIME
# =========================
FROM public.ecr.aws/lambda/dotnet:8
WORKDIR /var/task

COPY --from=build /app/publish .

# ⚠️ AJUSTE O HANDLER PARA O NOME REAL
CMD ["Users.Events.Consumer::Users.Events.Consumer.Function::FunctionHandler"]
