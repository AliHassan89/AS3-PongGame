package logic
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import objects.Ball;
	import objects.HUD;
	import objects.Net;
	import objects.Paddle;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.utils.deg2rad;
	
	public class Game extends Sprite
	{
		/**
		 * Maximum and Minimum angles of the ball which when collieds with
		 * the paddle
		 */ 
		private static const E_MIN:Number = -deg2rad(80);
		private static const E_MAX:Number = deg2rad(80);
		
		/**
		 * Paddle speed at which paddle moves in y axis
		 */ 
		private static const PADDLE_SPEED:int = 10;
		
		
		/**
		 * Width and height of game
		 */ 
		private var gameWidth:int;
		private var gameHeight:int;
		
		/**
		 * Key codes of keys used to move left and right paddles
		 */
		private static const LEFT_PADDLE_UP_KEY:int = 87;
		private static const LEFT_PADDLE_DOWN_KEY:int = 83;
		private static const RIGHT_PADDLE_UP_KEY:int = 38;
		private static const RIGHT_PADDLE_DOWN_KEY:int = 40;
		
		private var net:Net;
		private var leftPaddle:Paddle;
		private var rightPaddle:Paddle;
		private var ball:Ball;		
	
		/**
		 * Initial scores of both the players
		 */ 
		private var rightPaddleScore:int = 0;
		private var leftPaddleScore:int = 0;
		
		private var hudLeft:HUD;
		private var hudRight:HUD;
		
		/**
		 * Game screen boundaries
		 */ 
		private var minX:Number;
		private var maxX:Number;
		private var minY:Number;
		private var maxY:Number;
		
		/**
		 * initial direction of ball when it left the net
		 */ 
		private var initial_direction:Number;
		
		/**
		 * Boolean variable of keyboard keys
		 */ 
		private var wIsDown:Boolean;
		private var sIsDown:Boolean;
		private var upKeyIsDown:Boolean;
		private var downKeyIsDown:Boolean;
		
		private var score_bool:Boolean;
		
		public function Game(gameWidth:int, gameHeight:int)
		{
			super();
			this.gameWidth = gameWidth;
			this.gameHeight = gameHeight;
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			drawGame();
		}
		
		/**
		 * Game objects are instantiated and initialized
		 * KeyBoardEvent and EnterFrame Event listeners are placed
		 * Game boundries are defiened.
		 */ 
		private function drawGame():void
		{
			//Net is created and added to display list
			net = new Net();
			this.addChild(net);
			
			//Left paddle is created and initial position is set
			leftPaddle = new Paddle();
			leftPaddle.x = 3;
			leftPaddle.y = 0;
			this.addChild(leftPaddle);
			
			//Right paddle is created and initial position is set
			rightPaddle = new Paddle();
			this.addChild(rightPaddle);
			rightPaddle.x = gameWidth - rightPaddle.width - 3;
			rightPaddle.y = gameHeight - rightPaddle.height;
			
			//New ball is initialized and added to display list
			ball = new Ball();
			this.addChild(ball);
			ball.moveBall(deg2rad(45));
			
			//Score board for player on left
			hudLeft = new HUD();
			hudLeft.x = 20;
			this.addChild(hudLeft);
			
			//Score board for player on right
			hudRight = new HUD();
			hudRight.x = gameWidth - hudRight.width - 20;
			this.addChild(hudRight);
			
			//Setting boundries of game area
			minX = leftPaddle.width + 3;
			maxX = gameWidth - (rightPaddle.width*2) - 3;
			
			minY = ball.width;
			maxY = gameHeight - ball.width;
			
			//KeyBoard Events listen for PRESSED keys
			this.addEventListener(KeyboardEvent.KEY_DOWN, onLeftKeyDown);
			this.addEventListener(KeyboardEvent.KEY_DOWN, onRightKeyDown);
			
			//KeyBoardEvents listen for UP keys
			this.addEventListener(KeyboardEvent.KEY_UP, onLeftKeyIsUp);
			this.addEventListener(KeyboardEvent.KEY_UP, onRightKeyIsUp);
			
			//EnterFrame events
			this.addEventListener(Event.ENTER_FRAME, onKeyboardEnterFrame);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/**
		 * On every frame it is checked if any of the variables in if condiions
		 * are set to true. If so corresponding function is called.
		 */ 
		private function onKeyboardEnterFrame(event:Event):void
		{
			if(wIsDown)
				moveLeftPaddleUp();
			if(sIsDown)
				moveLeftPaddleDown();
			if(upKeyIsDown)
				moveRightPaddleUp();
			if(downKeyIsDown)
				moveRightPaddleDown();
		}
		
		/**
		 * On every frame this function checks if ball has collieded with any
		 * of the two paddles or ball has come in contact with the walls. If
		 * nither of two then ball must have gone out of game screen bounds
		 * updateScore() function is called.
		 */ 
		private function onEnterFrame(event:Event):void
		{	
			var paddleEdgeToCollisionPointDistance:Number;
			//Checks if X coordinate of ball is in range of X coordinate of
			//left paddle
			if(ball.x <= minX)
			{
				//Checks if the ball has collieded with the paddle
				if(ball.y >= leftPaddle.y && ball.y <= (leftPaddle.height + leftPaddle.y))
				{
					paddleEdgeToCollisionPointDistance = ball.y - leftPaddle.y;
					ball.moveBall(getExitAngle(paddleEdgeToCollisionPointDistance));
				}
				//Updates the score if ball goes out of game boundaries
				else
				{
					this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
					score_bool=true;
					updateScore();
				}
			}
			
			//Checks if X coordinate of ball is in range of X coordinate of
			//right paddle
			else if(ball.x >= maxX)
			{
				//Checks if the ball has collieded with the paddle
				if(ball.y >= rightPaddle.y && ball.y <= (rightPaddle.height + rightPaddle.y))
				{
					paddleEdgeToCollisionPointDistance = ball.y - rightPaddle.y;
					ball.moveBall(Math.PI - getExitAngle(paddleEdgeToCollisionPointDistance));
				}
				//Updates the score if ball goes out of game boundaries
				else
				{
					this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
					updateScore();
				}
			}
			
			// Checks if ball has collieded with the walls thus mirror reflection
			//effect should happen
			else if(ball.y <= minY || ball.y >= maxY)
				ball.moveBall(2*Math.PI - ball.direction);
		}
		
		/**
		 * Updates the score and sets a delay of 1 second before game continues
		 */ 
		private function updateScore():void
		{
			if(score_bool)
			{
				score_bool = false;
				rightPaddleScore++;
				hudRight.setScore(rightPaddleScore);
				initial_direction = deg2rad(45);				
			}
			else
			{
				leftPaddleScore++;
				hudLeft.setScore(leftPaddleScore);
				initial_direction = deg2rad(225);
			}
			this.removeChild(ball);
			ball.dispose();
			
			var timer:Timer = new Timer(1000, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			timer.start();
		}
		
		/**
		 * Creates new instance of ball after one second delay and adds it to
		 * the display list. initial_direction variable guides the ball in
		 * in which direction to start moving. Direction is calulated by which
		 * paddle has gained a point, the ball should move towards that paddle.
		 */ 
		private function onTimerComplete(event:TimerEvent):void
		{
			(event.currentTarget as Timer).removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			ball = new Ball();
			this.addChild(ball);
			ball.moveBall(initial_direction);
		}
		
		/**
		 * Sets boolean variables when W or S keys are pressed
		 */ 
		private function onLeftKeyDown(event:KeyboardEvent):void
		{
			if(event.keyCode == LEFT_PADDLE_UP_KEY)
				wIsDown = true;
			else if(event.keyCode == LEFT_PADDLE_DOWN_KEY)
				sIsDown = true;
		}
		
		/**
		 * Moves left paddle in negative y direction
		 */ 
		private function moveLeftPaddleUp():void
		{
			if(leftPaddle.y > 0)
			{
				leftPaddle.y -= PADDLE_SPEED;
				if(leftPaddle.y < 0)
					leftPaddle.y = 0;
			}		
		}
		
		/**
		 * Moves left paddle in positive y direction
		 */ 
		private function moveLeftPaddleDown():void
		{			
			var bottomOfPaddle:Number = leftPaddle.y+leftPaddle.height;
			if(bottomOfPaddle < gameHeight)
			{
				leftPaddle.y += PADDLE_SPEED;
				if(leftPaddle.y > maxY)
					leftPaddle.y = maxY - leftPaddle.y;
			}
		}
		
		/**
		 * Sets boolean variables when W or S keys are up.
		 */ 
		private function onLeftKeyIsUp(event:KeyboardEvent):void
		{
			if(event.keyCode == LEFT_PADDLE_UP_KEY)
				wIsDown = false;
			else if(event.keyCode == LEFT_PADDLE_DOWN_KEY)
				sIsDown = false;
		}
		
		/**
		 * Sets boolean variables when Up or Down keys are pressed
		 */ 
		private function onRightKeyDown(event:KeyboardEvent):void
		{
			if(event.keyCode == RIGHT_PADDLE_UP_KEY)
				upKeyIsDown = true;
			else if(event.keyCode == RIGHT_PADDLE_DOWN_KEY)
				downKeyIsDown = true;
		}
		
		/**
		 * Moves right paddle in negative y direction
		 */ 
		private function moveRightPaddleUp():void
		{
			if(rightPaddle.y > 0)
			{
				rightPaddle.y -= PADDLE_SPEED;
				if(rightPaddle.y <0)
					rightPaddle.y = 0;
			}
		}
		
		/**
		 * Moves right paddle in positive y direction
		 */ 
		private function moveRightPaddleDown():void
		{
			var bottomOfPaddle:Number = rightPaddle.y+rightPaddle.height;
			if(bottomOfPaddle < gameHeight)
			{
				rightPaddle.y += PADDLE_SPEED;
				if(rightPaddle.y > maxY)
					rightPaddle.y = maxY - rightPaddle.y;
			}
				
		}
		
		/**
		 * Sets boolean variables when UP or DOWN keys are up
		 */ 
		private function onRightKeyIsUp(event:KeyboardEvent):void
		{
			if(event.keyCode == RIGHT_PADDLE_UP_KEY)
				upKeyIsDown = false;
			else if(event.keyCode == RIGHT_PADDLE_DOWN_KEY)
				downKeyIsDown = false;
		}
		
		/**
		 * Calculates and return angle at which the ball should leave the
		 * surface. E_MAX and E_MIN are maximum and minimum angles for ball
		 * to travel in. Distance from paddle edge is distance when ball hits
		 * the paddle distance from that point to the end of paddle.
		 */
		private function getExitAngle(distanceFromPaddleEdge:Number):Number
		{
			return (E_MAX - E_MIN) / rightPaddle.height * distanceFromPaddleEdge + E_MIN;
		}
	}
}