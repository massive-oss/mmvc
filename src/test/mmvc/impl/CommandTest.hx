package mmvc.impl;

import massive.munit.Assert;

class CommandTest
{
	public function new(){}
	
	@Test
	public function create_command()
	{
		var command = new Command();
		Assert.isType(command, Command);
		command.execute();
	}
}
