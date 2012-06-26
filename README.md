Overview 
====================

### Intro

**MassiveMVC** (MMVC) is a light but powerful IOC framework utilizing Signals and macro based injection.


MMVC is based off RobotLegs, adapted to better leverage features of the Haxe language like Generics, Macros, etc

* <http://www.robotlegs.org/>
* <http://joelhooks.com/2010/02/14/robotlegs-as3-signals-and-the-signalcommandmap-example/>


### Installation

MMVC is available via Haxelib

	haxelib install mmvc


### Dependencies

MassiveMVC leverages several libraries available in MassiveCore (MCore), including:

* **Signals** - m.signal package as a substitue for event triggered commands.
* **IOC Injector** - m.inject package (and RTTI macros)

To manually install MCore via haxelib (only if compiling against source)

	haxelib install mcore

For more information on MCore see <http://github.com/massiveinteractive/MassiveCore>

### Examples

If you are familiar with RobotLegs, you may want to jump directly into the example reference app in the example directory. This contains a simple Todo list application demonstrating the main components of MMVC, running across JS, Flash and Neko targets.

Otherwise read on :)


--------------

Getting Started
====================


What is MMVC
-------------

MMVC is a Dependency Injection framework based off RobotLegs (see <https://github.com/robotlegs/robotlegs-framework/wiki/Best-Practices> for more information).

It provides a robust, modular, testable pattern for the Model-View-Controller design pattern.

It's recommended to first read the above RobotLegs documentation if you are unfamiliar with the concepts outlined below.


* Injectors
* Context
* Actors and Models
* Signals 
* Commands
* View Mediators


Injectors
-----------

Injectors provide a dependency injection mechanism for framework classes.

	@inject something:Something; 

> Injection is implemented via macros using MCore's Injector. See MCore's m.inject package for more details and examples



Context
-----------------

The context provides the central wiring/mapping of common elements within a contextual scope (eg application).

### Creating a Context 

Contexts must extend m.mvc.impl.Context and override the startup method to map appropriate actors, commands and mediators

Generally a context is defined at an application level

	class ApplicationContext extends m.mvc.impl.Context
	{
		public function new(?contextView:IViewContainer=null, ?autoStartup:Bool=true)
		{
			super(contextView, autoStartup);
		}

		override public function startup():Void
		{
			//map commands/models/mediators here
		}
	}

### Wiring the Context

Models are mapped via the injector:

	injector.mapSigleton(DanceModel);


Commands are mapped to actions (Signals) using the commandMap in the Context

	commandMap.mapSignalClass(Dance, DanceCommand);


Standalone actions (Signals) without a corresponding Command can also be mapped via the injector

	injector.mapSingleton(ClapHands);

Mediators are mapped to Views via the mediatorMap

	mediatorMap.mapView(DanceView, DanceViewMediator);


### Initializeing the Context

Usually an application context is instanciated within the main view of an application:

	class ApplicationView implements m.mvc.api.IViewContainer
	{
		static var context:ApplicationContext;

		public function new()
		{
			context = new ApplicationContext(this, true);
		}
	}

Or externally in the Main haxe file
	
	class Main
	{
		public static function main()
		{
			var view = new ApplicationView();
			var context = newApplicationContext(view);
		}
	}
	


Actors (Models)
-----------------

Actor is a generic term for an application class that is wired into the Context. Generally these take the form of **Models** (typed Appication data structures)


### Mapping Actors

Actors are mapped via the injector:

	injector.mapSigleton(DanceModel);


### Example

By default actors don't require any interface or inheritance to be mapped in the context.

However if a actors requires references to other application parts it should extend m.mvc.impl.Actor


	class DanceModel extends m.mvc.impl.Actor
	{
		public inline static var STYLE_WALTZ = "waltz";
		public inline static var STYLE_FOXTROT = "foxtrot";

		@inject something:Something;

		public var dancer:String;
		public var style:String;

		public function new()
		{
			...
		}
	}


Signal
----------

Signals are highly scalable and lightweight alternative to Events. MCore Signals leverage Haxe generics to provide a strictly typed contract between dispatcher (Signal) and it's listeners.

> See MCore's m.signal package for more details and examples on working with Signals

Application signals represent unique actions or events within an application.


### Mapping Signals

The can be mapped to an associated Command via the Context

	commandMap.mapSignalClass(Dance, DanceCommand);

They can also be mapped as a standalone actor

	injector.mapSingleton(DoSomething);

### Example

A simple example Signal with a signal dispatcher argument:

	class Dance extends m.signal.Signal1<String>
	{
		inline static public var FOX_TROT = "foxtrot";
		inline static public var WALTZ = "waltz";

		public function new()
		{
			super(String);
		}
	}

And to dispatch the signal

	dance.dispatch(Dance.FOX_TROT);

To add a listener to the signal

	dance.add(danceHandler);

	...

	function danceHandler(style:String)
	{
		trace("Dance style: " + style);
	}


### Responder Signals

Within an application is is often usefull to be able to receive callbacks once a signal has finished or completed.

A good way to achieve this is through child signals.

This example adds a completed signal to dispatch once the dance has been completed.

	class Dance extends m.signal.Signal1<String>
	{
		public var completed:Signal1<String>;

		inline static public var FOX_TROT = "foxtrot";
		inline static public var WALTZ = "waltz";

		public function new()
		{
			super(String);
			completed = new Signal1<String>();
		}
	}


To listen for completion of the Dance

	dance.completed.addOnce(this.danceCompleted);
	dance.dispatch();




Command
-----------------

Commands represent the controller tier of the Application. Commands are generally stateless, short lived objects that provide a single, granular activity within an application.


### Mapping Commands

Commands are mapped to actions (Signals) using the commandMap in the Context

	commandMap.mapSignalClass(Dance, DanceCommand);


### Triggering Commands


Commands are triggered by dispatching the associated Signal from elsewhere within the application (generally a Mediator or other Command)

	dance.dispatch(Dance.FOX_TROT);

### Example


	class DanceCommand extends m.mvc.impl.Command
	{
		@inject
		public var danceModel:DanceModel;

		@inject
		public var dance:Dance;

		@inject
		public var style:String;

		public function new()
		{
			super();
		}

		override public function execute():Void
		{
			//some application logic here

			//dispatch completed once done
			dance.completed.dispatch(style);
		}
	}



Views & Mediator
-----------------

Mediators are used to handle framework interaction with specific View classes, and decouple views from other application components.

This includes:

* listening and responding to application Signals
* listening to the view instance and dispatching application signals in response to user input
* injecting external actors and models into the view during registration  


### Mapping Mediators

Mediators are mapped to Views via the mediatorMap

	mediatorMap.mapView(DanceView, DanceViewMediator);


### Mediating Views

Mediator instances are created automatically when the IViewContainer (generally an ApplicationView) calls the added handler.

Generally a base view class will handle bubbling of added and removed events from the target platform's display heirachy.

See the examples for a reference implementation.

To manually do this call the handler directly

	applicationView.added(viewInstance);

### Accessing a Meditor's view 

The associated view instance can be accesed view the 'view' property

	this.view.doSomething(); 

### Example

This is an example demonstrating integration with both application and view events within a mediator

	class DanceViewMediator extends m.mvc.impl.Mediator<DanceView>
	{
		@inject model:DanceModel;

		@inject dance:Dance;

		public function new()
		{
			super();
		}

		override function onRegister()
		{
			super.onRegister();
			
			view.changeStyle.add(styleChanged);
			
			view.start(model.style);
		}

		override public function onRemove():Void
		{
			super.onRemove();
			view.changeStyle.remove(styleChanged);
		}


		function styleChanged(style:String)
		{
			dance.completed.addOnce(danceCompleted);
			dance.dispatch(style);
		}

		function danceCompleted(newStyle:String)
		{
			view.start(newStyle);
		}
	}

And the view class:

	class DanceView
	{
		public var changeStyle:Signal1<String>

		var style:String;
		
		public function new()
		{
			changeStyle = new Signal1<String>();
		}

		public function start(style:String)
		{
			this.style = style;
			//do something
		}

		public function restart()
		{
			start(style);
		}

		function internallyChangeStyle(newStyle:String)
		{
			changeStyle.dispatch(newStyle);
		}
	}
