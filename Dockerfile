FROM public.ecr.aws/lambda/dotnet:8

# Copia tudo
WORKDIR /var/task
COPY . .

# Publica
RUN dotnet publish -c Release -o /var/task/publish

# Define o handler
CMD ["EmailLambda::EmailLambda.Function::Handler"]