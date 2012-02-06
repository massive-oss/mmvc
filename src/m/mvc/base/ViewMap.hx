package m.mvc.base;

import m.data.Dictionary;
import m.inject.IInjector;
import m.mvc.api.IViewMap;
import m.mvc.api.IViewContainer;

/**
An abstract <code>IViewMap</code> implementation
*/
class ViewMap extends ViewMapBase, implements IViewMap
{
	/**
	 * Creates a new <code>ViewMap</code> object
	 *
	 * @param contextView The root view node of the context. The map will 
	 listen for ADDED_TO_STAGE events on this node
	 * @param injector An <code>IInjector</code> to use for this context
	 */
	public function new(contextView:IViewContainer, injector:IInjector)
	{
		super(contextView, injector);

		mappedPackages = new Array<Dynamic>();
		mappedTypes = new Dictionary<Dynamic, Dynamic>();
		injectedViews = new Dictionary<Dynamic, Dynamic>(true);
	}
	
	public function mapPackage(packageName:String):Void
	{
		if (!Lambda.has(mappedPackages, packageName))
		{
			mappedPackages.push(packageName);
			viewListenerCount++;

			if (viewListenerCount == 1)
			{
				addListeners();
			}
		}
	}

	public function unmapPackage(packageName:String):Void
	{
		var index = Lambda.indexOf(mappedPackages, packageName);

		if (index > -1)
		{
			mappedPackages.splice(index, 1);
			viewListenerCount--;

			if (viewListenerCount == 0)
			{
				removeListeners();
			}
		}
	}

	public function mapType(type:Class<Dynamic>):Void
	{
		if (mappedTypes.get(type) != null) return;

		mappedTypes.set(type, type);

		viewListenerCount++;
		if (viewListenerCount == 1)
		{
			addListeners();
		}
		
		// This was a bad idea - causes unexpected eager instantiation of object graph 
		if (contextView != null && Std.is(contextView, type))
		{
			injectInto(contextView);
		}
	}

	public function unmapType(type:Class<Dynamic>):Void
	{
		var mapping:Class<Dynamic> = mappedTypes.get(type);
		mappedTypes.delete(type);
		
		if (mapping != null)
		{
			viewListenerCount--;

			if (viewListenerCount == 0)
			{
				removeListeners();
			}
		}
	}

	public function hasType(type:Class<Dynamic>):Bool
	{
		return mappedTypes.get(type) != null;
	}

	public function hasPackage(packageName:String):Bool
	{
		return Lambda.has(mappedPackages, packageName);
	}

	//------------------------------------------------------------------------- private
	
	var mappedPackages:Array<Dynamic>;
	var mappedTypes:Dictionary<Dynamic, Dynamic>;
	var injectedViews:Dictionary<Dynamic, Dynamic>;

	override function addListeners():Void
	{
		if (contextView != null && enabled)
		{
			contextView.viewAdded = onViewAdded;
			contextView.viewRemoved = onViewAdded;
		}
	}

	override function removeListeners():Void
	{
		if (contextView != null)
		{
			contextView.viewAdded = null;
			contextView.viewRemoved = null;
		}
	}

	override function onViewAdded(view:Dynamic):Void
	{
		if (injectedViews.get(view) != null)
		{
			return;
		}
		
		for (type in mappedTypes)
		{
			if (Std.is(view, type))
			{
				injectInto(view);
				return;
			}
		}

		var len:Int = mappedPackages.length;

		if (len > 0)
		{
			var className = Type.getClassName(Type.getClass(view));

			for (i in 0...len)
			{
				var packageName:String = mappedPackages[i];

				if (className.indexOf(packageName) == 0)
				{
					injectInto(view);
					return;
				}
			}
		}
	}

	override function onViewRemoved(view:Dynamic):Void
	{
		trace("TODO");
	}

	function injectInto(view:Dynamic):Void
	{
		injector.injectInto(view);
		injectedViews.set(view, true);
	}
}
