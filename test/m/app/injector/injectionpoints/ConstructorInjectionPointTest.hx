package m.app.injector.injectionpoints;

import massive.munit.Assert;
import m.app.injector.Injector;
import m.app.injector.support.injectees.TwoOptionalParametersConstructorInjectee;
import m.app.injector.support.injectees.TwoParametersConstructorInjectee;
import m.app.injector.support.types.Class1;

class ConstructorInjectionPointTest
 {
	public function new(){}
	
	public static var STRING_REFERENCE:String = "stringReference";

	var injector:Injector;

	@Before
	public function setup():Void
	{
		injector = new Injector();
	}

	@After
	public function teardown():Void
	{
		injector = null;
	}
	
	@Test
	public function passingTest()
	{
		Assert.isTrue(true);
	}
	/*
	@Test
	public function injectionOfTwoUnnamedPropertiesIntoConstructor():Void
	{
		injector.mapSingleton(Class1);
		injector.mapValue(String, STRING_REFERENCE);
		
		var node: XML = XML(InjectionNodes.CONSTRUCTOR_INJECTION_NODE_TWO_ARGUMENT.constructor);
		var injectionPoint:ConstructorInjectionPoint = 
			new ConstructorInjectionPoint(node, TwoParametersConstructorInjectee, injector);
		
		var injectee:TwoParametersConstructorInjectee = 
			cast( injectionPoint.applyInjection(TwoParametersConstructorInjectee, injector), TwoParametersConstructorInjectee);
		
		Assert.isTrue("dependency 1 should be Class1 instance", Std.is( injectee.getDependency(), Class1));		
		Assert.isTrue("dependency 2 should be 'stringReference'", injectee.getDependency2() == STRING_REFERENCE);	
	}
	
	@Test
	public function injectionOfFirstOptionalPropertyIntoTwoOptionalParametersConstructor():Void
	{
		injector.mapSingleton(Class1);
		
		var node:XML = XML(InjectionNodes.CONSTRUCTOR_INJECTION_NODE_TWO_OPTIONAL_PARAMETERS.constructor);
		var injectionPoint:ConstructorInjectionPoint = new ConstructorInjectionPoint(node, TwoParametersConstructorInjectee, injector);
		
		var injectee:TwoOptionalParametersConstructorInjectee = 
			cast( injectionPoint.applyInjection(TwoOptionalParametersConstructorInjectee, injector), TwoOptionalParametersConstructorInjectee);
		
		
		Assert.isTrue("dependency 1 should be Class1 instance", Std.is( injectee.getDependency(), Class1));		
		Assert.isTrue("dependency 2 should be null", injectee.getDependency2() == null);	
	}
	
	@Test
	public function injectionOfSecondOptionalPropertyIntoTwoOptionalParametersConstructor():Void
	{
		injector.mapValue(String, STRING_REFERENCE);
		
		var node = Xml.parse(InjectionNodes.CONSTRUCTOR_INJECTION_NODE_TWO_OPTIONAL_PARAMETERS.constructor);
		var injectionPoint:ConstructorInjectionPoint = new ConstructorInjectionPoint(node, TwoParametersConstructorInjectee, injector);
		
		var injectee:TwoOptionalParametersConstructorInjectee = 
			cast( injectionPoint.applyInjection(TwoOptionalParametersConstructorInjectee, injector), TwoOptionalParametersConstructorInjectee);
		
		
		Assert.isTrue("dependency 1 should be Class1 null", injectee.getDependency() == null);		
		Assert.isTrue("dependency 2 should be null", injectee.getDependency2() == null);	
	}
	*/
}
