using System;
using SentinelsDataRetriever.Data;
using System.Collections.Generic;
using SentinelsDataRetriever.Logging;

namespace SentinelsDataRetriever.Sandbox
{
	class MainClass
	{
		public static void Main (string[] args)
		{
			Logger.Initialize ();
			Logger.LogLevel = LogLevel.Verbose;

			OpenAccessHubRepository repos = new OpenAccessHubRepository ();
			IndexDatabaseRepository indexRepos = new IndexDatabaseRepository ();

			ulong numberOfProducts = repos.CountProducts ();

//			Console.WriteLine (numberOfProducts);
			Logger.Log ("Number of products: " + numberOfProducts, LogLevel.Info);

			for (ulong i = 0; i < numberOfProducts; i += 100) {

				Logger.Log ("At: " + i, LogLevel.Verbose);

				List<Product> products = repos.SelectAllProducts (i);
				foreach (Product p in products) {
					if (!indexRepos.DoesProductExist (p)) {
						indexRepos.AddProduct (p);				
					}		
				}
			}
		}
	}
}
