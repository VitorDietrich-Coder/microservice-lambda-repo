using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Users.Events.Contracts.Base
{
    public abstract record IntegrationEvent
    {
        public Guid EventId { get; init; } = Guid.NewGuid();
        public string CorrelationId { get; init; } = default!;
        public DateTime OccurredAt { get; init; } = DateTime.UtcNow;
    }
}
