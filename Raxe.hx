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
				dependencies:
				{
					mcore:
					{
						name:"mcore"
					}
				},
				files:
				[
					"src"
				]
			},
			ftp:
			{
				server:"ui.massive.com.au",
				username:"admin",
				password:"noJJ2qSaCz5t"
			},
			haxe:
			{
				classPaths:
				{
					mcore:
					{
						path:"lib/mcore/src"
					}
				}
			},
			markdown:
			{
				title:"MassiveMVC"
			}
		});
		
		app.rule("^release haxelib\\.zip ([\\d\\.]+)$")
		.describe("Build a versioned haxelib archive.")
		.action = function(t:raxe.Task)
		{
			var pattern = ~/^release haxelib\.zip ([\d\.]+)$/;
			if (!pattern.match(t.name)) return;
			
			var version = pattern.matched(1);
			raxe.Build.app.args.app.version = version;
			t.task("default").invoke();

			raxe.FTP.put("build/mmvc.haxelib.zip", "release/mmvc/prod/mmvc_" + version + ".zip");
		}

		app.task("configure").action = function(t:raxe.Task)
		{
			var config = function(lib:String) { raxe.Command.run("haxelib dev " + lib + " ${project.path}lib/" + lib, false); }

			config("mcore");
			config("raxe");
		}

		app.task("default").require(["build/mmvc.haxelib.zip"]);
	}
}
