package objects
{
	import starling.display.Sprite;
	import starling.text.TextField;
	
	public class HUD extends Sprite
	{
		private var _scoreTxt:TextField;
		
		/**
		 * Two text fields are created and added to display list
		 */ 
		public function HUD() 
		{
			this.addChild( new TextField(80, 30, "Score : ", "Verdana", 15, 0xFFFFFF) );
			
			_scoreTxt = new TextField(160, 30, " 0" , "Verdana", 15, 0xFFFFFF );
			this.addChild( _scoreTxt );
		}
		
		/**
		 * Sets the score
		 */ 
		public function setScore(value:int):void 
		{
			_scoreTxt.text = value.toString();
		}
	}
}