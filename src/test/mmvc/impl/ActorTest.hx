package mmvc.impl;

import massive.munit.Assert;

class ActorTest
{
	public function new(){}
	
	@Test
	public function passingTest():Void
	{
		var actor = new Actor();
		Assert.isType(actor, Actor);
	}
}
