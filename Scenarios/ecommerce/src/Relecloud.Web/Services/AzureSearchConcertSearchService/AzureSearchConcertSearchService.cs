using Microsoft.Azure.Search;
using Microsoft.Azure.Search.Models;
using Relecloud.Web.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Relecloud.Web.Services.AzureSearchService
{
    public class AzureSearchConcertSearchService : IConcertSearchService
    {
        #region Constants

        private const string IndexNameConcerts = "concerts";

        #endregion

        #region Fields

        private readonly string searchServiceName;
        private readonly SearchCredentials searchServiceCredentials;
        private readonly string concertsSqlDatabaseConnectionString;
        private readonly SearchIndexClient concertsIndexClient;

        #endregion

        #region Constructors

        public AzureSearchConcertSearchService(string searchServiceName, string adminKey, string concertsSqlDatabaseConnectionString)
        {
            this.searchServiceName = searchServiceName;
            this.searchServiceCredentials = new SearchCredentials(adminKey);
            this.concertsSqlDatabaseConnectionString = concertsSqlDatabaseConnectionString;
            this.concertsIndexClient = new SearchIndexClient(this.searchServiceName, IndexNameConcerts, this.searchServiceCredentials);
        }

        #endregion

        #region Initialize

        public void Initialize()
        {
            var serviceClient = new SearchServiceClient(this.searchServiceName, this.searchServiceCredentials);
            InitializeConcertsIndex(serviceClient);
        }

        private void InitializeConcertsIndex(SearchServiceClient serviceClient)
        {
            // Create the index that will contain the searchable data from the concerts.
            var concertsIndex = new Index
            {
                Name = IndexNameConcerts,
                Fields = new[]
                {
                    new Field(nameof(Concert.Id), DataType.String) { IsKey = true, IsSearchable = false },
                    new Field(nameof(Concert.Artist), DataType.String, AnalyzerName.EnMicrosoft) { IsSearchable = true, IsRetrievable = true },
                    new Field(nameof(Concert.Location), DataType.String, AnalyzerName.EnMicrosoft) { IsSearchable = true, IsRetrievable = true },
                    new Field(nameof(Concert.Title), DataType.String, AnalyzerName.EnMicrosoft) { IsSearchable = true, IsRetrievable = true },
                    new Field(nameof(Concert.Description), DataType.String, AnalyzerName.EnMicrosoft) { IsSearchable = true, IsRetrievable = true },
                    new Field(nameof(Concert.Price), DataType.Double) { IsSearchable = false, IsFilterable = true, IsFacetable = true, IsSortable = true, IsRetrievable = true },
                    new Field(nameof(Concert.StartTime), DataType.DateTimeOffset) { IsSearchable = false, IsRetrievable = true, IsSortable = true, IsFilterable = true },
                }
            };
            serviceClient.Indexes.CreateOrUpdate(concertsIndex);

            // Create the data source that connects to the SQL Database account containing the consult requests.
            var concertsDataSource = new DataSource
            {
                Name = IndexNameConcerts,
                Type = DataSourceType.AzureSql,
                Container = new DataContainer("Concerts"),
                Credentials = new DataSourceCredentials(this.concertsSqlDatabaseConnectionString),
                DataChangeDetectionPolicy = new SqlIntegratedChangeTrackingPolicy()
            };
            serviceClient.DataSources.CreateOrUpdate(concertsDataSource);

            // Create the indexer that will pull the data from the database into the search index.
            var concertsIndexer = new Indexer
            {
                Name = IndexNameConcerts,
                DataSourceName = IndexNameConcerts,
                TargetIndexName = IndexNameConcerts,
                Schedule = new IndexingSchedule(TimeSpan.FromMinutes(5))
            };
            serviceClient.Indexers.CreateOrUpdate(concertsIndexer);
        }

        #endregion

        #region Search

        public async Task<ICollection<ConcertSearchResult>> SearchAsync(string query)
        {
            if (string.IsNullOrWhiteSpace(query))
            {
                query = "*";
            }
            var items = new List<ConcertSearchResult>();

            // Search concerts.
            var concertQueryParameters = new SearchParameters
            {
                HighlightFields = new[] { nameof(Concert.Description) }
            };
            var concertResults = await this.concertsIndexClient.Documents.SearchAsync(query, concertQueryParameters);
            foreach (var concertResult in concertResults.Results)
            {
                items.Add(new ConcertSearchResult
                {
                    Score = concertResult.Score,
                    HitHighlights = concertResult.Highlights == null ? new string[0] : concertResult.Highlights.SelectMany(h => h.Value).ToArray(),
                    Id = int.Parse((string)concertResult.Document[nameof(Concert.Id)]),
                    Artist = (string)concertResult.Document[nameof(Concert.Artist)],
                    Location = (string)concertResult.Document[nameof(Concert.Location)],
                    Title = (string)concertResult.Document[nameof(Concert.Title)],
                    Description = (string)concertResult.Document[nameof(Concert.Description)],
                    Price = (double)concertResult.Document[nameof(Concert.Price)],
                    StartTime = (DateTimeOffset)concertResult.Document[nameof(Concert.StartTime)]
                });
            }
            return items;
        }

        #endregion
    }
}