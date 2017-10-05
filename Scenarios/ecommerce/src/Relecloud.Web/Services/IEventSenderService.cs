using Relecloud.Web.Models;
using System.Threading.Tasks;

namespace Relecloud.Web.Services
{
    public interface IEventSenderService
    {
        void Initialize();
        Task SendEventAsync(Event eventMessage);
    }
}