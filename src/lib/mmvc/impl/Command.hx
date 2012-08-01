package mmvc.impl;

import minject.Injector;
import mmvc.api.ICommandMap;
import mmvc.api.ICommand;
import mmvc.api.IMediatorMap;
import mmvc.api.IViewContainer;

/**
Abstract MVCS command implementation
*/
class Command implements ICommand
{
	@inject public var contextView:IViewContainer;
	
	@inject public var commandMap:ICommandMap;
	
	@inject public var injector:Injector;
	
	@inject public var mediatorMap:IMediatorMap;
	
	public function new():Void {}
	
	public function execute():Void {}
}
