package 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Zoltan Majoros
	 */
	public class Main extends Sprite 
	{	
		public static var self: Main; // ennek segitsegevel tudjuk a Terem peldanyokbol meghivni a moveChildToTop-ot. lenne szebb megoldas is, de nem rossz ez sem.
		
		public function Main():void 
		{
			self = this;
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP;
			
			var ea1:Terem = new Terem("EA 1");
			ea1.x = 10;
			ea1.y = 10;
			addChild(ea1);
			
			var ea2:Terem = new Terem("EA 2");
			ea2.x = ea1.x + ea1.width + 10;
			ea2.y = ea1.y;
			addChild(ea2);
			
			var ea3:Terem = new Terem("EA 3");
			ea3.x = ea2.x + ea2.width + 10;
			ea3.y = ea2.y;
			addChild(ea3);
			
			var gyak1:Terem = new Terem("Gyak 1");
			gyak1.x = ea1.x;
			gyak1.y = ea1.y + ea1.height + 10;
			addChild(gyak1);
			
			var gyak2:Terem = new Terem("Gyak 2");
			gyak2.x = gyak1.x;
			gyak2.y = gyak1.y + gyak1.height + 10;
			addChild(gyak2);
			
			var gyak3:Terem = new Terem("Gyak 3");
			gyak3.x = ea3.x;
			gyak3.y = ea3.y + ea3.height + 10;
			addChild(gyak3);
			
			var gyak4:Terem = new Terem("Gyak 4");
			gyak4.x = gyak3.x;
			gyak4.y = gyak3.y + gyak3.height + 10;
			addChild(gyak4);
			
			var titkari:Terem = new Terem("titkari", ea1.width, ea1.height*2 + 8);
			titkari.x = ea2.x;
			titkari.y = ea2.y + ea2.height + 10;
			addChild(titkari);
			
			var optoma1: Eszkoz = new Eszkoz("Optoma 1", new Kepek.optoma());
			optoma1.x = 5;
			optoma1.y = 25;
			titkari.addChild(optoma1);
			
			var optoma2: Eszkoz = new Eszkoz("Optoma 2", new Kepek.optoma());
			optoma2.x = optoma1.x + optoma1.width + 10;
			optoma2.y = 25;
			titkari.addChild(optoma2);
			
			var fujitsu1: Eszkoz = new Eszkoz("Fujitsu 1", new Kepek.fujitsu1());
			fujitsu1.x = optoma1.x;
			fujitsu1.y = optoma1.y + optoma1.height + 10;
			titkari.addChild(fujitsu1);
			
			var e525: Eszkoz = new Eszkoz("E525", new Kepek.e525());
			e525.x = optoma2.x;
			e525.y = optoma2.y + optoma2.height + 10;
			titkari.addChild(e525);
		}
		
		// egy gyermek (ezesetben valamelyik Terem peldany) kerheti tolunk, hogy keruljon a display list tetejere (athelyezesnel hasznos, hogy ne takarjak ki esetleg mas termek ablakai)
		public function moveChildToTop(object: DisplayObject):void
		{	// ezzel a metodussal tudunk atpozicionalni egy-egy lathato objektumot (DisplayObject-et)
			setChildIndex(object, numChildren-1); // a 'numChildren' az minden DisplayObject-ben megtalalhato, a gyermekek szamat jeloli. az idexeles 0-tol indul, ezert ki kell belole vonni 1-et.
		}
		
	} // class
	
} // package