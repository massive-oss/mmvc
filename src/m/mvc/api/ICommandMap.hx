package m.mvc.api;

import m.signal.Signal;
import m.mvc.api.ICommand;

typedef CommandClass = Class<ICommand>;
typedef SignalClass = Class<AnySignal>;

interface ICommandMap
{
	public var injector:m.inject.IInjector;
    function mapSignal(signal:AnySignal, commandClass:CommandClass, oneShot:Bool=false):Void;

    function mapSignalClass(signalClass:SignalClass, commandClass:CommandClass, oneShot:Bool=false):AnySignal;

    function hasSignalCommand(signal:AnySignal, commandClass:CommandClass):Bool;

    function unmapSignal(signal:AnySignal, commandClass:CommandClass):Void;
	
    function unmapSignalClass(signalClass:SignalClass, commandClass:CommandClass):Void;

    function detain(command:ICommand):Void;

    function release(command:ICommand):Void;
}
