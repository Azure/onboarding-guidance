using Relecloud.Web.Models;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Relecloud.Web.Services.DummyServices
{
    public class DummyConcertRepository : IConcertRepository
    {
        public void Initialize()
        {
        }

        public Task<Concert> GetConcertByIdAsync(int id)
        {
            return Task.FromResult<Concert>(null);
        }

        public Task<ICollection<Concert>> GetConcertsByIdAsync(ICollection<int> ids)
        {
            return Task.FromResult<ICollection<Concert>>(Array.Empty<Concert>());
        }

        public Task<ICollection<Concert>> GetUpcomingConcertsAsync(int count)
        {
            return Task.FromResult<ICollection<Concert>>(Array.Empty<Concert>());
        }

        public Task AddReviewAsync(Review review)
        {
            return Task.CompletedTask;
        }

        public Task CreateTicketAsync(Ticket ticket)
        {
            return Task.CompletedTask;
        }

        public Task<ICollection<Ticket>> GetAllTicketsAsync(string userId)
        {
            return Task.FromResult<ICollection<Ticket>>(Array.Empty<Ticket>());
        }

        public Task CreateOrUpdateUserAsync(User user)
        {
            return Task.CompletedTask;
        }

        public void Dispose()
        {
        }
    }
}
