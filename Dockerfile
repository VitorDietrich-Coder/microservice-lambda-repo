# =========================
# STAGE 1 - BUILD
# =========================
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

 

# ---- Copia SOMENTE os csproj (para cache de restore) ----
COPY src/Users.Events.Consumer/Users.Events.Consumer.csproj src/Users.Events.Consumer/
COPY src/Users.Events.Contracts/Users.Events.Contracts.csproj src/Users.Events.Contracts/


# ---- Restore (paths corretos) ----
RUN dotnet restore Users.Events.Consumer/Users.Events.Consumer.csproj


# ---- Copia o restante do código ----
COPY src/Users.Events.Consumer/ src/Users.Events.Consumer/
COPY src/Users.Events.Contracts/ src/Users.Events.Contracts/


# ---- Publish explícito da Lambda ----
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

# ⚠️ AJUSTE SEU HANDLER SE NECESSÁRIO
# Formato: Assembly::Namespace.Classe::Metodo
CMD ["Users.Events.Consumer::Users.Events.Consumer.Function::FunctionHandler"]
