package 
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;

	public class Assets
	{
		private static var gameTextures:Dictionary = new Dictionary();
		
		[Embed(source="../Graphics/ball.png")]
		public static const Ball:Class;
		
		[Embed(source="../Graphics/bar.png")]
		public static const Bar:Class;
		
		[Embed(source="../Graphics/Net.png")]
		public static const Net:Class;
		
		/**
		 * This method returns the texture of embeded picture passed in as
		 * String
		 */ 
		public static function getTexture(name:String):Texture
		{
			if (gameTextures[name] == undefined)
			{
				var bitmap:Bitmap = new Assets[name]();
				gameTextures[name] = Texture.fromBitmap(bitmap);
			}
			return gameTextures[name];
		}
	}
}