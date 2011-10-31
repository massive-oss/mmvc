package task;

import task.Haxe;

class BuildProject extends BuildBase
{
	public function new()
	{
		super();
		
		project.id = "mmvc";
		project.name = "MassiveMVC";
		project.version = "1.0.0";
		
		haxelib.name = "mmvc";
		haxelib.url = "http://massiveinteractive.com";
		haxelib.username = "massive";
		haxelib.description = "MassiveMVC is a port of the RobotLegs framework, minus events, plus signals.";
		haxelib.version.set("1.0.0");
		haxelib.file.add("src/m", "m");

		haxelib.dependency.add("mcore");

		haxe.library.add("mcore");
		
		task("ci").require(["test neko as3 js", "build haxelib.zip"]);
	}
}
