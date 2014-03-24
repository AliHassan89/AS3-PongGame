package objects
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Paddle extends Sprite
	{
		private var paddle:Image;
		
		public function Paddle()
		{
			super();
			paddle = new Image(Assets.getTexture("Bar"));
			this.addChild(paddle);
		}
	}
}