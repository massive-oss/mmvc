package task;

import task.Haxe;

class BuildProject extends BuildBase
{
	public function new()
	{
		super();
		
		project.id = "mapp";
		project.name = "MassiveApp";
		project.version = "1.0.0";
		
		haxelib.name = "mapp";
		haxelib.url = "http://massiveinteractive.com";
		haxelib.username = "massive";
		haxelib.description = "MassiveApp is a port of the RobotLegs framework, minus events, plus signals.";
		haxelib.version.set("1.0.0");
		haxelib.file.add("src/m", "m");

		haxelib.dependency.add("mcore");
		haxelib.dependency.add("msignal");

		haxe.library.add("mcore");
		haxe.library.add("msignal");
		
		task("ci").require(["test neko as3 js", "build haxelib.zip"]);
	}
}
