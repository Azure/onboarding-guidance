using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication.OpenIdConnect;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using Relecloud.Web.Infrastructure;
using Relecloud.Web.Services;
using Relecloud.Web.Services.AzureSearchService;
using Relecloud.Web.Services.DummyServices;
using Relecloud.Web.Services.SqlDatabaseEventRepository;
using Relecloud.Web.Services.StorageAccountEventSenderService;

namespace Relecloud.Web
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            // Add framework services.
            services.AddMvc();
            services.AddRouting(options => options.LowercaseUrls = true);

            services.Configure<MvcOptions>(options =>
            {
                options.Filters.Add(new RequireHttpsAttribute());
                options.Filters.Add(new AutoValidateAntiforgeryTokenAttribute());
            });

            // Retrieve application settings.
            var redisCacheConnectionString = Configuration.GetValue<string>("App:RedisCache:ConnectionString");
            var sqlDatabaseConnectionString = Configuration.GetValue<string>("App:SqlDatabase:ConnectionString");
            var azureSearchServiceName = Configuration.GetValue<string>("App:AzureSearch:ServiceName");
            var azureSearchAdminKey = Configuration.GetValue<string>("App:AzureSearch:AdminKey");
            var storageAccountConnectionString = Configuration.GetValue<string>("App:StorageAccount:ConnectionString");
            var storageAccountEventQueueName = Configuration.GetValue<string>("App:StorageAccount:EventQueueName");
            var authenticationConfigurationSection = Configuration.GetSection("App:Authentication");

            // Add custom services.
            if (!string.IsNullOrWhiteSpace(redisCacheConnectionString))
            {
                // If we have a connection string to Redis, use that as the distributed cache.
                // If not, ASP.NET Core automatically injects an in-memory cache.
                services.AddDistributedRedisCache(options => { options.Configuration = redisCacheConnectionString; });
            }
            if (string.IsNullOrWhiteSpace(sqlDatabaseConnectionString))
            {
                // Add a dummy concert repository in case the Azure SQL Database isn't provisioned and configured yet.
                services.AddScoped<IConcertRepository, DummyConcertRepository>();
                // Add a dummy concert search service as well since the Azure Search service needs the Azure SQL Database.
                services.AddScoped<IConcertSearchService, DummyConcertSearchService>();
            }
            else
            {
                // Add a concert repository based on Azure SQL Database.
                services.AddDbContextPool<ConcertDataContext>(options => options.UseSqlServer(sqlDatabaseConnectionString));
                services.AddScoped<IConcertRepository, SqlDatabaseConcertRepository>();
                if (string.IsNullOrWhiteSpace(azureSearchServiceName) || string.IsNullOrWhiteSpace(azureSearchAdminKey))
                {
                    // Add a dummy concert search service in case the Azure Search service isn't provisioned and configured yet.
                    services.AddScoped<IConcertSearchService, DummyConcertSearchService>();
                }
                else
                {
                    // Add a concert search service based on Azure Search.
                    services.AddScoped<IConcertSearchService>(x => new AzureSearchConcertSearchService(azureSearchServiceName, azureSearchAdminKey, sqlDatabaseConnectionString));
                }
            }
            if (string.IsNullOrWhiteSpace(storageAccountConnectionString) || string.IsNullOrWhiteSpace(storageAccountEventQueueName))
            {
                // Add a dummy event sender service in case the Azure Storage account isn't provisioned and configured yet.
                services.AddScoped<IEventSenderService, DummyEventSenderService>();
            }
            else
            {
                // Add an event sender service based on Azure Storage.
                services.AddScoped<IEventSenderService>(x => new StorageAccountEventSenderService(storageAccountConnectionString, storageAccountEventQueueName));
            }

            // Add authentication if configured.
            if (!string.IsNullOrWhiteSpace(authenticationConfigurationSection.GetValue<string>("ClientId")))
            {
                services.Configure<AuthenticationConfiguration>(authenticationConfigurationSection);
                services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme)
                    .AddCookie(options => options.LoginPath = new PathString("/account/signin"))
                    .AddOpenIdConnect(/* The options are more complex and are therefore configured separately using IConfigureOptions for clarity */);
                services.AddSingleton<IConfigureOptions<OpenIdConnectOptions>, OpenIdConnectOptionsSetup>();
            }

            // The ApplicationInitializer is injected in the Configure method with all its dependencies and will ensure
            // they are all properly initialized upon construction.
            services.AddScoped<ApplicationInitializer, ApplicationInitializer>();

            services.AddSession();
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env, ApplicationInitializer applicationInitializer)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
                app.UseBrowserLink();
            }
            else
            {
                app.UseExceptionHandler("/home/error");
            }

            app.UseStaticFiles();

            app.UseAuthentication();

            app.UseSession();

            app.UseMvc(routes =>
            {
                routes.MapRoute(
                    name: "default",
                    template: "{controller=home}/{action=index}/{id?}");
            });
        }
    }
}