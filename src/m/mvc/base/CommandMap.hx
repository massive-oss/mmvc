package m.mvc.base;

import m.signal.Signal;
import m.inject.IInjector;
import m.mvc.api.ICommand;
import m.mvc.api.ICommandMap;
import m.data.Dictionary;

class CommandMap implements ICommandMap
{
	public var injector:IInjector;
	var signalMap:Dictionary<Dynamic, Dynamic>;
	var signalClassMap:Dictionary<Dynamic, Dynamic>;
	var detainedCommands:Dictionary<Dynamic, Dynamic>;

	public function new(injector:IInjector)
	{
		this.injector = injector;

		signalMap = new Dictionary();
		signalClassMap = new Dictionary();
		detainedCommands = new Dictionary();
	}
	
	public function mapSignal(signal:AnySignal, commandClass:Class<ICommand>, ?oneShot:Bool=false)
	{
		if (hasSignalCommand(signal, commandClass)) return;
		
		var signalCommandMap:Dictionary<Dynamic, Dynamic>;
		if (signalMap.exists(signal))
		{
			signalCommandMap = signalMap.get(signal);
		}
		else
		{
			signalCommandMap = new Dictionary(false);
			signalMap.set(signal, signalCommandMap);
		}
		
		var me = this;
		var callbackFunction = Reflect.makeVarArgs(function(args)
		{
			me.routeSignalToCommand(signal, args, commandClass, oneShot);
		});

		signalCommandMap.set(commandClass, callbackFunction);
		signal.add(callbackFunction);
	}

	public function mapSignalClass(signalClass:SignalClass, commandClass:CommandClass, ?oneShot:Bool=false):AnySignal
	{
		var signal = getSignalClassInstance(signalClass);
		mapSignal(signal, commandClass, oneShot);
		return signal;
	}

	function getSignalClassInstance(signalClass:SignalClass):AnySignal
	{
		if (signalClassMap.exists(signalClass))
		{
			return cast(signalClassMap.get(signalClass), AnySignal);
		}

		var signal = createSignalClassInstance(signalClass);
		signalClassMap.set(signalClass, signal);
		return signal;
	}

	private function createSignalClassInstance(signalClass:SignalClass):AnySignal
	{
		var injectorForSignalInstance = injector;
		var signal:AnySignal;
		
		if (injector.hasMapping(IInjector))
		{
			injectorForSignalInstance = injector.getInstance(IInjector);
		}
		
		signal = injectorForSignalInstance.instantiate(signalClass);
		
		injectorForSignalInstance.mapValue(signalClass, signal);
		signalClassMap.set(signalClass, signal);
		
		if (signalClass == tab.application.submodule.SubmoduleStartupComplete)
		{
			trace(":createSignalClassInstance injector.hasMapping(signalClass) = " + Std.string(injector.hasMapping(signalClass)));
			trace(":createSignalClassInstance injectorForSignalInstance.getInstance(signalClass) = " + Std.string(injectorForSignalInstance.hasMapping(signalClass)));
		}

		return signal;
	}

	public function hasSignalCommand(signal:AnySignal, commandClass:Class<ICommand>):Bool
	{
		var callbacksByCommandClass = signalMap.get(signal);
		if (callbacksByCommandClass == null) return false;
		var callbackFunction = callbacksByCommandClass.get(commandClass);
		return callbackFunction != null;
	}

	public function unmapSignal(signal:AnySignal, commandClass:CommandClass)
	{
		var callbacksByCommandClass = signalMap.get(signal);
		if (callbacksByCommandClass == null) return;
		var callbackFunction = callbacksByCommandClass.get(commandClass);
		if (callbackFunction == null) return;
		signal.remove(callbackFunction);
		callbacksByCommandClass.delete(commandClass);
	}
	
	public function unmapSignalClass(signalClass:SignalClass, commandClass:CommandClass)
	{
		unmapSignal(getSignalClassInstance(signalClass), commandClass);
	}

	function routeSignalToCommand(signal:AnySignal, valueObjects:Array<Dynamic>, commandClass:CommandClass, oneshot:Bool)
	{
		mapSignalValues(signal.valueClasses, valueObjects);
		createCommandInstance(commandClass).execute();
		unmapSignalValues(signal.valueClasses, valueObjects);

		if (oneshot)
		{
			unmapSignal(signal, commandClass);
		}
	}

	function createCommandInstance(commandClass:CommandClass):ICommand
	{
		return injector.instantiate(commandClass);
	}

	function mapSignalValues(valueClasses:Array<Dynamic>, valueObjects:Array<Dynamic>):Void
	{
		for (i in 0...valueClasses.length)
		{
			injector.mapValue(valueClasses[i], valueObjects[i]);
		}
	}

	function unmapSignalValues(valueClasses:Array<Dynamic>, valueObjects:Array<Dynamic>)
	{
		for (i in 0...valueClasses.length)
		{
			injector.unmap(valueClasses[i]);
		}
	}

	public function detain(command:ICommand)
	{
		detainedCommands.set(command, true);
	}

	public function release(command:ICommand)
	{
		if (detainedCommands.get(command) != null)
		{
			detainedCommands.delete(command);
		}
	}
}
