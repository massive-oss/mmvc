/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/

package m.app.base.support;

class TestView implements ITestView
{
	@inject("injectionName")
	public var injectionPoint:String;
	
	public function new()
	{
	}
}
