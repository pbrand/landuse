using System;
using Npgsql;
using System.Collections.Generic;
using System.Linq;

namespace SentinelsDataRetriever.Data
{
	public class IndexDatabaseRepository
	{
		public const string _connectionString = "Host=185.87.184.12;Port=5432;Username=mjiang;Password=TF6aw2ns;Database=esa_index";

		public IndexDatabaseRepository ()
		{
			
		}

		public bool DoesProductExist(Product product)
		{
			using (NpgsqlConnection conn = new NpgsqlConnection(_connectionString))
			{
				string sql = "select count(*) from index where id = '" + product.Id.ToString () + "'";

				conn.Open();

				// Retrieve all rows
				using (NpgsqlCommand cmd = new NpgsqlCommand (sql, conn)) {
					using (NpgsqlDataReader reader = cmd.ExecuteReader ()) {
						if (reader.Read ()) {
							return reader.GetString (0) != "0";
						}
					}
						
				}

			}

			return false;
		}

		public void AddProduct(Product product)
		{
			using (var conn = new NpgsqlConnection(_connectionString))
			{
				conn.Open();

				PlaneCoordinates planeCoords = getPlaneCoords (product.ContentGeometry);

				string sql = string.Format("insert into index values ( '{0}', '{1}', '{2}', '{3}', {4}, {5}, {6}, {7}, '{8}', {9}, '{10}', '{11}' )", 
					product.Id, // {0}
					product.SatelliteName.ToString(), // {1}
					product.Checksum, // {2}
					SqlHelper.EscapeSingleQuotes(product.DownloadUrl), // {3}
					planeCoords.LatitudeMin, // {4}
					planeCoords.LongitudeMin, // {5}
					planeCoords.LatitudeMax, // {6}
					planeCoords.LongitudeMax, // {7}
					product.ContentGeometry, //{8}
					product.ContentLength, //{9}
					product.ContentStartDate.ToString(), // {10}
					product.ContentEndDate.ToString() // {11}
				);

				using (var cmd = new NpgsqlCommand (sql, conn)) {				
					cmd.ExecuteNonQuery ();
				}
			}
		}

		private PlaneCoordinates getPlaneCoords(string coordsString)
		{
			string[] coordPairs = coordsString.Split (' ');

			List<decimal> latitudes = new List<decimal> (coordPairs.Length);
			List<decimal> longitudes = new List<decimal> (coordPairs.Length);

			foreach (string coordPair in coordPairs) {
				string[] coords = coordPair.Split (',');
				latitudes.Add (Convert.ToDecimal (coords[0]));
				longitudes.Add (Convert.ToDecimal (coords [1]));
			}

			PlaneCoordinates planeCoords = new PlaneCoordinates () {
				LatitudeMin = latitudes.Min (),
				LongitudeMin = longitudes.Min (),
				LatitudeMax = latitudes.Max (),
				LongitudeMax = longitudes.Max ()
			};

			return planeCoords;
		}
	}
}

