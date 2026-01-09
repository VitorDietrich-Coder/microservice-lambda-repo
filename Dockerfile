# =========================
# STAGE 1 - BUILD (.NET 9)
# =========================
FROM mcr.microsoft.com/dotnet/nightly/sdk:9.0 AS build
WORKDIR /src

# Copia APENAS os csproj (cache correto)
COPY src/Users.Events.Consumer/Users.Events.Consumer.csproj src/Users.Events.Consumer/
COPY src/Users.Events.Contracts/Users.Events.Contracts.csproj src/Users.Events.Contracts/

# Restore (AGORA FUNCIONA)
RUN dotnet restore src/Users.Events.Consumer/Users.Events.Consumer.csproj

# Copia TODO o código
COPY src ./src

# Publish
WORKDIR /src/Users.Events.Consumer
RUN dotnet publish -c Release -o /app/publish --no-restore

# =========================
# STAGE 2 - LAMBDA RUNTIME
# =========================
FROM public.ecr.aws/lambda/provided:al2023
WORKDIR /var/task

COPY --from=build /app/publish .

CMD ["Users.Events.Consumer::Users.Events.Consumer.Function::Handler"]
