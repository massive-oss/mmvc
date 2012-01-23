package m.mvc.impl;

import massive.munit.Assert;

// dp: need to rethink this sans-evants
class CommandTest
{
	public function new(){}
	
	@Before
	public function before()
	{
	}
	
	@After
	public function after()
	{
	}
	
	@Test
	public function passingTest()
	{
		Assert.isTrue(true);
	}
}
