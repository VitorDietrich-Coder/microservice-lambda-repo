# =========================
# STAGE 1 - BUILD
# =========================
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copia csproj e restaura
COPY  src/Users.Events.Consumer/Users.Events.Consumer.csproj Users.Events.Consumer/
COPY  src/Users.Events.Contracts/Users.Events.Contracts.csproj Users.Events.Contracts/
RUN dotnet restore

# Copia o resto
COPY . .
RUN dotnet publish -c Release -o /app/publish

# =========================
# STAGE 2 - LAMBDA RUNTIME
# =========================
FROM public.ecr.aws/lambda/dotnet:8

WORKDIR /var/task
COPY --from=build /app/publish .

# Handler
CMD ["EmailLambda::EmailLambda.Function::Handler"]
