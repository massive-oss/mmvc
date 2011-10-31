package m.mvc.api;

import m.signal.Signal;
import m.mvc.api.ICommand;
import m.mvc.api.ICommandMap;
import m.mvc.api.IGuard;

typedef GuardClassArray = Array<Class<IGuard>>;

interface IGuardedCommandMap implements ICommandMap
{
	/**
	 * Map a Command to an instance of a Signal, with Guards
	 * 
	 * <p>The <code>signal</code> - an instance of ISignal</p>
	 * <p>The <code>commandClass</code> must implement an execute() method</p>
	 * <p>The <code>guards</code> must be a Class which implements an approve() method</p>
	 * <p>or an <code>Array</code> of Classes which implements an approve() method</p>
	 *
	 * @param signal The signal instance to trigger this command. Values dispatched by this signal are available for injection into guards and the command.
	 * @param commandClass The Class to instantiate - must have an execute() method
	 * @param guards The Classes of the guard or guards to instantiate - must have an approve() method
	 * @param oneshot Unmap the Class after execution?
	 * 
	 * @throws org.robotlegs.base::ContextError
	*/
	function mapGuardedSignal(signal:AnySignal, commandClass:CommandClass, guards:GuardClassArray, oneshot:Bool=false):Void;
	
	/**
	 * Map a Command to an instance of a Signal, with Guards
	 * 
	 * <p>The <code>signalClass</code> - a Class implementing ISignal</p>
	 * <p>The <code>commandClass</code> must implement an execute() method</p>
	 * <p>The <code>guards</code> must be a Class which implements an approve() method</p>
	 * <p>or an <code>Array</code> of Classes which implements an approve() method</p>
	 *
	 * @param commandClass The signal class to be created - an instance of this Class is then available for injection as a singleton in the main Injector.
	 * @param commandClass The Class to instantiate - must have an execute() method
	 * @param guards The Classes of the guard or guards to instantiate - must have an approve() method
	 * @param oneshot Unmap the Class after execution?
	 * 
	 * @throws org.robotlegs.base::ContextError
	 */
	 function mapGuardedSignalClass(signalClass:SignalClass, commandClass:CommandClass, guards:GuardClassArray, oneShot:Bool=false):AnySignal;
	
	/**
	 * Map a Command to an instance of a Signal, with Guards and a fallback Command
	 * 
	 * <p>The <code>signal</code> - an instance of ISignal</p>
	 * <p>The <code>commandClass</code> must implement an execute() method - executed if the guards approve</p>
	 * <p>The <code>fallbackCommandClass</code> must implement an execute() method - executed if the guards disapprove</p>
	 * <p>The <code>guards</code> must be a Class which implements an approve() method</p>
	 * <p>or an <code>Array</code> of Classes which implements an approve() method</p>
	 *
	 * @param signal The signal instance to trigger this command. Values dispatched by this signal are available for injection into guards and the command.
	 * @param commandClass The Class to instantiate - must have an execute() method - exeecuted if the guards approve
	 * @param fallbackCommandClass The Class to instantiate - must have an execute() method - executed if the guards disapprove
	 * @param guards The Classes of the guard or guards to instantiate - must have an approve() method
	 * @param oneshot Unmap the Class after execution?
	 * 
	 * @throws org.robotlegs.base::ContextError
	*/
	function mapGuardedSignalWithFallback(signal:AnySignal, commandClass:CommandClass, fallbackCommandClass:CommandClass, guards:GuardClassArray, oneShot:Bool=false):Void;
	
	/**
	 * Map a Command to an instance of a Signal, with Guards and a fallback Command 
	 * 
	 * <p>The <code>signalClass</code> - a Class implementing ISignal</p>
	 * <p>The <code>commandClass</code> must implement an execute() method - executed if the guards approve</p>
	 * <p>The <code>fallbackCommandClass</code> must implement an execute() method - executed if the guards disapprove</p>
	 * <p>The <code>guards</code> must be a Class which implements an approve() method</p>
	 * <p>or an <code>Array</code> of Classes which implements an approve() method</p>
	 *
	 * @param signal The signal class to be created - an instance of this Class is then available for injection as a singleton in the main Injector.
	 * @param commandClass The Class to instantiate - must have an execute() method - executed if the guards approve
	 * @param fallbackCommandClass The Class to instantiate - must have an execute() method - executed if the guards disapprove
	 * @param guards The Classes of the guard or guards to instantiate - must have an approve() method
	 * @param oneshot Unmap the Class after execution?
	 * 
	 * @throws org.robotlegs.base::ContextError
	 */
	 function mapGuardedSignalClassWithFallback(signalClass:SignalClass, commandClass:CommandClass, fallbackCommandClass:CommandClass, guards:GuardClassArray, oneShot:Bool=false):AnySignal;
}
