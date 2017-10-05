using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Relecloud.Web.Infrastructure;
using Relecloud.Web.Models;
using Relecloud.Web.Services;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Relecloud.Web.Controllers
{
    public class CartController : Controller
    {
        #region Fields

        private readonly IConcertRepository concertRepository;
        private readonly IEventSenderService eventSenderService;

        #endregion

        #region Constructors

        public CartController(IConcertRepository concertRepository, IEventSenderService eventSenderService)
        {
            this.concertRepository = concertRepository;
            this.eventSenderService = eventSenderService;
        }

        #endregion

        #region Index

        public async Task<IActionResult> Index()
        {
            var model = await GetCartAsync();
            return View(model);
        }

        #endregion

        #region Add

        public async Task<IActionResult> Add(int concertId)
        {
            var model = await this.concertRepository.GetConcertByIdAsync(concertId);
            if (model == null)
            {
                return NotFound();
            }
            return View(model);
        }

        [HttpPost]
        public IActionResult Add(int concertId, int count)
        {
            if (ModelState.IsValid)
            {
                var cartData = GetCartData();
                if (!cartData.ContainsKey(concertId))
                {
                    cartData.Add(concertId, 0);
                }
                cartData[concertId] = cartData[concertId] + count;
                SetCartData(cartData);
            }
            return RedirectToAction(nameof(Index));
        }

        #endregion

        #region Remove

        [HttpPost]
        public IActionResult Remove(int concertId)
        {
            if (ModelState.IsValid)
            {
                var cartData = GetCartData();
                if (cartData.ContainsKey(concertId))
                {
                    cartData.Remove(concertId);
                }
                SetCartData(cartData);
            }
            return RedirectToAction(nameof(Index));
        }

        #endregion

        #region Checkout

        [Authorize]
        public async Task<IActionResult> Checkout()
        {
            var model = await GetCartAsync();
            return View(model);
        }

        [Authorize]
        [HttpPost]
        [ActionName(nameof(Checkout))]
        public async Task<IActionResult> CheckoutConfirmed()
        {
            if (ModelState.IsValid)
            {
                // Create tickets for every item in the cart.
                var cartData = GetCartData();
                foreach (var concertId in cartData.Keys)
                {
                    for (var i = 0; i < cartData[concertId]; i++)
                    {
                        var ticket = new Ticket
                        {
                            ConcertId = concertId,
                            UserId = this.User.GetUniqueId()
                        };
                        await this.concertRepository.CreateTicketAsync(ticket);
                        await this.eventSenderService.SendEventAsync(Event.TicketCreated(ticket.Id));
                    }
                }
                
                // Remove all items from the cart.
                SetCartData(new Dictionary<int, int>());
            }
            return RedirectToAction(nameof(Index), "Ticket");
        }

        #endregion

        #region Helper Methods

        // The key is the concert ID, the value is the number of items in the cart.
        private IDictionary<int, int> GetCartData()
        {
            return this.HttpContext.Session.Get<IDictionary<int, int>>(nameof(Cart)) ?? new Dictionary<int, int>();
        }

        private void SetCartData(IDictionary<int, int> data)
        {
            // Remove keys that have don't have items in the cart anymore.
            foreach (var emptyItemKey in data.Where(item => item.Value <= 0).Select(item => item.Key).ToArray())
            {
                data.Remove(emptyItemKey);
            }
            this.HttpContext.Session.Set<IDictionary<int, int>>(nameof(Cart), data);
        }

        private async Task<Cart> GetCartAsync()
        {
            var cartData = GetCartData();
            var concertsInCart = await this.concertRepository.GetConcertsByIdAsync(cartData.Keys);
            var concertCartData = concertsInCart.ToDictionary(concert => concert, concert => cartData[concert.Id]);
            return new Cart(concertCartData);
        }

        #endregion
    }
}