MassiveCore
====================

MassiveCore is a collection of lightweight, indpendent libraries that simplify cross platform development in Haxe:

MassiveData - Data structures and utilities
MassiveInject - Macro enhanced port of Till Schneidereit's AS3 Swift Suspenders IOC solution
MassiveLoader - Unified API for loading data (String, XML, Image, JSON) over HTTP and from the system.
MassiveSignal - Lightweight type safe port of Robert Penner's AS3 Signals

Using MassiveSignal
---------------------

### Import

All required classes can be imported through m.signal.Signal

	import m.signal.Signal;

### Basic usage

	var signal = new Signal0();
	signal.add(function(){ trace("signal dispatched!"); })
	signal.dispatch();

### Extending

	class MySignal extends Signal2<String, Int>
	{
		public function new()
		{
			super(String, Int);
		}
	}

### Typed parameters

	var signal = new Signal1<String>(String);
	signal.add(function(i:Int){}); // error: Int -> Void should be String -> Void
	signal.dispatch(true) // error Bool should be String

Numbers of parameters:

	var signal0 = new Signal0();
	var signal1 = new Signal1<String>(String);
	var signal2 = new Signal2<String, String>(String, String);

Slots:

	var signal = new Signal0();
	var slot = signal.add(function(){});
	slot.enabled = false;
	signal.dispatch(); // slot will not dispatch

Slot parameters:

	var signal2 = new Signal2<String, String>(String, String);
	var slot = signal.add(function(s1, s2){ trace(s1 + " " + s2); });
	slot.param1 = "Goodbye";
	signal.dispatch("Hello", "Mr Bond"); // traces: Goodbye Mr Bond

