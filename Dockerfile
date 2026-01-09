# =========================
# STAGE 1 - BUILD
# =========================
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copia SOMENTE o csproj
COPY src/Users.Events.Consumer/Users.Events.Consumer.csproj Users.Events.Consumer/

# Restore (SEM src/)
RUN dotnet restore Users.Events.Consumer/Users.Events.Consumer.csproj

# Copia o restante do projeto
COPY src/Users.Events.Consumer/ Users.Events.Consumer/

# Publish explícito do projeto da Lambda
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

CMD ["Users.Events.Consumer::Users.Events.Consumer.Function::FunctionHandler"]
