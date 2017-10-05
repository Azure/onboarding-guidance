namespace Relecloud.Web.Models
{
    public class Ticket
    {
        public int Id { get; set; }
        public string ImageUrl { get; set; }

        public int ConcertId { get; set; }
        public Concert Concert { get; set; }

        public string UserId { get; set; }
        public User User { get; set; }
    }
}