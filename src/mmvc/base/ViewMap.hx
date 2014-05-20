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

import haxe.ds.ObjectMap;

import minject.Injector;
import minject.ClassMap;
import mmvc.api.IViewMap;
import mmvc.api.IViewContainer;

using Lambda;

/**
	An abstract `IViewMap` implementation
**/
class ViewMap extends ViewMapBase implements IViewMap
{
	var mappedPackages:Array<Dynamic>;
	var mappedTypes:ClassMap<Class<Dynamic>>;
	var injectedViews:ObjectMap<{}, Dynamic>;
	
	/**
		Creates a new `ViewMap` object
		
		@param contextView The root view node of the context.
		@param injector An `Injector` to use for this context
	**/
	public function new(contextView:IViewContainer, injector:Injector)
	{
		super(contextView, injector);
		mappedPackages = new Array();
		mappedTypes = new ClassMap();
		injectedViews = new ObjectMap();
	}
	
	public function mapPackage(packageName:String):Void
	{
		if (mappedPackages.indexOf(packageName) > -1) return;
		mappedPackages.push(packageName);
		viewListenerCount++;
		if (viewListenerCount == 1) addListeners();
	}

	public function unmapPackage(packageName:String):Void
	{
		if (!mappedPackages.remove(packageName)) return;
		viewListenerCount--;
		if (viewListenerCount == 0) removeListeners();
	}

	public function mapType(type:Class<Dynamic>):Void
	{
		if (mappedTypes.exists(type)) return;
		mappedTypes.set(type, type);
		viewListenerCount++;
		if (viewListenerCount == 1) addListeners();
		if (contextView != null && Std.is(contextView, type)) injectInto(contextView);
	}

	public function unmapType(type:Class<Dynamic>):Void
	{
		if (!mappedTypes.exists(type)) return;
		mappedTypes.remove(type);
		viewListenerCount--;
		if (viewListenerCount == 0) removeListeners();
	}

	public function hasType(type:Class<Dynamic>):Bool
	{
		return mappedTypes.exists(type);
	}

	public function hasPackage(packageName:String):Bool
	{
		return mappedPackages.indexOf(packageName) > -1;
	}

	override function addListeners():Void
	{
		if (contextView == null || !enabled) return;
		contextView.viewAdded = onViewAdded;
		contextView.viewRemoved = onViewAdded;
	}

	override function removeListeners():Void
	{
		if (contextView == null) return;
		contextView.viewAdded = null;
		contextView.viewRemoved = null;
	}

	override function onViewAdded(view:Dynamic):Void
	{
		if (injectedViews.exists(view)) return;
		
		for (type in mappedTypes)
		{
			if (Std.is(view, type))
			{
				injectInto(view);
				return;
			}
		}

		var len = mappedPackages.length;

		if (len > 0)
		{
			var className = Type.getClassName(Type.getClass(view));

			for (i in 0...len)
			{
				var packageName = mappedPackages[i];

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
