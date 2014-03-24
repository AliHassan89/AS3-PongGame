package logic
{
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class GameInitialize extends Sprite
	{
		public function GameInitialize()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		/**
		 * New Game object is created and added to display list
		 */ 
		private function onAddedToStage(event:Event):void
		{
			var gameWidth:int = 700;
			var gameHeight:int = 500;
			var screenInGame:Game = new Game(gameWidth, gameHeight);
			this.addChild(screenInGame);
		}
	}
}