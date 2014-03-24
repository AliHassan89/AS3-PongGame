package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import logic.StarlingBootStrap;
	
	
	[SWF(frameRate="60", width="700", height="500", backgroundColor = "0x000000")]
	
	public class BigpointPong extends Sprite
	{
		public function BigpointPong()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		/**
		 * Starling bootstrap object is created and stage is passed as argument
		 */ 
		private function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		
			var starlingBootStrap:StarlingBootStrap = new StarlingBootStrap(stage);
		}
	}
}