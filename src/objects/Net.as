package objects
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Net extends Sprite
	{
		private var net:Image;
		
		public function Net()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
			
			net = new Image(Assets.getTexture("Net"));
			net.x = (stage.stageWidth/2) - (net.width/2);
			net.y = 0;
			this.addChild(net);
		}
	}
}