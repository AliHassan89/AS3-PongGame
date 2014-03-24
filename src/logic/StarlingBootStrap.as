package logic
{
	import flash.display.Stage;
	
	import starling.core.Starling;
	import starling.display.Stage;
	
	public class StarlingBootStrap
	{
		private var myStarling:Starling;
		
		public function StarlingBootStrap(flashStage:flash.display.Stage)
		{
			myStarling = new Starling(GameInitialize, flashStage);
			myStarling.antiAliasing = 1;
			myStarling.start();
		}
	}
}