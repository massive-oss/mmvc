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

package mmvc.impl;
import msignal.Signal;
import minject.Injector;
import mmvc.api.ICommandMap;
import mmvc.api.ICommand;
import mmvc.api.IMediatorMap;
import mmvc.api.IViewContainer;

/**
	Abstract MVCS command implementation
**/
@:keepSub class Command implements ICommand
{
	@inject public var contextView:IViewContainer;
	
	@inject public var commandMap:ICommandMap;
	
	@inject public var injector:Injector;
	
	@inject public var mediatorMap:IMediatorMap;

	@inject public var signal:AnySignal;

	public function new():Void {}
	
	public function execute():Void {}
}
