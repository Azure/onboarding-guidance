using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.OpenIdConnect;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Protocols.OpenIdConnect;
using Microsoft.IdentityModel.Tokens;
using Relecloud.Web.Models;
using Relecloud.Web.Services;
using System.Net;
using System.Threading.Tasks;

namespace Relecloud.Web.Infrastructure
{
    public class OpenIdConnectOptionsSetup : IConfigureNamedOptions<OpenIdConnectOptions>
    {
        #region Constants

        public const string PolicyAuthenticationProperty = "Policy";

        #endregion

        #region Fields

        private readonly AuthenticationConfiguration authenticationConfiguration;

        #endregion

        #region Constructors

        public OpenIdConnectOptionsSetup(IOptions<AuthenticationConfiguration> authenticationConfigurationOptions)
        {
            this.authenticationConfiguration = authenticationConfigurationOptions.Value;
        }

        #endregion

        #region Configure

        public void Configure(OpenIdConnectOptions options)
        {
            Configure(Options.DefaultName, options);
        }

        public void Configure(string name, OpenIdConnectOptions options)
        {
            options.ClientId = authenticationConfiguration.ClientId;
            options.Authority = authenticationConfiguration.Authority;
            options.UseTokenLifetime = true;
            options.TokenValidationParameters = new TokenValidationParameters { NameClaimType = "name" }; // Azure AD issues the user's display name in the "name" claim type.
            options.Events = new OpenIdConnectEvents()
            {
                OnTokenValidated = OnTokenValidated,
                OnRedirectToIdentityProvider = OnRedirectToIdentityProvider,
                OnRemoteFailure = OnRemoteFailure
            };
        }

        #endregion

        #region OpenID Connect Event Handlers

        public async Task OnTokenValidated(TokenValidatedContext context)
        {
            // The user has signed in, ensure the information in the database is up-to-date.
            var user = new User
            {
                Id = context.Principal.GetUniqueId(),
                DisplayName = context.Principal.Identity.Name
            };
            var concertRepository = context.HttpContext.RequestServices.GetRequiredService<IConcertRepository>();
            await concertRepository.CreateOrUpdateUserAsync(user);
        }

        public Task OnRedirectToIdentityProvider(RedirectContext context)
        {
            var defaultPolicy = authenticationConfiguration.DefaultPolicy;
            if (context.Properties.Items.TryGetValue(PolicyAuthenticationProperty, out var policy) &&
                !policy.Equals(defaultPolicy))
            {
                // A specific AAD B2C policy was requested, update the issuer address with the correct policy reference.
                context.ProtocolMessage.IssuerAddress = context.ProtocolMessage.IssuerAddress.ToLower().Replace(defaultPolicy.ToLower(), policy.ToLower());
                context.Properties.Items.Remove(PolicyAuthenticationProperty);
            }
            return Task.CompletedTask;
        }

        public Task OnRemoteFailure(RemoteFailureContext context)
        {
            context.HandleResponse();
            // Handle the error code that Azure AD B2C throws when trying to reset a password from the login page 
            // because password reset is not supported by a "sign-up or sign-in policy"
            if (context.Failure is OpenIdConnectProtocolException && context.Failure.Message.Contains("AADB2C90118"))
            {
                // If the user clicked the reset password link, redirect to the reset password route.
                context.Response.Redirect("/account/resetpassword");
            }
            else if (context.Failure is OpenIdConnectProtocolException && context.Failure.Message.Contains("access_denied"))
            {
                context.Response.Redirect("/");
            }
            else
            {
                context.Response.Redirect("/home/error?message=" + WebUtility.UrlEncode(context.Failure.Message));
            }
            return Task.CompletedTask;
        }

        #endregion
    }
}