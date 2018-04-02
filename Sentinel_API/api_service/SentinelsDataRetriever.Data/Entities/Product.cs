using System;

namespace SentinelsDataRetriever.Data
{
	public class Product
	{
		public string Id;
		public string Name;

		public SatelliteName SatelliteName;

		public long ContentLength;
		public string Checksum;

		public DateTime IngestionDate;

		public DateTime ContentStartDate;
		public DateTime ContentEndDate;

		public string ContentGeometry;

		public string DownloadUrl;

		public Product ()
		{
			
		}
	}
}

