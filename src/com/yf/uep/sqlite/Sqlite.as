package com.yf.uep.sqlite
{
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.errors.SQLError;
	import flash.filesystem.File;
	import flash.net.Responder;

 //数据库文件 
	
	public class Sqlite
	{
		private var conn:SQLConnection;
		
		
		public function Sqlite()
		{
			conn = new SQLConnection();  
			var dbFile:File = File.applicationStorageDirectory.resolvePath("db/data.db");  
			var responder:Responder = new Responder(resultHandler, statusHandler);
			conn.openAsync(dbFile, SQLMode.READ, responder); // true的话， 如果没有data.db存在，AIR会自动生成一个空的data.db
		}
		
		private function resultHandler(event:SQLEvent):void  
		{      
			trace("the database was opened successfully");  
		}  
		
		private function statusHandler(event:SQLError):void  
		{      
			trace(event);      
		}  

	}
}