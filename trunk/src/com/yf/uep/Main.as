import com.yf.uep.container.Container;
import com.yf.uep.sqlite.Sqlite;

import components.Item;

import flash.data.SQLConnection;
import flash.errors.SQLError;
import flash.events.*;

import mx.controls.Alert;
import mx.core.IVisualElement;

private var objs:Object;
private var sqlite:Sqlite;

/*
components:Item 是被直接引用的模块或应用程序。这将导致 components:Item 及其所有依赖项与 UEProgress 链接。建议使用接口以避免发生此情况。


*/

private function main():void
{
	objs = {appname:appTitle, workname:workName, h0:person, h1:hTitle1, h2:hTitle2, h3:hTitle3, h4:hTitle4, h5:hTitle5, h6:hTitle6, h7:hTitle7, h8:hTitle8, h9:hTitle9, h10:hTitle10, v1:vTitle1, v2:vTitle2, v3:vTitle3, v4:vTitle4, v5:vTitle5, v6:vTitle6, v7:vTitle7};
	
	//读数据库
	
	addListeners();
	addObjects();
}

private function addListeners():void
{
	panel.addEventListener(MouseEvent.MOUSE_DOWN, panelHandler);
	saveBtn.addEventListener(MouseEvent.CLICK, saveBtnHandler);
}



private function addObjects():void
{
	sqliteHandler();
	addItems();
}

private function sqliteHandler():void
{
	sqlite = new Sqlite();
	sqlite.addEventListener("Names_GETTED", getNames);
	
	/*
	var conn:SQLConnection = new SQLConnection();
	conn.addEventListener(SQLEvent.OPEN, dbOpenHandler);
	conn.addEventListener(SQLErrorEvent.ERROR, dbErrorHandler);
	conn.openAsync();
	*/
}

private function getNames(evnet:Event):void
{
	trace("getNames");
	for(var i in sqlite.Names)
	{
		trace(i+":"+sqlite.Names[i]);
	}
}


private function dbOpenHandler(event:SQLEvent):void
{
	trace("created");
}
private function dbErrorHandler(event:SQLErrorEvent):void
{
	trace(event.error.message + " //// "+event.error.details);
}

/**
 * 窗口拖拽 
 * @param event
 * 
 */
private function panelHandler(event:MouseEvent):void
{
	if(event.type == MouseEvent.MOUSE_DOWN)
	{
		this.stage.nativeWindow.startMove();
	}
}


private function addItems():void
{
	//10*7
	
	//展示
	Container.cleanContainer(container);
	var len:int = 70;
	for(var i:int = 0; i<len; i++)
	{
		var item:Item = new Item();
		item.x = 190 + (i%10) * item.width;//190;
		item.y = 125 + Math.floor(i/10) * item.height;//125; item.height=66
		container.addElement(item);
	}

}



private function saveBtnHandler(event:MouseEvent):void
{
	sqlite.saveSQLite(objs);
}


