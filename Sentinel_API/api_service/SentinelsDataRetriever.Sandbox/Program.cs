using System;
using SentinelsDataRetriever.Data;
using System.Collections.Generic;

namespace SentinelsDataRetriever.Sandbox
{
	class MainClass
	{
		public static void Main (string[] args)
		{
			OpenAccessHubRepository repos = new OpenAccessHubRepository ();
			List<Product> products = repos.SelectSentinel3Data ();

			IndexDatabaseRepository indexRepos = new IndexDatabaseRepository ();
			foreach (Product p in products) {
				if (!indexRepos.DoesProductExist (p)) {
					indexRepos.AddProduct (p);				
				}		
			}
		}
	}
}
