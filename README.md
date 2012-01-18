MassiveMVC
====================

A light but powerful IOC framework ported from RobotLegs and enhanced with signals and macros.

#### Links
* <http://www.robotlegs.org/>
* <http://joelhooks.com/2010/02/14/robotlegs-as3-signals-and-the-signalcommandmap-example/>


#### About Massive Signals

MassiveMVC leverages the MassiveCore Signal package as a substitue for event triggered commands. For more information on signals refer to <https://github.com/massiveinteractive/MassiveCore>


Context
---------------------

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
---------------------

To do...

Actor
---------------------

To do...

Mediator
---------------------

To do...

