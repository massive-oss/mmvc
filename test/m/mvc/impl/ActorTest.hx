package m.mvc.impl;

import massive.munit.Assert;

// dp: need to rethink this sans-evants
class ActorTest
{
	public function new(){}
	
	@Before
	public function before():Void
	{
	}
	
	@After
	public function after():Void
	{
	}

	@Test
	public function passingTest():Void
	{
		Assert.isTrue(true);
	}
}
