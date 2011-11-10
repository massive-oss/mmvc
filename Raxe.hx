class Raxe implements raxe.Module
{
	public function new(){}
	
	public function setup(app:raxe.Build)
	{
		app.set(
		{
			app:
			{
				id:"mmvc",
				version:"1.0.0.0",
				tag:"ALPHA"
			},
			haxelib:
			{
				name:"mmvc",
				url:"http://massive.com.au",
				username:"massive",
				description:"MassiveMVC is a port of the RobotLegs framework, minus events, plus signals.",
				license:"BSD",
				version:"${app.version}",
				tag:"${app.tag}",
				files:
				[
					"src"
				]
			}
		});
		
		app.task("default").require(["build/mmvc.haxelib.zip"]);
	}
}
