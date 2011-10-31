/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/

package m.mvc.api;


/**
 * The Robotlegs Mediator contract
 */
interface IMediator
{
	/**
	 * Should be invoked by the <code>IMediatorMap</code> during <code>IMediator</code> registration
	 */
	function preRegister():Void;
	
	/**
	 * Should be invoked by the <code>IMediator</code> itself when it is ready to be interacted with
	 *
	 * <p>Override and place your initialization code here</p>
	 */
	function onRegister():Void;
	
	/**
	 * Invoked when the <code>IMediator</code> has been removed by the <code>IMediatorMap</code>
	 */
	function preRemove():Void;
	
	/**
	 * Should be invoked by the <code>IMediator</code> itself when it is ready to for cleanup
	 *
	 * <p>Override and place your cleanup code here</p>
	 */
	function onRemove():Void;
	
	/**
	 * The <code>IMediator</code>'s view component
	 *
	 * @return The view component
	 */
	function getViewComponent():Dynamic;
	
	/**
	 * The <code>IMediator</code>'s view component
	 *
	 * @param The view component
	 */
	function setViewComponent(viewComponent:Dynamic):Void;

}
