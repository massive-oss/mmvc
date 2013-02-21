## Overview 

MassiveMVC is a light but powerful IOC framework utilizing Signals and macro based injection

MassiveMVC is a port of the excellent AS3 [RobotLegs](https://github.com/robotlegs/robotlegs-framework/tree/master) framework, optimised to better leverage features of the Haxe language like generics, macros. It also does away with event based command mapping, instead favouring signal based mapping based on [Joel Hooks SignalCommandMap](http://joelhooks.com/2010/02/14/robotlegs-as3-signals-and-the-signalcommandmap-example/) concept. This enables portability away from the Flash platform.

### Installation

MMVC is available from Haxelib

	haxelib install mmvc


### Dependencies

MassiveMVC depends on two other Massive libraries also available from haxelib: [msignal](https://github.com/massiveinteractive/msignal) and [minject](https://github.com/massiveinteractive/minject).

### Examples

If you are familiar with RobotLegs, you may want to jump directly into the example [reference app](https://github.com/massiveinteractive/mmvc/tree/master/example). This contains a simple todo list application demonstrating the main components of MMVC, running across JS, Flash and Neko targets.

Otherwise read on :)


## Getting Started


### What is MMVC

MMVC is a Dependency Injection framework based off RobotLegs (see <https://github.com/robotlegs/robotlegs-framework/wiki/Best-Practices> for more information).

It provides a robust, modular, testable pattern for the Model-View-Controller design pattern.

It's recommended to first read the above RobotLegs documentation if you are unfamiliar with the concepts outlined below.

* Injectors
* Context
* Actors and Models
* Signals 
* Commands
* View Mediators

### Injectors

Injectors provide a dependency injection mechanism for framework classes.

	@inject something:Something; 

> Injection is performed by MassiveInject. For more information checkout the [documentation](https://github.com/massiveinteractive/minject/blob/master/README.md) and [examples](https://github.com/massiveinteractive/minject/tree/master/example).

### Context

The context provides the central wiring/mapping of common elements within a contextual scope (eg application).

### Creating a Context 

Contexts must extend mmvc.impl.Context and override the startup method to map appropriate actors, commands and mediators

Generally a context is defined at an application level

	class ApplicationContext extends mmvc.impl.Context
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

#### Wiring the Context

Models are mapped via the injector:

	injector.mapSigleton(DanceModel);


Commands are mapped to actions (Signals) using the commandMap in the Context

	commandMap.mapSignalClass(Dance, DanceCommand);


Standalone actions (Signals) without a corresponding Command can also be mapped via the injector

	injector.mapSingleton(ClapHands);

Mediators are mapped to Views via the mediatorMap

	mediatorMap.mapView(DanceView, DanceViewMediator);


#### Initializing the Context

Usually an application context is instanciated within the main view of an application:

	class ApplicationView implements mmvc.api.IViewContainer
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
	

**Important Caveat**

The IViewContainer (ApplicationView) should be the last mapping in the Context.startup function otherwise other mappings may not be configured:

	function startup()
	{
		//map everything else
		mediatorMap.mapView(ApplicationView, ApplicationViewMediator);
	}


### Actors (models and services)

Actor is a generic term for an application class that is wired into the Context. Generally these take the form of **models** or **services**


#### Mapping Actors

Actors are mapped via the injector:

	injector.mapSigleton(DanceModel);


#### Example

By default actors don't require any interface or inheritance to be mapped in the context.

However if a actors requires references to other application parts it should extend mmvc.impl.Actor


	class DanceModel extends mmvc.impl.Actor
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


### Signal

Signals are highly scalable and lightweight alternative to Events. MassiveSignal leverages Haxe generics to provide a strictly typed contract between dispatcher (Signal) and it's listeners.

> See MassiveSignals's [documentation](https://github.com/massiveinteractive/msignal/blob/master/README.md) and [examples](https://github.com/massiveinteractive/msignal/tree/master/example) for more details and examples on working with Signals.

Application signals represent unique actions or events within an application.


#### Mapping Signals

The can be mapped to an associated Command via the Context

	commandMap.mapSignalClass(Dance, DanceCommand);

They can also be mapped as a standalone actor

	injector.mapSingleton(DoSomething);

#### Example

A simple example Signal with a signal dispatcher argument:

	class Dance extends msignal.Signal1<String>
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


#### Responder Signals

Within an application is is often usefull to be able to receive callbacks once a signal has finished or completed.

A good way to achieve this is through child signals.

This example adds a completed signal to dispatch once the dance has been completed.

	class Dance extends msignal.Signal1<String>
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




### Command

Commands represent the controller tier of the Application. Commands are generally stateless, short lived objects that provide a single, granular activity within an application.


#### Mapping Commands

Commands are mapped to actions (Signals) using the commandMap in the Context

	commandMap.mapSignalClass(Dance, DanceCommand);


#### Triggering Commands


Commands are triggered by dispatching the associated Signal from elsewhere within the application (generally a Mediator or other Command)

	dance.dispatch(Dance.FOX_TROT);

#### Example


	class DanceCommand extends mmvc.impl.Command
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



### Views & Mediator

Mediators are used to handle framework interaction with specific View classes, and decouple views from other application components.

This includes:

* listening and responding to application Signals
* listening to the view instance and dispatching application signals in response to user input
* injecting external actors and models into the view during registration  


#### Mapping Mediators

Mediators are mapped to Views via the mediatorMap

	mediatorMap.mapView(DanceView, DanceViewMediator);


#### Mediating Views

Mediator instances are created automatically when the IViewContainer (generally an ApplicationView) calls the added handler.

Generally a base view class will handle bubbling of added and removed events from the target platform's display heirachy.

See the examples for a reference implementation.

To manually do this call the handler directly

	applicationView.added(viewInstance);

#### Accessing a Meditor's view 

The associated view instance can be accesed view the 'view' property

	this.view.doSomething(); 

#### Example

This is an example demonstrating integration with both application and view events within a mediator

	class DanceViewMediator extends mmvc.impl.Mediator<DanceView>
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
