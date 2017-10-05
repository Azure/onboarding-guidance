using Relecloud.Web.Models;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Relecloud.Web.Services
{
    public interface IConcertRepository : IDisposable
    {
        void Initialize();
        Task<Concert> GetConcertByIdAsync(int id);
        Task<ICollection<Concert>> GetConcertsByIdAsync(ICollection<int> ids);
        Task<ICollection<Concert>> GetUpcomingConcertsAsync(int count);
        Task AddReviewAsync(Review review);
        Task CreateTicketAsync(Ticket ticket);
        Task<ICollection<Ticket>> GetAllTicketsAsync(string userId);
        Task CreateOrUpdateUserAsync(User user);
    }
}