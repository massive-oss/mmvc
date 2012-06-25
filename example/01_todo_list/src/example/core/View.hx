package example.core;

#if flash
import flash.display.Sprite;
#elseif js
import js.Lib;
import js.Dom;
#end
import m.signal.Signal;

class ViewEvent
{
	inline public static var ADDED:String = "added";
	inline public static var REMOVED:String = "removed";
	inline public static var ACTIONED:String = "actioned";
	inline public static var DATA_CHANGED:String = "dataChanged";
}

class View
{
	static var idCounter:Int = 0;

	public var id(default, null):String;
	public var parent(default, null):View;
	public var index(default, set_index):Int;

	public var signal(default, null):Signal2<String, View>;

	#if flash
		public var sprite(default, null):Sprite;
	#elseif js
		public var element(default, null):HtmlDom;
		var tagName:String;
	#end

	var children:Array<View>;

	public function new()
	{
		Reflect.setField(this, "index", -1);

		var type = Type.getClassName(Type.getClass(this)).split(".");
		id = type.pop() + (idCounter ++);
		
		children = [];
		signal = new Signal2<String, View>();
		
		initialize();
	}


	public function toString():String
	{
		return id;
	}

	public function dispatch(event:String, view:View)
	{
		if(view == null) view = this;
		signal.dispatch(event, view);
	}

	public function addChild(view:View)
	{
		view.signal.add(this.dispatch);
		view.parent = this;
		view.index = children.length;

		children.push(view);

		#if flash
		sprite.addChild(view.sprite);
		#elseif js
		element.appendChild(view.element);
		#end

		dispatch(ViewEvent.ADDED, view);
	}

	public function removeChild(view:View)
	{
		var removed = children.remove(view);

		if(removed)
		{
			view.signal.remove(this.dispatch);
			view.parent = null;
			view.index = -1;

			#if flash
			sprite.removeChild(view.sprite);
			#elseif js
			element.removeChild(view.element);
			#end

			dispatch(ViewEvent.REMOVED, view);
		}
	}

	///// internal //////
	function initialize()
	{
		#if flash
		sprite = new Sprite();
		#elseif js
		if(tagName == null) tagName = "div";
		element = Lib.document.createElement(tagName);
		element.setAttribute("id", id);
		#end
	}

	function set_index(value:Int):Int
	{
		if(index != value)
		{
			index = value;
			update();
		}
		
		return index;
	}

	function update()
	{
		
	}

}

class DataView<T> extends View
{
	public var data(default, null):T;

	public function new(?data:T)
	{
		super();
		setData(data);
	}
	public function setData(data:T)
	{
		if(this.data != data)
		{
			this.data = data;
			dataChanged();
			update();
			dispatch(ViewEvent.DATA_CHANGED, this);
		}
	}

	/**
	Executed on initialization and when data is changed
	*/
	function dataChanged()
	{
		
	}
}
