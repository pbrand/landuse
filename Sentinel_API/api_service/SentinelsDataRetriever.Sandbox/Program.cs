using System;
using SentinelsDataRetriever.Data;

namespace SentinelsDataRetriever.Sandbox
{
	class MainClass
	{
		public static void Main (string[] args)
		{
			OpenAccessHubRepository repos = new OpenAccessHubRepository ();
			repos.GetData ();
		}
	}
}
