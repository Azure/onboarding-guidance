using Microsoft.EntityFrameworkCore;
using Relecloud.Web.Models;
using System;
using System.Linq;

namespace Relecloud.Web.Services.SqlDatabaseEventRepository
{
    public class ConcertDataContext : DbContext
    {
        public DbSet<Concert> Concerts { get; set; }
        public DbSet<Review> Reviews { get; set; }
        public DbSet<Ticket> Tickets { get; set; }
        public DbSet<User> Users { get; set; }

        public ConcertDataContext(DbContextOptions<ConcertDataContext> options) : base(options)
        {
        }

        public void Initialize()
        {
            this.Database.EnsureCreated();

            if (this.Concerts.Any())
            {
                return;
            }

            // Enable change tracking on the database and table which can be used by the search service.
            var databaseName = this.Database.GetDbConnection().Database;
            var concertsTableName = nameof(Concerts);
            // Note: the cast to string is to work around an issue in Entity Framework Core 2.0 with string interpolation.
            // See https://github.com/aspnet/EntityFrameworkCore/issues/9734.
            this.Database.ExecuteSqlCommand((string)$"ALTER DATABASE [{databaseName}] SET CHANGE_TRACKING = ON (CHANGE_RETENTION = 2 DAYS, AUTO_CLEANUP = ON)");
            this.Database.ExecuteSqlCommand((string)$"ALTER TABLE [{concertsTableName}] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON)");

            var startDate = new DateTimeOffset(DateTimeOffset.UtcNow.Year, DateTimeOffset.UtcNow.Month, DateTimeOffset.UtcNow.Day, 20, 0, 0, TimeSpan.Zero);
            this.Concerts.AddRange(new[] {
                new Concert { Artist = "Beyoncé", Location = "CenturyLink Field, Seattle, USA", Price = 60, Title = "Lemonade Tour", Description = "Beyoncé Giselle Knowles-Carter (born September 4, 1981), is an American singer, songwriter, dancer and actress. Born and raised in Houston, Texas, Beyoncé performed in various singing and dancing competitions as a child. She rose to fame in the late 1990s as lead singer of the R&B girl-group Destiny's Child. Managed by her father, Mathew Knowles, the group became one of the world's best-selling girl groups in history. Their hiatus saw Beyoncé's theatrical film debut in Austin Powers in Goldmember (2002) and the release of her debut album, Dangerously in Love (2003). The album established her as a solo artist worldwide, earned five Grammy Awards, and featured the Billboard Hot 100 number-one singles \"Crazy in Love\" and \"Baby Boy\".", StartTime = startDate.AddDays(3) },
                new Concert { Artist = "Royal Blood", Location = "Parc Jean Drapeau, Montreal, Canada", Price = 40, Title = "How Did We Get So Dark? Tour", Description = "Royal Blood are an English rock duo formed in Brighton in 2013. The band's sound is reminiscent of and rooted in modern blues rock, alternative metal, hard rock, garage rock, stoner rock and psychedelic rock. Their first album Royal Blood was released in August 2014.", StartTime = startDate.AddDays(24) },
                new Concert { Artist = "Dr. Dre", Location = "Riverstage, Brisbane, Australia", Price = 40, Title = "Compton Tour", Description = "Andre Romelle Young (born February 18, 1965), better known by his stage name Dr. Dre, is an American rapper, record producer, and entrepreneur. He is the founder and current CEO of Aftermath Entertainment and Beats Electronics. Dre was previously the co-owner of, and an artist on, Death Row Records. He has produced albums for and overseen the careers of many rappers, including 2Pac, The D.O.C., Snoop Dogg, Eminem, Xzibit, Knoc-turn'al, 50 Cent, The Game and Kendrick Lamar. He is credited as a key figure in the popularization of West Coast G-funk, a style of rap music characterized as synthesizer-based with slow, heavy beats.", StartTime = startDate.AddDays(36) },
                new Concert { Artist = "Madonna", Location = "The O2, London, UK", Price = 40, Title = "Rebel Heart Tour", Description = "Madonna Louise Ciccone (born August 16, 1958) is an American singer, songwriter, actress, and businesswoman. A leading presence during the emergence of MTV in the 1980s, Madonna is known for pushing the boundaries of lyrical content in mainstream popular music, as well as visual imagery in music videos and live performances. She has also frequently reinvented both her music and image while maintaining autonomy within the recording industry. Her diverse musical productions have been acclaimed by music critics and often generated controversy in media and public. Referred to as the \"Queen of Pop\", Madonna is widely cited as an influence by other artists.", StartTime = startDate.AddDays(49) },
                new Concert { Artist = "Coldplay", Location = "Royal Circus, Brussels, Belgium", Price = 95, Title = "A Head Full Of Dreams Tour", Description = "Coldplay are a British rock band formed in 1996 by lead vocalist and keyboardist Chris Martin and lead guitarist Jonny Buckland at University College London (UCL). After they formed under the name Pectoralz, Guy Berryman joined the group as bassist and they changed their name to Starfish. Will Champion joined as drummer and backing vocalist, completing the lineup. Creative director Phil Harvey is often referred to as the fifth member by the band. The band renamed themselves \"Coldplay\" in 1998, before recording and releasing three EPs: Safety in 1998 and Brothers & Sisters and The Blue Room in 1999. The Blue Room was their first release on a major label, after signing to Parlophone.", StartTime = startDate.AddDays(63) }
            });
            this.SaveChanges();
        }
    }
}