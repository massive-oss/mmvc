/*
* Copyright (c) 2009, 2010 the original author or authors
*
* Permission is hereby granted to use, modify, and distribute this file
* in accordance with the terms of the license agreement accompanying it.
*/

package m.mvc.base;

import m.inject.IInjector;
import m.mvc.api.IViewContainer;

/**
 * A base ViewMap implementation
 */
class ViewMapBase
{
	public var contextView(default, set_contextView):IViewContainer;
	public var enabled(default, set_enabled):Bool;
	
	/**
	 * @private
	 */
	var injector:IInjector;

	/**
	 * @private
	 */
	var useCapture:Bool;
	
	/**
	 * @private
	 */		
	var viewListenerCount:Int;

	//---------------------------------------------------------------------
	// Constructor
	//---------------------------------------------------------------------

	/**
	 * Creates a new <code>ViewMap</code> object
	 *
	 * @param contextView The root view node of the context. The map will listen for ADDED_TO_STAGE events on this node
	 * @param injector An <code>IInjector</code> to use for this context
	 */
	public function new(contextView:IViewContainer, injector:IInjector)
	{
		viewListenerCount = 0;
		enabled = true;

		this.injector = injector;

		// change this at your peril lest ye understand the problem and have a better solution
		this.useCapture = true;

		// this must come last, see the setter
		this.contextView = contextView;
	}

	//---------------------------------------------------------------------
	// API
	//---------------------------------------------------------------------
	
	/**
	 * @inheritDoc
	 */
	public function set_contextView(value:IViewContainer):IViewContainer
	{
		if (value != contextView)
		{
			removeListeners();
			
			contextView = value;

			if (viewListenerCount > 0)
			{
				addListeners();
			}
		}
		
		return contextView;
	}

	/**
	 * @inheritDoc
	 */
	public function set_enabled(value:Bool):Bool
	{
		if (value != enabled)
		{
			removeListeners();
			
			enabled = value;
			
			if (viewListenerCount > 0)
			{
				addListeners();
			}
		}

		return value;
	}

	//---------------------------------------------------------------------
	// Internal
	//---------------------------------------------------------------------

	/**
	 * @private
	 */
	function addListeners():Void
	{
	}

	/**
	 * @private
	 */
	function removeListeners():Void
	{
	}

	/**
	 * @private
	 */
	function onViewAdded(view:Dynamic):Void
	{
	}

	/**
	 * @private
	 */
	function onViewRemoved(view:Dynamic):Void
	{
	}
}
