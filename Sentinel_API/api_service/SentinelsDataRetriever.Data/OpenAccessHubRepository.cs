using System;
using System.Net;
using System.Collections.Generic;
using DHuS;
using System.Data.Services.Client;
using System.Linq;

namespace SentinelsDataRetriever.Data
{
	public class OpenAccessHubRepository
	{
		public OpenAccessHubRepository()
		{
			
		}

		public void GetData()
		{
			try
			{
				DHuSData data = new DHuSData(new Uri("https://scihub.copernicus.eu/dhus/odata/v1"));

				data.Credentials = new NetworkCredential("mjiang", "xe7s%r&Riq");


				DataServiceQuery<Product> products = data.Products;

				List<Product> productList = products.ToList();

				Product p = productList[0];


				Console.WriteLine(productList.Count);

				Console.WriteLine("Success");
			}
			catch (Exception e)
			{
				Console.WriteLine("Failure");
				Console.WriteLine(e.Message);
				Console.WriteLine(e.InnerException.Message);
			}
		}
	}
}