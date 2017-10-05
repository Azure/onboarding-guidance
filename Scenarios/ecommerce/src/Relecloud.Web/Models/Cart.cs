using System.Collections.Generic;
using System.Linq;

namespace Relecloud.Web.Models
{
    public class Cart
    {
        // The key is the ID, the value is the number of items in the cart.
        public IDictionary<Concert, int> Concerts { get; }
        public int TotalTickets { get; }
        public double TotalPrice { get; }

        public Cart(IDictionary<Concert, int> concerts)
        {
            this.Concerts = concerts;
            this.TotalTickets = this.Concerts.Sum(item => item.Value);
            this.TotalPrice = this.Concerts.Sum(item => item.Key.Price * item.Value);
        }
    }
}