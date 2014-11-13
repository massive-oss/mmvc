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
import com.g.cas.core.api.data.IData;

typedef CommandClass = Class<ICommand>;
typedef SignalClass = Class<AnySignal>;

interface ICommandMap
{
    function mapSignal(signal:AnySignal, commandClass:CommandClass, ?oneShot:Bool=false):Void;

    function mapSignalClass(signalClass:SignalClass, commandClass:CommandClass, ?oneShot:Bool=false):AnySignal;

    function hasSignalCommand(signal:AnySignal, commandClass:CommandClass):Bool;

    function unmapSignal(signal:AnySignal, commandClass:CommandClass):Void;
	
    function unmapSignalClass(signalClass:SignalClass, commandClass:CommandClass):Void;

    function detain(command:ICommand):Void;

    function release(command:ICommand):Void;
	
	function mapSignalValue(signalClass:SignalClass):Void;
	
	function mapAction(inputSignalClass:SignalClass, outputSignalClass:SignalClass, ?data:IData, 
		?guardClasses:Array<Class<IGuard>>, ?checkKeyInputSignal:String):Void;
}
