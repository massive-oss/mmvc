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

package mmvc.base;

import mdata.Dictionary;
import msignal.Signal;
import mmvc.api.ICommandMap;
import mmvc.api.IGuardedCommandMap;
import minject.Injector;
import mmvc.api.IGuard;
import mmvc.api.ICommand;

class GuardedCommandMap extends CommandMap implements IGuardedCommandMap
{
	public function new(injector:Injector)
	{
		super(injector);
	}

	@:IgnoreCover
	public function mapGuardedSignal(signal:AnySignal, commandClass:CommandClass, guards:GuardClassArray, oneShot:Bool=false):Void
	{
		mapGuardedSignalWithFallback(signal, commandClass, null, guards, oneShot);
	}

	@:IgnoreCover
	public function mapGuardedSignalClass(signalClass:SignalClass, commandClass:CommandClass, guards:GuardClassArray, oneShot:Bool=false):AnySignal
	{
		return mapGuardedSignalClassWithFallback(signalClass, commandClass, null, guards, oneShot);
	}
	
	@:IgnoreCover
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

	@:IgnoreCover
	public function mapGuardedSignalClassWithFallback(signalClass:SignalClass, commandClass:CommandClass, fallbackCommandClass:CommandClass, guards:GuardClassArray, oneShot:Bool=false):AnySignal
	{
		var signal = getSignalClassInstance(signalClass);
		mapGuardedSignalWithFallback(signal, commandClass, fallbackCommandClass, guards, oneShot);
		return signal;
	}

	@:IgnoreCover
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
