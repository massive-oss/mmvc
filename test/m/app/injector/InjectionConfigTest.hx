package m.app.injector;

import massive.munit.Assert;

import m.app.injector.injectionresults.InjectClassResult;
import m.app.injector.injectionresults.InjectOtherRuleResult;
import m.app.injector.injectionresults.InjectSingletonResult;
import m.app.injector.injectionresults.InjectValueResult;
import m.app.injector.support.types.Class1;
import m.app.injector.support.types.Class1Extension;

class InjectionConfigTest
 {
	public function new(){}
	
	var injector:Injector;
	
	@Before
	public function setup()
	{
		injector = new Injector();
	}

	@After
	public function teardown()
	{
		injector = null;
	}
	
	@Test
	public function configIsInstantiated():Void
	{
		var config = new InjectionConfig(Class1, "");
		Assert.isTrue(Std.is(config, InjectionConfig));
	}
	
	@Test
	public function injectionTypeValueReturnsRespone():Void
	{
		var response = new Class1();
		var config = new InjectionConfig(Class1, "");
		config.setResult(new InjectValueResult(response));
		var returnedResponse = config.getResponse(injector);
		
		Assert.areEqual(response, returnedResponse);
	}
	
	@Test
	public function injectionTypeClassReturnsRespone():Void
	{
		var config = new InjectionConfig(Class1, "");
		config.setResult(new InjectClassResult(Class1));
		var returnedResponse = config.getResponse(injector);
		
		Assert.isTrue(Std.is(returnedResponse, Class1));
	}
	
	@Test
	public function injectionTypeSingletonReturnsResponse():Void
	{
		var config = new InjectionConfig(Class1, "");
		config.setResult(new InjectSingletonResult(Class1));
		var returnedResponse = config.getResponse(injector);

		Assert.isTrue(Std.is(returnedResponse, Class1));
	}
	
	@Test
	public function sameSingletonIsReturnedOnSecondResponse():Void
	{
		var config = new InjectionConfig(Class1, "");
		config.setResult(new InjectSingletonResult(Class1));
		var returnedResponse = config.getResponse(injector);
		var secondResponse = config.getResponse(injector);
		
		Assert.areEqual(returnedResponse, secondResponse);
	}

	@Test
	public function sameNamedSingletonIsReturnedOnSecondResponse():Void
	{
		var config = new InjectionConfig(Class1, "named");
		config.setResult(new InjectSingletonResult(Class1));
		var returnedResponse = config.getResponse(injector);
		var secondResponse = config.getResponse(injector);

		Assert.areEqual(returnedResponse, secondResponse);
	}

	@Test
	public function callingSetResultBetweenUsagesChangesResponse():Void
	{
		var config = new InjectionConfig(Class1, '');
		config.setResult(new InjectSingletonResult(Class1));
		var returnedResponse = config.getResponse(injector);
		config.setResult(null);
		config.setResult(new InjectClassResult(Class1));
		var secondResponse = config.getResponse(injector);

		Assert.isFalse(returnedResponse == secondResponse);
	}

	@Test
	public function injectionTypeOtherRuleReturnsOtherRulesResponse():Void
	{
		var config = new InjectionConfig(Class1, "");
		var otherConfig = new InjectionConfig(Class1Extension, "");
		otherConfig.setResult(new InjectClassResult(Class1Extension));
		config.setResult(new InjectOtherRuleResult(otherConfig));
		var returnedResponse = config.getResponse(injector);

		Assert.isTrue(Std.is(returnedResponse, Class1));
		Assert.isTrue(Std.is(returnedResponse, Class1Extension));
	}
}
