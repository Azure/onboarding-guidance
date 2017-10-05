using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Relecloud.Web.Infrastructure;
using Relecloud.Web.Services;
using System.Threading.Tasks;

namespace Relecloud.Web.Controllers
{
    [Authorize]
    public class TicketController : Controller
    {
        #region Fields

        private readonly IConcertRepository concertRepository;

        #endregion

        #region Constructors

        public TicketController(IConcertRepository concertRepository)
        {
            this.concertRepository = concertRepository;
        }

        #endregion

        #region Index

        public async Task<IActionResult> Index()
        {
            var userId = this.User.GetUniqueId();
            var model = await this.concertRepository.GetAllTicketsAsync(userId);
            return View(model);
        }

        #endregion
    }
}