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
		private const string _downloadUrlFormat = "https://scihub.copernicus.eu/dhus/odata/v1/Products('{0}')/$value";

		private const string _beginTag = "<gml:coordinates>";
		private const string _endTag = "</gml:coordinates>";
		private int _beginTagLength;

		private NetworkCredential _credentials;

		public OpenAccessHubRepository()
		{
			_beginTagLength = _beginTag.Length;
			_credentials = new NetworkCredential ("mjiang", "xe7s%r&Riq");
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

		public List<Product> SelectSentinel2Data()
		{			
			string requestUrl = _baseUrl + "?$filter=startswith(Name,'S2')";

			return getProducts (requestUrl);
		}

		public List<Product> SelectSentinel3Data()
		{			
			string requestUrl = _baseUrl + "?$filter=startswith(Name,'S3')";

			return getProducts (requestUrl);
		}

		private List<Product> getProducts(string requestUrl)
		{
			WebResponse response = makeRequest (requestUrl);
			IList<XElement> entries = getEntries (response);

			List<Product> products = new List<Product> ();

			foreach (XElement xEle in entries) {			
				products.Add(this.convertToProduct(xEle));			
			}

			return products;
		}

		private WebResponse makeRequest(string url)
		{
			WebRequest webRequest = WebRequest.Create (url);
			webRequest.Credentials = _credentials;

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

			long contentLength = Convert.ToInt64 (propertiesElement.Elements ()
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

			int beginTagIndex = contentGeometry.IndexOf (_beginTag);
			int endTagIndex = contentGeometry.IndexOf (_endTag);
			string coordsString = contentGeometry.Substring (beginTagIndex + _beginTagLength, endTagIndex - beginTagIndex - _beginTagLength );

			XElement checkSumElement = propertiesElement.Elements()
				.Where(x => x.Name.LocalName == "Checksum")
				.FirstOrDefault();

			string checksum = checkSumElement.Elements()
				.Where(x => x.Name.LocalName == "Value")
				.Select(x => x.Value)
				.FirstOrDefault();

			Product product = new Product () {
				Name = title,
				Id = id,
				ContentLength = contentLength,
				IngestionDate = ingestionDate,
				ContentStartDate = contentStartDate,
				ContentEndDate = contentEndDate,
				Checksum = checksum,
				DownloadUrl = string.Format(_downloadUrlFormat, id),
				ContentGeometry = coordsString
			};

			return product;						
		}
	}
}