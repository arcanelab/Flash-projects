package  
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Zoltan Majoros
	 */
	public class Felirat extends Sprite
	{
		public var szovegMezo: TextField;
		
		public function Felirat(szoveg: String) 
		{
			var formatum: TextFormat = new TextFormat("Arial", 14, 0xeeeeee);
			
			szovegMezo = new TextField();
			szovegMezo.text = szoveg;
			szovegMezo.selectable = false;
			szovegMezo.setTextFormat(formatum);
			
			addChild(szovegMezo);
			
			graphics.beginFill(0x999999);
			graphics.drawRoundRect(0, 0, 80, 20, 3, 3);
			graphics.endFill();
		}
		
	} // class

} // package