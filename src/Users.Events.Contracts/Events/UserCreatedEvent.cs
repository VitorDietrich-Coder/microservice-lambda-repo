using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Users.Events.Contracts.Base;

namespace Users.Events.Contracts.Events
{
    public record UserCreatedEvent(
       string Name,
       string Email,
       string Username,
       int TypeUser
   ) : IntegrationEvent;
}
