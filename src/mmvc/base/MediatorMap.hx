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

import minject.Injector;
import mmvc.api.IMediator;
import mmvc.api.IMediatorMap;
import minject.Reflector;
import mdata.Dictionary;
import mmvc.api.IViewContainer;
import haxe.Timer;

/**
	An abstract `IMediatorMap` implementation
**/
class MediatorMap extends ViewMapBase implements IMediatorMap
{
	var mediatorByView:Dictionary<Dynamic, IMediator>;
	var mappingConfigByView:Dictionary<Dynamic, MappingConfig>;
	var mappingConfigByViewClassName:Dictionary<Dynamic, MappingConfig>;
	var mediatorsMarkedForRemoval:Dictionary<Dynamic, Dynamic>;
	var hasMediatorsMarkedForRemoval:Bool;
	var reflector:Reflector;
	
	/**
		Creates a new `MediatorMap` object
		
		@param contextView The root view node of the context. 
		@param injector An `Injector` to use for this context
		@param reflector An `Reflector` to use for this context
	**/
	public function new(contextView:IViewContainer, injector:Injector, reflector:Reflector)
	{
		super(contextView, injector);
		this.reflector = reflector;
		
		mediatorByView = new Dictionary(true);
		mappingConfigByView = new Dictionary(true);
		mappingConfigByViewClassName = new Dictionary();
		mediatorsMarkedForRemoval = new Dictionary();
		hasMediatorsMarkedForRemoval = false;
	}
	
	public function mapView(viewClassOrName:Dynamic, mediatorClass:Class<Dynamic>, ?injectViewAs:Dynamic=null, ?autoCreate:Bool=true, ?autoRemove:Bool=true):Void
	{
		var viewClassName:String = reflector.getFQCN(viewClassOrName);
		
		if (mappingConfigByViewClassName.get(viewClassName) != null)
		{
			throw new ContextError("Mediator Class has already been mapped to a View Class in this context - " + mediatorClass);
		}
		
		if (reflector.classExtendsOrImplements(mediatorClass, IMediator) == false)
		{
			throw new ContextError("Mediator Class does not implement IMediator - " + mediatorClass);
		}
		
		var config = new MappingConfig();
		config.mediatorClass = mediatorClass;
		config.autoCreate = autoCreate;
		config.autoRemove = autoRemove;

		if (injectViewAs)
		{
			if (Std.is(injectViewAs, Array))
			{
				config.typedViewClasses = cast(injectViewAs, Array<Dynamic>).copy();
			}
			else if (Std.is(injectViewAs, Class))
			{
				config.typedViewClasses = [injectViewAs];
			}
		}
		else if (Std.is(viewClassOrName, Class))
		{
			config.typedViewClasses = [viewClassOrName];
		}
		mappingConfigByViewClassName.set(viewClassName, config);
		
		if (autoCreate || autoRemove)
		{
			viewListenerCount++;

			if (viewListenerCount == 1)
			{
				addListeners();
			}	
		}
		
		if (autoCreate && contextView != null && viewClassName == Type.getClassName(Type.getClass(contextView)))
		{
			createMediatorUsing(contextView, viewClassName, config);
		}
	}
	
	public function unmapView(viewClassOrName:Dynamic):Void
	{
		var viewClassName = reflector.getFQCN(viewClassOrName);
		var config = mappingConfigByViewClassName.get(viewClassName);

		if (config != null && (config.autoCreate || config.autoRemove))
		{
			viewListenerCount--;

			if (viewListenerCount == 0)
			{
				removeListeners();
			}
		}

		mappingConfigByViewClassName.delete(viewClassName);
	}
	
	public function createMediator(viewComponent:Dynamic):IMediator
	{
		return createMediatorUsing(viewComponent);
	}
	
	public function registerMediator(viewComponent:Dynamic, mediator:IMediator):Void
	{
		mediatorByView.set(viewComponent, mediator);
		var mapping = mappingConfigByViewClassName.get(Type.getClassName(Type.getClass(viewComponent)));
		mappingConfigByView.set(viewComponent, mapping);
		mediator.setViewComponent(viewComponent);
		mediator.preRegister();
	}
	
	public function removeMediator(mediator:IMediator):IMediator
	{
		if (mediator != null)
		{
			var viewComponent:Dynamic = mediator.getViewComponent();
			mediatorByView.delete(viewComponent);
			mappingConfigByView.delete(viewComponent);
			mediator.preRemove();
			mediator.setViewComponent(null);
		}
		
		return mediator;
	}
	
	public function removeMediatorByView(viewComponent:Dynamic):IMediator
	{
		var mediator = removeMediator(retrieveMediator(viewComponent));
		injector.attendedToInjectees.delete(mediator);
		return mediator;
	}
	
	public function retrieveMediator(viewComponent:Dynamic):IMediator
	{
		return mediatorByView.get(viewComponent);
	}
	
	public function hasMapping(viewClassOrName:Dynamic):Bool
	{
		var viewClassName:String = reflector.getFQCN(viewClassOrName);
		return mappingConfigByViewClassName.get(viewClassName) != null;
	}
	
	public function hasMediatorForView(viewComponent:Dynamic):Bool
	{
		return mediatorByView.get(viewComponent) != null;
	}
	
	public function hasMediator(mediator:IMediator):Bool
	{
		for (key in mediatorByView.keys())
		{
			if (mediatorByView.get(key) == mediator)
			{
				return true;
			}
		}
			
		return false;
	}
	
	override function addListeners():Void
	{
		if (contextView != null && enabled)
		{
			contextView.viewAdded = onViewAdded;
			contextView.viewRemoved = onViewRemoved;
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
		if (mediatorsMarkedForRemoval.get(view) != null)
		{
			mediatorsMarkedForRemoval.delete(view);
			return;
		}
		
		var viewClassName:String = Type.getClassName(Type.getClass(view));
		var config = mappingConfigByViewClassName.get(viewClassName);
		
		if (config != null && config.autoCreate)
		{
			createMediatorUsing(view, viewClassName, config);
		}
	}
	
	override function onViewRemoved(view:Dynamic):Void
	{
		var config = mappingConfigByView.get(view);

		if (config != null && config.autoRemove)
		{
			removeMediatorByView(view);
		}
	}

	function removeMediatorLater():Void
	{
		for (view in mediatorsMarkedForRemoval)
		{
			if (!contextView.isAdded(view))
			{
				removeMediatorByView(view);
			}
			mediatorsMarkedForRemoval.delete(view);
		}

		hasMediatorsMarkedForRemoval = false;
	}

	function createMediatorUsing(viewComponent:Dynamic, ?viewClassName:String=null, 
		?config:MappingConfig=null):IMediator
	{
		var mediator = mediatorByView.get(viewComponent);
		
		if (mediator == null)
		{
			if (viewClassName == null)
			{
				viewClassName = Type.getClassName(Type.getClass(viewComponent));
			}

			if (config == null)
			{
				config = mappingConfigByViewClassName.get(viewClassName);
			}

			if (config != null)
			{
				for (claxx in config.typedViewClasses) 
				{
					injector.mapValue(claxx, viewComponent);
				}

				mediator = injector.instantiate(config.mediatorClass);

				for (clazz in config.typedViewClasses) 
				{
					injector.unmap(clazz);
				}

				registerMediator(viewComponent, mediator);
			}
		}

		return mediator;			
	}
}

class MappingConfig
{
	public function new(){}

	public var mediatorClass:Class<Dynamic>;
	public var typedViewClasses:Array<Dynamic>;
	public var autoCreate:Bool;
	public var autoRemove:Bool;
}
