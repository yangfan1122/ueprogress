// ActionScript file

import flash.display.Loader;
import flash.events.*;
import flash.net.URLRequest;

import mx.controls.Alert;
import mx.core.IVisualElement;

private var loader:Loader;

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
	loader = new Loader();
	configureListeners(loader.contentLoaderInfo);
	loader.addEventListener(MouseEvent.CLICK, clickHandler);
	
	var request:URLRequest = new URLRequest("assets/table.swf");
	//assets/table.swf
	//http://eip.si-tech.com.cn/theme/nresources/default/images/pic/logo.jpg
	loader.load(request);
}

private function panelHandler(event:MouseEvent):void
{
	if(event.type == MouseEvent.MOUSE_DOWN)
	{
		this.stage.nativeWindow.startMove();
	}
}





//loader
private function configureListeners(dispatcher:IEventDispatcher):void {
	dispatcher.addEventListener(Event.COMPLETE, completeHandler);
	dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
	dispatcher.addEventListener(Event.INIT, initHandler);
	dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
	dispatcher.addEventListener(Event.OPEN, openHandler);
	dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
	dispatcher.addEventListener(Event.UNLOAD, unLoadHandler);
}

private function completeHandler(event:Event):void {
	trace("completeHandler: " + event);
	trace(loader as IVisualElement);//null
	//thisStage.addElement(loader as IVisualElement);
}

private function httpStatusHandler(event:HTTPStatusEvent):void {
	trace("httpStatusHandler: " + event);
}

private function initHandler(event:Event):void {
	trace("initHandler: " + event);
}

private function ioErrorHandler(event:IOErrorEvent):void {
	trace("ioErrorHandler: " + event);
}

private function openHandler(event:Event):void {
	trace("openHandler: " + event);
}

private function progressHandler(event:ProgressEvent):void {
	trace("progressHandler: bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
}

private function unLoadHandler(event:Event):void {
	trace("unLoadHandler: " + event);
}

private function clickHandler(event:MouseEvent):void {
	trace("clickHandler: " + event);
	var loader:Loader = Loader(event.target);
	loader.unload();
}

// //loader

