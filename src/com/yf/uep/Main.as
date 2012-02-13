import com.yf.uep.container.Container;
import com.yf.uep.sqlite.Sqlite;

import components.Item;

import flash.data.SQLConnection;
import flash.errors.SQLError;
import flash.events.*;

import mx.controls.Alert;
import mx.core.IVisualElement;

private function main():void
{
	addListeners();
	addObjects();
}

private function addListeners():void
{
	panel.addEventListener(MouseEvent.MOUSE_DOWN, panelHandler);
}



private function addObjects():void
{
	sqliteHandler();
	addItems();
}

private function sqliteHandler():void
{
	//var sqlite:Sqlite = new Sqlite();
	
	var conn:SQLConnection = new SQLConnection();
	conn.addEventListener(SQLEvent.OPEN, dbOpenHandler);
	conn.addEventListener(SQLErrorEvent.ERROR, dbErrorHandler);
	conn.openAsync();
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




