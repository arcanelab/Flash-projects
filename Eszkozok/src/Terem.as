package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Zoltan Majoros
	 */
	public class Terem extends Sprite
	{
		private const alapertelmezettTeremMeret: uint = 220;
		public var felirat: Felirat;
		
		public function Terem(nev: String, szelesseg:uint = alapertelmezettTeremMeret, magassag:uint = alapertelmezettTeremMeret) 
		{
			// VIEW
			graphics.beginFill(0, 0.5);
			graphics.drawRoundRect(0+2, 0+2, szelesseg, magassag, 10, 10);
			graphics.endFill();
			
			graphics.beginFill(0xcccccc);
			graphics.lineStyle(1, 0xdddddd);
			graphics.drawRoundRect(0, 0, szelesseg, magassag, 10, 10);
			graphics.endFill();
			
			felirat = new Felirat(nev);
			addChild(felirat);
			
			// CONTROL
			addEventListener(MouseEvent.MOUSE_DOWN, egerGombLe);
			addEventListener(MouseEvent.MOUSE_UP, egerGombFel);
		}
		
		private function egerGombLe(e: MouseEvent):void
		{
			Main.self.moveChildToTop(this);
			e.currentTarget.startDrag();
		}
		
		private function egerGombFel(e: MouseEvent):void
		{
			e.currentTarget.stopDrag();
		}
	} // class
} // package