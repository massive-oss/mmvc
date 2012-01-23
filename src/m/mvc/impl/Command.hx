package m.mvc.impl;

import m.inject.IInjector;
import m.mvc.api.ICommandMap;
import m.mvc.api.ICommand;
import m.mvc.api.IMediatorMap;
import m.mvc.api.IViewContainer;

/**
Abstract MVCS command implementation
*/
class Command implements ICommand
{
	@inject public var contextView:IViewContainer;
	
	@inject public var commandMap:ICommandMap;
	
	@inject public var injector:IInjector;
	
	@inject public var mediatorMap:IMediatorMap;
	
	public function new():Void {}
	
	public function execute():Void {}
}
