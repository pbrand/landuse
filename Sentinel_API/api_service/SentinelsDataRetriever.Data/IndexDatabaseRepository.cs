using System;
using Npgsql;
using System.Collections.Generic;
using System.Linq;

namespace SentinelsDataRetriever.Data
{
	public class IndexDatabaseRepository
	{
		public const string _connectionString = "Host=localhost;Port=5432;Username=mjiang;Password=TF6aw2ns;Database=esa_index";

		public IndexDatabaseRepository ()
		{
			
		}

		public bool DoesProductExist(Product product)
		{
			using (var conn = new NpgsqlConnection(_connectionString))
			{
				string sql = "select * from index where id = '" + product.Id.ToString () + "'";

				conn.Open();

				// Retrieve all rows
				using (var cmd = new NpgsqlCommand(sql, conn))
				using (var reader = cmd.ExecuteReader())
					while (reader.Read())
						Console.WriteLine(reader.GetString(0));
			}

			return true;

		}

		public void AddProduct(Product product)
		{
			using (var conn = new NpgsqlConnection(_connectionString))
			{
				conn.Open();

				PlaneCoordinates planeCoords = getPlaneCoords (product.ContentGeometry);

				string sql = string.Format("insert into index values ( '@0', '@1', '@2', @3, '@4', '@5', '@6', @7, @8, @9, @10, '@11' )", 
					product.Id,
					product.SatelliteName.ToString(),
					product.Checksum,
					product.DownloadUrl,
					product.ContentEndDate.Date.ToUniversalTime(),
					product.ContentEndDate.TimeOfDay.ToString(),
					planeCoords.LatitudeMin,
					planeCoords.LongitudeMin,
					planeCoords.LatitudeMax,
					planeCoords.LongitudeMax,
					product.ContentGeometry,
					product.ContentLength
				);

				using (var cmd = new NpgsqlCommand (sql, conn)) {				
					int rowsAffected = cmd.ExecuteNonQuery ();
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
				latitudes.Add (Convert.ToDecimal (coords [1]));
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

