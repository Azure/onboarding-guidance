using Relecloud.Web.Models;
using System.Threading.Tasks;

namespace Relecloud.Web.Services.DummyServices
{
    public class DummyEventSenderService : IEventSenderService
    {
        public void Initialize()
        {
        }

        public Task SendEventAsync(Event eventMessage)
        {
            return Task.CompletedTask;
        }
    }
}