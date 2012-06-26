package ;

class Main
{
	/**
	Instanciates the main ApplicationView and the ApplicationContext.
	This will trigger the ApplicationViewMediator and kick the application off.
	*/
	public static function main()
	{
		var view = new example.app.ApplicationView();
		var context = new example.app.ApplicationContext(view);
	}
}