using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Caching.Distributed;
using Newtonsoft.Json;
using Relecloud.Web.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Relecloud.Web.Services.SqlDatabaseEventRepository
{
    public class SqlDatabaseConcertRepository : IConcertRepository
    {
        private ConcertDataContext database;
        private IDistributedCache cache;

        public SqlDatabaseConcertRepository(ConcertDataContext database, IDistributedCache cache)
        {
            this.database = database;
            this.cache = cache;
        }

        public void Initialize()
        {
            this.database.Initialize();
        }

        public async Task<Concert> GetConcertByIdAsync(int id)
        {
            return await this.database.Concerts.Where(c => c.Id == id).Include(c => c.Reviews).SingleOrDefaultAsync();
        }

        public async Task<ICollection<Concert>> GetConcertsByIdAsync(ICollection<int> ids)
        {
            return await this.database.Concerts.Where(c => ids.Contains(c.Id)).ToListAsync();
        }

        public async Task<ICollection<Concert>> GetUpcomingConcertsAsync(int count)
        {
            IList<Concert> concerts;
            var concertsJson = await this.cache.GetStringAsync("UpcomingConcerts");
            if (concertsJson != null)
            {
                // We have cached data, deserialize the JSON data.
                concerts = JsonConvert.DeserializeObject<IList<Concert>>(concertsJson);
            }
            else
            {
                // There's nothing in the cache, retrieve data from the repository and cache it for one hour.
                concerts = await this.database.Concerts.Where(c => c.StartTime > DateTimeOffset.UtcNow).OrderBy(c => c.StartTime).Take(count).ToListAsync();
                concertsJson = JsonConvert.SerializeObject(concerts);
                await this.cache.SetStringAsync("UpcomingConcerts", concertsJson, new DistributedCacheEntryOptions { AbsoluteExpirationRelativeToNow = TimeSpan.FromHours(1) });
            }
            return concerts;
        }

        public async Task AddReviewAsync(Review review)
        {
            this.database.Reviews.Add(review);
            await this.database.SaveChangesAsync();
        }

        public async Task CreateTicketAsync(Ticket ticket)
        {
            this.database.Tickets.Add(ticket);
            await this.database.SaveChangesAsync();
        }

        public async Task<ICollection<Ticket>> GetAllTicketsAsync(string userId)
        {
            return await this.database.Tickets.Include(t => t.Concert).Where(t => t.UserId == userId).ToListAsync();
        }

        public async Task CreateOrUpdateUserAsync(User user)
        {
            var dbUser = await this.database.Users.FindAsync(user.Id);
            if (dbUser == null)
            {
                dbUser = new User { Id = user.Id };
                this.database.Users.Add(dbUser);
            }
            dbUser.DisplayName = user.DisplayName;
            await this.database.SaveChangesAsync();
        }

        public void Dispose()
        {
            if (this.database != null)
            {
                this.database.Dispose();
                this.database = null;
            }
        }
    }
}