# =========================
# STAGE 1 - BUILD (.NET 9)
# =========================
FROM mcr.microsoft.com/dotnet/nightly/sdk:9.0 AS build
WORKDIR /src

# Copia csproj
COPY src/Users.Events.Consumer/Users.Events.Consumer.csproj src/Users.Events.Consumer/
COPY src/Users.Events.Contracts/Users.Events.Contracts.csproj src/Users.Events.Contracts/

# Restore
RUN dotnet restore src/Users.Events.Consumer/Users.Events.Consumer.csproj

# Copia o código
COPY src ./src

# Publish
RUN dotnet publish src/Users.Events.Consumer/Users.Events.Consumer.csproj \
    -c Release \
    -r linux-x64 \
    --self-contained false \
    -o /app/publish



# =========================
# STAGE 2 - LAMBDA RUNTIME
# =========================
FROM public.ecr.aws/lambda/provided:al2023
WORKDIR /var/task

COPY --from=build /app/publish .

CMD ["Users.Events.Consumer::Users.Events.Consumer.Function::Handler"]
