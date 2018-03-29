using System;
using System.Net;
using System.Collections.Generic;
using DHuS;
using System.Data.Services.Client;
using System.Linq;
using System.IO;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Xml.Serialization;
using System.Xml;
using System.Xml.Linq;

namespace SentinelsDataRetriever.Data
{
	public class OpenAccessHubRepository
	{
		private const string _baseUrl = "https://scihub.copernicus.eu/dhus/odata/v1/Products/";

		public OpenAccessHubRepository()
		{
			
		}

//		public void GetData()
//		{
//			try
//			{
//				DHuSData data = new DHuSData(new Uri("https://scihub.copernicus.eu/dhus/odata/v1"));
//
//				data.Credentials = new NetworkCredential("mjiang", "xe7s%r&Riq");
//
//
//				DataServiceQuery<Product> products = data.Products;
//
//				List<Product> productList = products.ToList();
//
//				Product p = productList[0];
//
//
//				Console.WriteLine(productList.Count);
//
//				Console.WriteLine("Success");
//			}
//			catch (Exception e)
//			{
//				Console.WriteLine("Failure");
//				Console.WriteLine(e.Message);
//				Console.WriteLine(e.InnerException.Message);
//			}
//		}	

		public void SelectSentinel3Data()
		{
			string baseUrl = "https://scihub.copernicus.eu/dhus/odata/v1/Products/";

			string requeslUrl = baseUrl + "?$filter=startswith(Name,'S3')";

			WebRequest webRequest = WebRequest.Create (requeslUrl);
			webRequest.Credentials = new NetworkCredential ("mjiang", "xe7s%r&Riq");

			WebResponse response = webRequest.GetResponse ();

			XmlReader r = XmlReader.Create(response.GetResponseStream ());

			XDocument f = XDocument.Load(r);

			List<XElement> entries = f.Descendants()
				.Where(x => x.Name.LocalName == "entry")
				.ToList();

			List<Product> products = new List<Product> ();

			foreach (XElement xEle in entries) {
			
				products.Add(this.convertToProduct(xEle));
			
			}

//			Console.WriteLine (responseText);
			Console.WriteLine(products.Count);		
		}

		private Product convertToProduct(XElement entryElement)
		{

			string title = entryElement.Elements()
				.Where(x => x.Name.LocalName == "title")
				.Select(x => x.Value)
				.FirstOrDefault();

			string id = entryElement.Elements()
				.Where(x => x.Name.LocalName == "id")
				.Select(x => x.Value)
				.FirstOrDefault();

			Product product = new Product () {
				Title = title,
				Id = id
			};

			return product;						
		}
	}

	public class Odata<T>
	{
		public List<T> Values { get; set; }
	}
}