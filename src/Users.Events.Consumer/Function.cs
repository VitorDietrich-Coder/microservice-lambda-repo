using Amazon.Lambda.Core;
using Amazon.Lambda.SNSEvents;
using Amazon.SimpleEmail;
using Microsoft.Extensions.DependencyInjection;
using System.Text.Json;
using Users.Events.Contracts.Events;

[assembly: LambdaSerializer(
    typeof(Amazon.Lambda.Serialization.SystemTextJson.DefaultLambdaJsonSerializer))]

namespace Users.Events.Consumer;
public class Function
{
    private readonly EmailService _emailService;

    public Function()
    {
        var services = new ServiceCollection();

        services.AddSingleton<IAmazonSimpleEmailService>(
            new AmazonSimpleEmailServiceClient());

        services.AddSingleton<EmailService>();

        var provider = services.BuildServiceProvider();
        _emailService = provider.GetRequiredService<EmailService>();
    }

    public async Task Handler(SNSEvent snsEvent, ILambdaContext context)
    {
        foreach (var record in snsEvent.Records)
        {
            var evt = JsonSerializer.Deserialize<UserCreatedEvent>(
                record.Sns.Message);

            if (evt is null)
                continue;

            try
            {
                await _emailService.SendAsync(evt.Email, evt.Name);
            }
            catch (Exception ex)
            {
                context.Logger.LogError(
                    $"Erro ao enviar email para {evt.Email}: {ex}");
                throw; 
            }
        }
    }
}
