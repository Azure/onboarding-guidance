using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Queue;
using Newtonsoft.Json;
using Relecloud.Web.Models;
using System.Threading.Tasks;

namespace Relecloud.Web.Services.StorageAccountEventSenderService
{
    public class StorageAccountEventSenderService : IEventSenderService
    {
        private readonly CloudQueue queue;

        public StorageAccountEventSenderService(string connectionString, string queueName)
        {
            var account = CloudStorageAccount.Parse(connectionString);
            var queueClient = account.CreateCloudQueueClient();
            this.queue = queueClient.GetQueueReference(queueName);
        }

        public void Initialize()
        {
            this.queue.CreateIfNotExistsAsync().Wait();
        }

        public async Task SendEventAsync(Event eventMessage)
        {
            var body = JsonConvert.SerializeObject(eventMessage);
            var message = new CloudQueueMessage(body);
            await this.queue.AddMessageAsync(message);
        }
    }
}