/*
Copyright (c) 2012 Massive Interactive

Permission is hereby granted, free of charge, to any person obtaining a copy of 
this software and associated documentation files (the "Software"), to deal in 
the Software without restriction, including without limitation the rights to 
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
of the Software, and to permit persons to whom the Software is furnished to do 
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all 
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
SOFTWARE.
*/

package mmvc.base;

import mdata.Dictionary;
import minject.Injector;
import mmvc.api.IViewMap;
import mmvc.api.IViewContainer;

/**
	An abstract `IViewMap` implementation
**/
class ViewMap extends ViewMapBase implements IViewMap
{
	/**
		Creates a new `ViewMap` object
		
		@param contextView The root view node of the context.
		@param injector An `Injector` to use for this context
	**/
	public function new(contextView:IViewContainer, injector:Injector)
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
		// abstract
	}

	function injectInto(view:Dynamic):Void
	{
		injector.injectInto(view);
		injectedViews.set(view, true);
	}
}
