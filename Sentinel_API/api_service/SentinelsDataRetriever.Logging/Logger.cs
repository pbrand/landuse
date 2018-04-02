using System;
using System.IO;

namespace SentinelsDataRetriever.Logging
{
	public static class Logger
	{
		public static LogLevel LogLevel;

		private static StreamWriter logFile;

		public static void Initialize()
		{
			LogLevel = LogLevel.Warning;

			string currentDirectory = Directory.GetCurrentDirectory();

			string logFilePath = Path.Combine(currentDirectory, "log.txt");

			if (!File.Exists(logFilePath)) {
				logFile = new StreamWriter(File.Create(logFilePath));
			}
			else {
				logFile = new StreamWriter(File.Open (logFilePath, FileMode.Append));
			}
		}

		public static void Log(string message, LogLevel logLevel)
		{
			if (LogLevel > logLevel)
				return;

			string logLevelPrefix = "";

			switch (logLevel) {
			case LogLevel.Verbose:
				logLevelPrefix = "<VERBOSE>";
				break;
			case LogLevel.Debug:
				logLevelPrefix = "<DEBUG>";
				break;
			case LogLevel.Info:
				logLevelPrefix = "<INFO>";
				break;
			case LogLevel.Warning:
				logLevelPrefix = "<WARNING>";
				break;			
			case LogLevel.Error:
				logLevelPrefix = "<ERROR>";
				break;
			}

			string fullText = DateTime.Now.ToString ("MM-dd-yyyy HH:mm:ss") + " " + logLevelPrefix + ": " + message;
		
			log (fullText);
		}

		private static void log (string message)
		{
			logFile.WriteLine (message);
			Console.WriteLine (message);
		}

	}
}

