package mmvc.base;

import mcore.data.Dictionary;
import msignal.Signal;
import mmvc.api.ICommandMap;
import mmvc.api.IGuardedCommandMap;
import minject.Injector;
import mmvc.api.IGuard;
import mmvc.api.ICommand;

class GuardedCommandMap extends CommandMap, implements IGuardedCommandMap
{
	public function new(injector:Injector)
	{
		super(injector);
	}

	@IgnoreCover
	public function mapGuardedSignal(signal:AnySignal, commandClass:CommandClass, guards:GuardClassArray, oneShot:Bool=false):Void
	{
		mapGuardedSignalWithFallback(signal, commandClass, null, guards, oneShot);
	}

	@IgnoreCover
	public function mapGuardedSignalClass(signalClass:SignalClass, commandClass:CommandClass, guards:GuardClassArray, oneShot:Bool=false):AnySignal
	{
		return mapGuardedSignalClassWithFallback(signalClass, commandClass, null, guards, oneShot);
	}
	
	@IgnoreCover
	public function mapGuardedSignalWithFallback(signal:AnySignal, commandClass:CommandClass, fallbackCommandClass:CommandClass, guards:GuardClassArray, oneShot:Bool=false):Void
	{
		if (hasSignalCommand(signal, commandClass))
		{
			return;
		}

		var signalCommandMap:Dictionary<CommandClass, Dynamic>;

		if (!signalMap.exists(signal))
		{
			signalCommandMap = new Dictionary<CommandClass, Dynamic>();
			signalMap.set(signal, signalCommandMap);
		}
		else
		{
			signalCommandMap = signalMap.get(signal);
		}

		var me = this;
		var callbackFunction = Reflect.makeVarArgs(function(args)
		{
			me.routeSignalToGuardedCommand(signal, args, commandClass, fallbackCommandClass, oneShot, guards);
		});

		signalCommandMap.set(commandClass, callbackFunction);
		signal.add(callbackFunction);
	}

	@IgnoreCover
	public function mapGuardedSignalClassWithFallback(signalClass:SignalClass, commandClass:CommandClass, fallbackCommandClass:CommandClass, guards:GuardClassArray, oneShot:Bool=false):AnySignal
	{
		var signal = getSignalClassInstance(signalClass);
		mapGuardedSignalWithFallback(signal, commandClass, fallbackCommandClass, guards, oneShot);
		return signal;
	}

	@IgnoreCover
	function routeSignalToGuardedCommand(signal:AnySignal, valueObjects:Array<Dynamic>, commandClass:CommandClass, fallbackCommandClass:CommandClass, oneshot:Bool, guardClasses:GuardClassArray):Void
	{
		mapSignalValues(signal.valueClasses, valueObjects);

		var approved:Bool = true;
		
		for (guardClass in guardClasses)
		{
			var nextGuard:IGuard = injector.instantiate(guardClass);
			approved = (approved && nextGuard.approve());

			if ((!approved) && (fallbackCommandClass == null))
			{
				unmapSignalValues(signal.valueClasses, valueObjects);
				return;
			}
		}
		
		var commandToInstantiate:Class<Dynamic> = approved ? commandClass : fallbackCommandClass;

		var command:ICommand = injector.instantiate(commandToInstantiate);
		unmapSignalValues(signal.valueClasses, valueObjects);
		command.execute();

		if (oneshot)
		{
			unmapSignal(signal, commandClass);
		}
	}
}
