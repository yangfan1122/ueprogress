import com.adobe.images.JPGEncoder;
import com.yf.uep.container.Container;
import com.yf.uep.sqlite.Sqlite;
import com.yf.uep.statics.Statics;

import components.Item;
import components.Legend;
import components.Person;

import flash.data.SQLConnection;
import flash.desktop.NativeApplication;
import flash.desktop.SystemTrayIcon;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.IBitmapDrawable;
import flash.display.NativeMenu;
import flash.display.NativeMenuItem;
import flash.display.NativeWindowDisplayState;
import flash.errors.SQLError;
import flash.events.*;
import flash.geom.Matrix;
import flash.net.FileReference;
import flash.utils.ByteArray;

import mx.controls.Alert;
import mx.core.IVisualElement;

private var objs:Object;//标题名称对象
private var sqlite:Sqlite;
private var barsArr:Array = new Array();//存储舞台Item(bar)实例
private var personArr:Array = new Array();//存储舞台Person实例
private var file:FileReference = new FileReference();//截图保存

[Embed(source='assets/icon_16x16.png')]
private var icon:Class;

/*
warning:
components:Item 是被直接引用的模块或应用程序。这将导致 components:Item 及其所有依赖项与 UEProgress 链接。建议使用接口以避免发生此情况。
*/

private function main():void
{
	//标题
	objs = {appname:appTitle, workname:workName, h0:person, h1:hTitle1, h2:hTitle2, h3:hTitle3, h4:hTitle4, h5:hTitle5, h6:hTitle6, h7:hTitle7, h8:hTitle8, h9:hTitle9, h10:hTitle10, v1:vTitle1, v2:vTitle2, v3:vTitle3, v4:vTitle4, v5:vTitle5, v6:vTitle6, v7:vTitle7};

	//表格数组赋值
	for(var i:int=0; i<70; i++)
	{
		Statics.bars = Statics.bars + "0";
	}
	
	
	
	addListeners();
	addObjects();
}

private function addListeners():void
{
	panel.addEventListener(MouseEvent.MOUSE_DOWN, panelHandler);
}



private function addObjects():void
{
	Container.cleanContainer(container);
	addItems();
	addPerson();
	
	legendGroup.addElement(new Legend());
	
	sqliteHandler();
	addSysTrayIcon();
}

private function sqliteHandler():void
{
	sqlite = new Sqlite();
	sqlite.addEventListener("Names_GETTED", setDisplayObjectHandler);
	sqlite.connSQLite();
}

/**
 * 读数据库设置界面 
 * @param evnet
 * 
 */
private function setDisplayObjectHandler(evnet:Event):void
{
	//titles
	for(var i:Object in sqlite.Titles)
	{
		objs[i].text = sqlite.Titles[i];
	}
	
	//bars
	Statics.bars = sqlite.Bars;
	var len:int = barsArr.length;
	for(var j:int=0; j<len; j++)
	{
		barsArr[j].setBarsDisplay(Statics.bars.slice(j, j+1));
	}

	//person
	Statics.persons = sqlite.Persons;
	var tmepArr:Array = Statics.persons.split(",");
	var len1:int = personArr.length;
	for(var k:int=0; k<len1; k++)
	{
		personArr[k].strength.text = tmepArr[k];
	}
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

/**
 * 加条 
 * 
 */
private function addItems():void
{
	//10*7
	
	var len:int = 70;
	for(var i:int = 0; i<len; i++)
	{
		var item:Item = new Item();
		item.x = 190 + (i%10) * item.width;//190;
		item.y = 125 + Math.floor(i/10) * item.height;//125; item.height=66
		barsArr.push(item);
		container.addElement(item);
	}
}

/**
 *	人数 
 * 
 */
private function addPerson():void
{
	var len:uint = 7;
	for(var i:int=0; i<len; i++)
	{
		var person:Person = new Person();
		person.x = 118;
		person.y = 127 + person.height*i;
		personArr.push(person);
		container.addElement(person);
	}
}



/**
 * 保存
 * @param
 * 
 */
private function saveBtnHandler():void
{
	//bars
	var temp:String = "";
	var len:int = barsArr.length;
	for(var i:int = 0; i<len; i++)
	{
		temp = temp + barsArr[i].counter;
	}
	Statics.bars = temp;
	
	//persons
	var temp1:String = "";
	var len1:int = personArr.length;
	for(var j:int=0; j<len1; j++)
	{
		if(j == (len1-1))
		{
			temp1 = temp1 + personArr[j].strength.text;
		}
		else
		{
			temp1 = temp1 + personArr[j].strength.text + ",";
		}
	}
	Statics.persons = temp1;
	
	//保存
	sqlite.saveSQLite(objs, Statics.bars, Statics.persons);
}

/**
 * 截图保存 
 * @param event
 * 
 */
private function saveHandler():void
{
	var bitmapData:BitmapData = new BitmapData(this.width,this.height);
	bitmapData.draw(this as IBitmapDrawable);
	var bitmap:Bitmap = new Bitmap(bitmapData);
	var jpg:JPGEncoder = new JPGEncoder(100);
	var ba:ByteArray = jpg.encode(bitmapData);
	file.save(ba, "pic.jpg");
}


//系统任务栏

private function addSysTrayIcon():void
{
	this.nativeApplication.icon.bitmaps=[new icon()];
	if (NativeApplication.supportsSystemTrayIcon)
	{
		var sti:SystemTrayIcon=SystemTrayIcon(this.nativeApplication.icon);
		
		sti.menu=createSysTrayMenu();
		sti.addEventListener(MouseEvent.CLICK, restoreFromSysTrayHandler); //左键点击系统任务栏图标
		sti.tooltip=Statics.appName;
	}
}
private function createSysTrayMenu():NativeMenu
{
	var menu:NativeMenu=new NativeMenu();
	var labels:Array=[Statics.openApp, Statics.saveEdit, Statics.savePic, "", Statics.exit];
	var names:Array=[Statics.openApp, Statics.saveEdit, Statics.savePic, "", Statics.exit];
	for (var i:int=0; i < labels.length; i++)
	{
		//如果标签为空的话，就认为是分隔符
		var menuItem:NativeMenuItem=new NativeMenuItem(labels[i], labels[i] == "");
		menuItem.name=names[i];
		menuItem.addEventListener(Event.SELECT, sysTrayMenuHandler); //菜单处理事件
		menu.addItem(menuItem);
	}
	
	return menu;
}
private function restoreFromSysTrayHandler(event:MouseEvent):void //系统任务栏最大最小化
{
	if (this.nativeWindow.displayState == NativeWindowDisplayState.MINIMIZED)
	{
		undockHandler();
	}
	else
	{
		this.minimize();
		this.nativeWindow.visible=false;
	}
}
private function sysTrayMenuHandler(event:Event):void
{
	switch (event.target.name)
	{
		case Statics.openApp: //打开
			undockHandler();
			break;
		case Statics.saveEdit: //保存修改
			saveBtnHandler();
			break;
		case Statics.savePic: //截图
			saveHandler();
			break;
		case Statics.exit: //退出菜单
			exitHandler();
			break;
	}
	
}

private function undockHandler():void //从系统托盘恢复到任务栏
{
	this.nativeWindow.visible=true;
	this.nativeWindow.orderToFront();
	this.activate();
}

private function exitHandler():void
{
	this.exit();
}

// //系统任务栏
