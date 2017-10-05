using Relecloud.Web.Services;

namespace Relecloud.Web
{
    public class ApplicationInitializer
    {
        public ApplicationInitializer(
            IConcertRepository concertRepository,
            IConcertSearchService concertSearchService,
            IEventSenderService eventSenderService)
        {
            // Initialize all resources at application startup.
            concertRepository.Initialize();
            concertSearchService.Initialize();
            eventSenderService.Initialize();
        }
    }
}