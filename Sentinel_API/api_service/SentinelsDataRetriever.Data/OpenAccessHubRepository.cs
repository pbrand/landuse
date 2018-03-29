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
			string requestUrl = baseUrl + "?$filter=startswith(Name,'S3')";

			WebResponse response = makeRequest (requestUrl);
			IList<XElement> entries = getEntries (response);


			List<Product> products = new List<Product> ();

			foreach (XElement xEle in entries) {
			
				products.Add(this.convertToProduct(xEle));
			
			}

			foreach (Product p in products) {
				Console.WriteLine (p.Name);	
				Console.WriteLine (p.Id);
			}
		}

		private WebResponse makeRequest(string url)
		{			

			WebRequest webRequest = WebRequest.Create (url);
			webRequest.Credentials = new NetworkCredential ("mjiang", "xe7s%r&Riq");

			WebResponse response = webRequest.GetResponse ();

			return response;
		}

		private IList<XElement> getEntries(WebResponse xmlResponse)
		{
			XmlReader r = XmlReader.Create(xmlResponse.GetResponseStream ());

			XDocument f = XDocument.Load(r);

			List<XElement> entries = f.Descendants()
				.Where(x => x.Name.LocalName == "entry")
				.ToList();

			return entries;
		}

		private Product convertToProduct(XElement entryElement)
		{
			XElement propertiesElement = entryElement.Elements()
				.Where(x => x.Name.LocalName == "properties")
				.FirstOrDefault();

			string title = propertiesElement.Elements()
				.Where(x => x.Name.LocalName == "Name")
				.Select(x => x.Value)
				.FirstOrDefault();

			string id = propertiesElement.Elements()
				.Where(x => x.Name.LocalName == "Id")
				.Select(x => x.Value)
				.FirstOrDefault();

			ulong contentLength = Convert.ToUInt64 (propertiesElement.Elements ()
				.Where (x => x.Name.LocalName == "ContentLength")
				.Select (x => x.Value)
				.FirstOrDefault ());

			DateTime ingestionDate = Convert.ToDateTime(propertiesElement.Elements()
				.Where(x => x.Name.LocalName == "IngestionDate")
				.Select(x => x.Value)
				.FirstOrDefault());

			XElement contentDateElement = propertiesElement.Elements()
				.Where(x => x.Name.LocalName == "ContentDate")
				.FirstOrDefault();

			DateTime contentStartDate = Convert.ToDateTime(contentDateElement.Elements()
				.Where(x => x.Name.LocalName == "Start")
				.Select(x => x.Value)
				.FirstOrDefault());

			DateTime contentEndDate = Convert.ToDateTime(contentDateElement.Elements()
				.Where(x => x.Name.LocalName == "End")
				.Select(x => x.Value)
				.FirstOrDefault());

			string contentGeometry = propertiesElement.Elements()
				.Where(x => x.Name.LocalName == "ContentGeometry")
				.Select(x => x.Value)
				.FirstOrDefault();

			Product product = new Product () {
				Name = title,
				Id = id,
				ContentLength = contentLength,
				IngestionDate = ingestionDate,
				ContentStartDate = contentStartDate,
				ContentEndDate = contentEndDate,
				ContentGeometry = contentGeometry
			};

			return product;						
		}
	}

	public class Odata<T>
	{
		public List<T> Values { get; set; }
	}
}