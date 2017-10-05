using Microsoft.AspNetCore.Http;
using Newtonsoft.Json;
using System.Security.Claims;

namespace Relecloud.Web.Infrastructure
{
    public static class ExtensionMethods
    {
        public static string GetUniqueId(this ClaimsPrincipal user)
        {
            // Azure AD issues a globally unique user ID in the objectidentifier claim.
            return user?.FindFirstValue("http://schemas.microsoft.com/identity/claims/objectidentifier");
        }

        public static void Set<T>(this ISession session, string key, T value)
        {
            session.SetString(key, JsonConvert.SerializeObject(value));
        }

        public static T Get<T>(this ISession session, string key)
        {
            var value = session.GetString(key);
            return value == null ? default(T) : JsonConvert.DeserializeObject<T>(value);
        }
    }
}