package m.app.injector.injectionpoints;

import massive.munit.Assert;
import m.app.injector.Injector;
import m.app.injector.support.injectees.OneRequiredOneOptionalPropertyMethodInjectee;
import m.app.injector.support.injectees.TwoParametersMethodInjectee;
import m.app.injector.support.types.Class1;
import m.app.injector.support.types.Interface1;

class MethodInjectionPointTest
 {
	public function new(){}
	
	var injector:Injector;

	@Before
	public function runBeforeEachTest():Void
	{
		injector = new Injector();
	}

	@After
	public function teardown():Void
	{
		injector = null;
	}

	@Test
	public function injectionOfTwoUnnamedPropertiesIntoMethod():Void
	{
		var injectee = new TwoParametersMethodInjectee();
		var meta = {inject:null, name:["setDependencies"], args:[{type:"m.app.injector.support.types.Class1", opt:false}, {type:"m.app.injector.support.types.Interface1", opt:false}]};
		var injectionPoint = new MethodInjectionPoint(meta);
		
		injector.mapSingleton(Class1);
		injector.mapSingletonOf(Interface1, Class1);
		injectionPoint.applyInjection(injectee, injector);

		Assert.isTrue(Std.is(injectee.getDependency1(), Class1));
		//"dependency 1 should be Class1 instance"	
		Assert.isTrue(Std.is(injectee.getDependency2(), Interface1));
		//"dependency 2 should be Interface"
	}
	
	@Test
	public function injectionOfOneRequiredOneOptionalPropertyIntoMethod():Void
	{
		var injectee = new OneRequiredOneOptionalPropertyMethodInjectee();
		var meta = {inject:null, name:["setDependencies"], args:[{type:"m.app.injector.support.types.Class1", opt:false}, {type:"m.app.injector.support.types.Interface1", opt:true}]};
		var injectionPoint = new MethodInjectionPoint(meta);

		injector.mapSingleton(Class1);
		injectionPoint.applyInjection(injectee, injector);
		
		Assert.isTrue(Std.is(injectee.getDependency1(), Class1));
		//"dependency 1 should be Class1 instance"
		Assert.isTrue(injectee.getDependency2() == null);
		//"dependency 2 should be null"
	}
	
	@Test
	public function gatheringParametersForMethodsWithUnTypedParametersThrowException() : Void
	{
		var meta = {inject:null, name:["test"], args:[{type:"Dynamic", opt:true}]};
		var passed = false;

		try
		{
			var injectionPoint = new MethodInjectionPoint(meta, null);
		}
		catch (e:Dynamic)
		{
			passed = Std.is(e, InjectorError);
		}

		Assert.isTrue(passed);
	}
}
