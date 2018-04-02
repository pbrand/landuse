using System;

namespace SentinelsDataRetriever.Data
{
	public static class SqlHelper
	{
		public static string EscapeSingleQuotes(string sql)
		{
			return sql.Replace ("'", "''");
		}
	}
}

