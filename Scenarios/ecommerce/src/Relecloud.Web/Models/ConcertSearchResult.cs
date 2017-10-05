using System.Collections.Generic;

namespace Relecloud.Web.Models
{
    public class ConcertSearchResult : Concert
    {
        public double Score { get; set; }
        public IList<string> HitHighlights { get; set; }
    }
}