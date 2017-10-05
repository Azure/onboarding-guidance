using System;
using System.Collections.Generic;

namespace Relecloud.Web.Models
{
    public class Concert
    {
        public int Id { get; set; }
        public string Artist { get; set; }
        public string Location { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public double Price { get; set; }
        public DateTimeOffset StartTime { get; set; }

        public IList<Review> Reviews { get; set; } = new List<Review>();
        public IList<Ticket> Tickets { get; set; } = new List<Ticket>();
    }
}