using System;

namespace SentinelsDataRetriever.Data
{
	public class Product
	{
		public string Id;
		public string Name;

		public ulong ContentLength;

		public DateTime IngestionDate;

		public DateTime ContentStartDate;
		public DateTime ContentEndDate;

		public string ContentGeometry;

		public Product ()
		{
			
		}
	}
}

