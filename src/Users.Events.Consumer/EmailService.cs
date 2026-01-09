using Amazon.SimpleEmail;
using Amazon.SimpleEmail.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Metadata;
using System.Text;
using System.Threading.Tasks;

namespace Users.Events.Consumer
{
    public class EmailService
    {
        private readonly IAmazonSimpleEmailService _ses;

        public EmailService(IAmazonSimpleEmailService ses)
        {
            _ses = ses;
        }

        public async Task SendAsync(string to, string name)
        {
            try
            {
                var request = new SendEmailRequest
                {
                    Destination = new Destination
                    {
                        ToAddresses = new List<string> { to }
                    },
                    Message = new Message
                    {
                        Subject = new Content("Bem-vindo"),
                        Body = new Body
                        {
                            Text = new Content($"Olá {name}, bem-vindo!")
                        }
                    },
                    Source = "vitorjosedietrich@gmail.com"
                };

                await _ses.SendEmailAsync(request);
            }
            catch (AmazonSimpleEmailServiceException ex)
            {
                Console.WriteLine($"Erro SES: {ex.Message} / {ex.StatusCode}");
                throw;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Erro genérico ao enviar email: {ex}");
                throw;
            }
        }
    }

}
