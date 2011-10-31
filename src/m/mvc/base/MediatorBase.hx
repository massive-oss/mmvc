/*
* Copyright (c) 2009 the original author or authors
*
* Permission is hereby granted to use, modify, and distribute this file
* in accordance with the terms of the license agreement accompanying it.
*/

package m.mvc.base;

import m.mvc.api.IMediator;

/**
 * An abstract <code>IMediator</code> implementation
 */
class MediatorBase<T> implements IMediator
{
	/**
	 * Internal
	 *
	 * <p>This Mediator's View - used by the RobotLegs MVCS framework internally.
	 * You should declare a dependency on a concrete view component in your
	 * implementation instead of working with this property</p>
	 */
	var view:T;
	
	/**
	 * Internal
	 *
	 * <p>In the case of deffered instantiation, onRemove might get called before
	 * onCreationComplete has fired. This here Bool helps us track that scenario.</p>
	 */
	var removed:Bool;
	
	/**
	 * Creates a new <code>Mediator</code> object
	 */
	public function new()
	{
	}
	
	/**
	 * @inheritDoc
	 */
	public function preRegister():Void
	{
		removed = false;
		onRegister();
	}
	
	/**
	 * @inheritDoc
	 */
	public function onRegister():Void
	{
	}
	
	/**
	 * @inheritDoc
	 */
	public function preRemove():Void
	{
		removed = true;
		onRemove();
	}
	
	/**
	 * @inheritDoc
	 */
	public function onRemove():Void
	{
	}
	
	/**
	 * @inheritDoc
	 */
	public function getViewComponent():Dynamic
	{
		return view;
	}
	
	/**
	 * @inheritDoc
	 */
	public function setViewComponent(viewComponent:Dynamic):Void
	{
		view = viewComponent;
	}
}
