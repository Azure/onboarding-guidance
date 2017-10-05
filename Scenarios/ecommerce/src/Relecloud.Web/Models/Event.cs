namespace Relecloud.Web.Models
{
    public class Event
    {
        #region Properties

        public string EventType { get; set; }
        public string EntityId { get; set; }

        #endregion

        #region Static Factory Methods

        public static Event ReviewCreated(int reviewId)
        {
            return new Event
            {
                EventType = "ReviewCreated",
                EntityId = reviewId.ToString()
            };
        }

        public static Event TicketCreated(int ticketId)
        {
            return new Event
            {
                EventType = "TicketCreated",
                EntityId = ticketId.ToString()
            };
        }

        #endregion
    }
}