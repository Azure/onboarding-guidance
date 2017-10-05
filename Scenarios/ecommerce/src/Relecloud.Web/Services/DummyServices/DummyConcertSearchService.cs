using Relecloud.Web.Models;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Relecloud.Web.Services.DummyServices
{
    public class DummyConcertSearchService : IConcertSearchService
    {
        public void Initialize()
        {
        }

        public Task<ICollection<ConcertSearchResult>> SearchAsync(string query)
        {
            return Task.FromResult<ICollection<ConcertSearchResult>>(Array.Empty<ConcertSearchResult>());
        }
    }
}