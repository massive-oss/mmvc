/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/

package m.mvc.api;

/**
 * The Robotlegs Context contract
 */
interface IContext
{
	var commandMap(get_commandMap, null):ICommandMap;
}
