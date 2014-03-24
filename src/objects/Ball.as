package objects
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Ball extends Sprite
	{
		private const SPEED:int = 1;
		private var ball:Image;
		private var _direction:Number;
		
		private var vx:Number=0;
		private var vy:Number=0;
		
		public function Ball()
		{
			super();
			
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		/**
		 * Creates a new ball inititalize its position and adds it to the
		 * display list
		 */ 
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			ball = new Image(Assets.getTexture("Ball"));
			this.x = (stage.stageWidth/2) - (ball.width/2);
			this.y = Math.abs((Math.random() * stage.stageHeight) - ball.width * 4);
			this.addChild(ball);
			ball.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/**
		 * Updates x and y cooridnates of ball on every frame according to 
		 * velocity calculated in moveBall function.
		 */ 
		private function onEnterFrame(event:Event):void
		{
			this.x += vx;
			this.y += vy;
		}
		
		/**
		 * Calculates velocity in x and y direction
		 */ 
		public function moveBall(direction:Number):void
		{
			_direction = direction;
			vx = SPEED * Math.cos(direction);
			vy = SPEED * Math.sin(direction);
		}
		
		/**
		 * Returns direction of ball
		 */ 
		public function get direction():Number
		{
			return _direction;
		}
	}
}