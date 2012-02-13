package com.yf.uep.container
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	
	import spark.components.Group;

	public class Container extends DisplayObject
	{

		/**
		 * 
		 * @param _container
		 * @param _item
		 * @param _x
		 * @param _y
		 * @return 
		 * 
		 */
		public static function creatContainer(_container:Object, _item:DisplayObject, _x:Number, _y:Number):DisplayObject
		{
			_item.x=_x;
			_item.y=_y;
			_container.addChild(_item);
			return _item;
		}

		/**
		 * 
		 * @param _container
		 * 
		 */
		public static function cleanContainer(_container:Object):void
		{
			if (_container is Group)
			{
				for (var i:int=_container.numChildren - 1; i > -1; i--)
					_container.removeElementAt(i);
			}
			else if (_container is DisplayObject)
			{
				for (var j:int=_container.numChildren - 1; j > -1; j--)
					_container.removeChildAt(j);
			}


		}



	}
}