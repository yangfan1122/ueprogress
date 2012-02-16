package com.yf.uep.sqlite
{
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.display.Sprite;
	import flash.errors.SQLError;
	import flash.events.Event;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.net.Responder;
	
	import mx.controls.Alert;

	public class Sqlite extends Sprite
	{
		private var conn:SQLConnection;
		private var dbStatement:SQLStatement;
		private var state:SQLStatement;
		private var titles:Object;
		private var bars:String;
		
		public function Sqlite(){}
		
		/**
		 * 连接数据库 
		 * 
		 */		
		public function connSQLite():void
		{
			var dbFile:File = File.applicationStorageDirectory.resolvePath(File.applicationDirectory.nativePath+"/db/data.db"); 
			conn = new SQLConnection(); 
			conn.addEventListener(SQLEvent.OPEN, connOpenHandler);
			conn.addEventListener(SQLErrorEvent.ERROR, statusHandler);
			try
			{
				conn.open(dbFile);
			}
			catch(error:Error)
			{
				trace(error.getStackTrace());
			}
		}
		
		/**
		 * 连接成功 
		 * @param event
		 * 
		 */		
		private function connOpenHandler(event:SQLEvent):void  
		{      
			trace("the database was opened successfully");
			
			readSQL();
		}  
		
		/**
		 * 连接失败 
		 * @param event
		 * 
		 */		
		private function statusHandler(event:SQLErrorEvent):void
		{      
			trace(event.error.message + " //// "+event.error.details);
		}  
		
		
		/**
		 * sql查询，设置界面 
		 * 
		 */		
		private function readSQL():void
		{
			dbStatement = new SQLStatement();
			dbStatement.sqlConnection = conn;
			dbStatement.text = "SELECT * FROM uep";
			
			//查询
			dbStatement.addEventListener(SQLEvent.RESULT, resultHandler);
			dbStatement.addEventListener(SQLErrorEvent.ERROR, errorHandler);
			dbStatement.execute();
		}
		
		
		/**
		 * sql查询执行结果 
		 * @param event
		 * 
		 */		
		private function resultHandler(event:SQLEvent):void
		{
			var result:SQLResult = dbStatement.getResult();
			if (result != null)
			{
				var numRows:int = result.data.length;
				for (var i:int = 0; i < numRows; i++)
				{
					var row:Object = result.data[i];		
					titles = {appname:row.appname, workname:row.workname, h0:row.h0, h1:row.h1, h2:row.h2, h3:row.h3, h4:row.h4, h5:row.h5, h6:row.h6, h7:row.h7, h8:row.h8, h9:row.h9, h10:row.h10, v1:row.v1, v2:row.v2, v3:row.v3, v4:row.v4, v5:row.v5, v6:row.v6, v7:row.v7};
					bars = row.bars;
				}

				this.dispatchEvent(new Event("Names_GETTED"));
			}
		}
		
		/**
		 * 返回标题 
		 * @return 
		 * 
		 */		
		public function get Titles():Object
		{
			return titles;
		}
		
		/**
		 * 返回bars 
		 * @return 
		 * 
		 */		
		public function get Bars():String
		{
			return bars;
		}
		
		
		
		
		/**
		 * sql执行错误 
		 * @param event
		 * 
		 */		
		private function errorHandler(event:SQLErrorEvent):void
		{
			trace(event.error.message);
		}
		
		
		
		


		/**
		 * 保存
		 * @param _obj:标题s
		 * @param _bars:bars
		 * 
		 */		
		public function saveSQLite(_obj:Object, _bars:String):void
		{
			var sql:String = "UPDATE uep SET bars=:bars,appname=:appname,workname=:workname,h0=:h0,h1=:h1,h2=:h2,h3=:h3,h4=:h4,h5=:h5,h6=:h6,h7=:h7,h8=:h8,h9=:h9,h10=:h10,v1=:v1,v2=:v2,v3=:v3,v4=:v4,v5=:v5,v6=:v6,v7=:v7";

			state = new SQLStatement();
			state.parameters[':bars'] = _bars;
			state.parameters[':appname'] = _obj.appname.text;
			state.parameters[':workname'] = _obj.workname.text;
			state.parameters[':h0'] = _obj.h0.text;
			state.parameters[':h1'] = _obj.h1.text;
			state.parameters[':h2'] = _obj.h2.text;
			state.parameters[':h3'] = _obj.h3.text;
			state.parameters[':h4'] = _obj.h4.text;
			state.parameters[':h5'] = _obj.h5.text;
			state.parameters[':h6'] = _obj.h6.text;
			state.parameters[':h7'] = _obj.h7.text;
			state.parameters[':h8'] = _obj.h8.text;
			state.parameters[':h9'] = _obj.h9.text;
			state.parameters[':h10'] = _obj.h10.text;
			state.parameters[':v1'] = _obj.v1.text;
			state.parameters[':v2'] = _obj.v2.text;
			state.parameters[':v3'] = _obj.v3.text;
			state.parameters[':v4'] = _obj.v4.text;
			state.parameters[':v5'] = _obj.v5.text;
			state.parameters[':v6'] = _obj.v6.text;
			state.parameters[':v7'] = _obj.v7.text;

			var effectRows:Boolean = updateWithParameters(sql);
			if(effectRows)
			{
				trace("save success!");
				Alert.show("save success!");
			}
			else
			{
				trace("save failed!");
				Alert.show("save failed!");
			}
		}
		
		/**
		 * sql保存执行 
		 * @param _sql
		 * @return 
		 * 
		 */		
		private function updateWithParameters(_sql:String):Boolean
		{
			try
			{
				state.sqlConnection = conn;
				state.text = _sql;
				state.addEventListener(SQLErrorEvent.ERROR, errorHandler);
				state.execute();
			}
			catch(error:Error)
			{
				trace(error);
				return false;
			}
			return true;
		}
		
		

	}
}