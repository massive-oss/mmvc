Overview 
====================

**MassiveMVC** (mmvc) is a light but powerful IOC framework utilizing Signals and macro based injection.

### Links

MMVC is based off RobotLegs, with enhanced with signals and macros.

* <http://www.robotlegs.org/>
* <http://joelhooks.com/2010/02/14/robotlegs-as3-signals-and-the-signalcommandmap-example/>


### Dependencies

MassiveMVC leverages several libraries available in MassiveCore. For more information refer to <http://ui.massive.com.au/api/1.5.0/mcore/>

* **Signals** - m.signal package as a substitue for event triggered commands.
* **IOC Injector** - m.inject package (and RTTI macros)


Getting Started
====================

Context
-----------------

The context provides the central wiring/mapping of common elements within a contextual scope (eg application).

Usually an application context is instanciated within the main view of an application:


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

	class ApplicationView implements m.mvc.api.IViewContainer
	{
		static var context:ApplicationContext;

		public function new()
		{
			context = new ApplicationContext(this, true);
		}
	}



Commands are mapped to actions (Signals) using the commandMap

	commandMap.mapSignalClass(Dance, DanceCommand);

Actors (e.g. Models) are mapped via the injector:

	injector.mapSigleton(DanceModel);

Standalone actions (Signals) without a corresponding Command can also be mapped via the injector

	injector.mappSingleton(ClapHands);

Mediators are mapped to Views via the mediatorMap

	mediatorMap.mapView(DanceView, DanceViewMediator);



Command
-----------------

To do...

Actor
-----------------

To do...

Mediator
-----------------

To do...

