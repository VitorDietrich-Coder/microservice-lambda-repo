
using Amazon.SimpleEmail;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Users.Events.Consumer;

public class Program
{
    public static async Task Main(string[] args)
    {
        var host = Host.CreateDefaultBuilder()
            .ConfigureServices(services =>
            {
                services.AddAWSService<IAmazonSimpleEmailService>();
                services.AddScoped<EmailService>();
            })
            .Build();

        await host.RunAsync();
    }
}
