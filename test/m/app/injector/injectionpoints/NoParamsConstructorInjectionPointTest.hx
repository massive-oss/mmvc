package m.app.injector.injectionpoints;

import massive.munit.Assert;

class NoParamsConstructorInjectionPointTest
 {
	public function new(){}
	
	@Test
	public function noParamsConstructorInjectionPointIsConstructed():Void
	{
		var injectionPoint = new NoParamsConstructorInjectionPoint();
		Assert.isTrue(Std.is(injectionPoint, NoParamsConstructorInjectionPoint));
		//"Class doesn't do anything except get constructed"
	}
}
