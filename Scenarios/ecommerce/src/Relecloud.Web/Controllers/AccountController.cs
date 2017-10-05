using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication.OpenIdConnect;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using Relecloud.Web.Infrastructure;

namespace Relecloud.Web.Controllers
{
    public class AccountController : Controller
    {
        #region Fields

        private readonly AuthenticationConfiguration authenticationConfiguration;

        #endregion

        #region Constructors

        public AccountController(IOptions<AuthenticationConfiguration> authenticationConfiguration)
        {
            this.authenticationConfiguration = authenticationConfiguration.Value;
        }

        #endregion

        #region SignIn

        [HttpGet]
        public IActionResult SignIn(string returnUrl)
        {
            var properties = new AuthenticationProperties { RedirectUri = returnUrl ?? "/" };
            return Challenge(properties, OpenIdConnectDefaults.AuthenticationScheme);
        }

        #endregion

        #region ResetPassword

        [HttpGet]
        public IActionResult ResetPassword()
        {
            var properties = new AuthenticationProperties { RedirectUri = "/" };
            properties.Items[OpenIdConnectOptionsSetup.PolicyAuthenticationProperty] = this.authenticationConfiguration.ResetPasswordPolicyId;
            return Challenge(properties, OpenIdConnectDefaults.AuthenticationScheme);
        }

        #endregion

        #region EditProfile

        [HttpGet]
        public IActionResult EditProfile()
        {
            var properties = new AuthenticationProperties { RedirectUri = "/" };
            properties.Items[OpenIdConnectOptionsSetup.PolicyAuthenticationProperty] = this.authenticationConfiguration.EditProfilePolicyId;
            return Challenge(properties, OpenIdConnectDefaults.AuthenticationScheme);
        }

        #endregion

        #region SignOut

        [HttpGet]
        public IActionResult SignOut()
        {
            var properties = new AuthenticationProperties { RedirectUri = "/" };
            return SignOut(properties, CookieAuthenticationDefaults.AuthenticationScheme, OpenIdConnectDefaults.AuthenticationScheme);
        }

        #endregion
    }
}