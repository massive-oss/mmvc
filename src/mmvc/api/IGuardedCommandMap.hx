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

package mmvc.api;

import msignal.Signal;
import mmvc.api.ICommand;
import mmvc.api.ICommandMap;
import mmvc.api.IGuard;

typedef GuardClassArray = Array<Class<IGuard>>;

interface IGuardedCommandMap implements ICommandMap
{
	/**
	Map a Command to an instance of a Signal, with Guards
	
	<p>The <code>signal</code> - an instance of ISignal</p>
	<p>The <code>commandClass</code> must implement an execute() method</p>
	<p>The <code>guards</code> must be a Class which implements an approve() 
	method</p>
	<p>or an <code>Array</code> of Classes which implements an approve() 
	method</p>
	
	@param signal The signal instance to trigger this command. Values 
	dispatched by this signal are available for injection into guards and the 
	command.
	@param commandClass The Class to instantiate - must have an execute() 
	method
	@param guards The Classes of the guard or guards to instantiate - must
	have an approve() method
	@param oneshot Unmap the Class after execution?
	
	@throws mmvc.base.ContextError
	*/
	function mapGuardedSignal(signal:AnySignal, 
		commandClass:CommandClass, guards:GuardClassArray, 
		oneshot:Bool=false):Void;
	
	/**
	Map a Command to an instance of a Signal, with Guards
	
	<p>The <code>signalClass</code> - a Class implementing ISignal</p>
	<p>The <code>commandClass</code> must implement an execute() method</p>
	<p>The <code>guards</code> must be a Class which implements an approve() 
	method</p>
	<p>or an <code>Array</code> of Classes which implements an approve() 
	method</p>
	
	@param commandClass The signal class to be created - an instance of this 
	Class is then available for injection as a singleton in the main Injector.
	@param commandClass The Class to instantiate - must have an execute() 
	method
	@param guards The Classes of the guard or guards to instantiate - must 
	have an approve() method
	@param oneshot Unmap the Class after execution?
	
	@throws mmvc.base.ContextError
	*/
	function mapGuardedSignalClass(signalClass:SignalClass, 
		commandClass:CommandClass, guards:GuardClassArray, 
		oneShot:Bool=false):AnySignal;
	
	/**
	Map a Command to an instance of a Signal, with Guards and a fallback 
	Command
	
	<p>The <code>signal</code> - an instance of ISignal</p>
	<p>The <code>commandClass</code> must implement an execute() method - 
	executed if the guards approve</p>
	<p>The <code>fallbackCommandClass</code> must implement an execute() method 
	- executed if the guards disapprove</p>
	<p>The <code>guards</code> must be a Class which implements an approve() 
	method</p>
	<p>or an <code>Array</code> of Classes which implements an approve() 
	method</p>
	
	@param signal The signal instance to trigger this command. Values 
	dispatched by this signal are available for injection into guards and the 
	command.
	@param commandClass The Class to instantiate - must have an execute() 
	method - exeecuted if the guards approve
	@param fallbackCommandClass The Class to instantiate - must have an 
	execute() method - executed if the guards disapprove
	@param guards The Classes of the guard or guards to instantiate - must have 
	an approve() method
	@param oneshot Unmap the Class after execution?
	
	@throws mmvc.base.ContextError
	*/
	function mapGuardedSignalWithFallback(signal:AnySignal, 
		commandClass:CommandClass, fallbackCommandClass:CommandClass, 
		guards:GuardClassArray, oneShot:Bool=false):Void;
	
	/**
	Map a Command to an instance of a Signal, with Guards and a fallback 
	Command 
	
	<p>The <code>signalClass</code> - a Class implementing ISignal</p>
	<p>The <code>commandClass</code> must implement an execute() method - 
	executed if the guards approve</p>
	<p>The <code>fallbackCommandClass</code> must implement an execute() method 
	- executed if the guards disapprove</p>
	<p>The <code>guards</code> must be a Class which implements an approve() 
	method</p>
	<p>or an <code>Array</code> of Classes which implements an approve() 
	method</p>
	
	@param signal The signal class to be created - an instance of this Class is 
	then available for injection as a singleton in the main Injector.
	@param commandClass The Class to instantiate - must have an execute() 
	method - executed if the guards approve
	@param fallbackCommandClass The Class to instantiate - must have an 
	execute() method - executed if the guards disapprove
	@param guards The Classes of the guard or guards to instantiate - must have 
	an approve() method
	@param oneshot Unmap the Class after execution?
	
	@throws mmvc.base.ContextError
	*/
	function mapGuardedSignalClassWithFallback(signalClass:SignalClass, 
		commandClass:CommandClass, fallbackCommandClass:CommandClass, 
		guards:GuardClassArray, oneShot:Bool=false):AnySignal;
}
