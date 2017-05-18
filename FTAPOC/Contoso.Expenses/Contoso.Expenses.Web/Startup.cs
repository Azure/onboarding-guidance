using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(Contoso.Expenses.Web.Startup))]
namespace Contoso.Expenses.Web
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
