package  
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Zoltan Majoros
	 */
	public class Eszkoz extends Sprite
	{
		private var felirat: Felirat;
		private var kep: Bitmap;
		private const meret: uint = 100;
		
		public function Eszkoz(nev: String, _kep: Bitmap) 
		{
			felirat = new Felirat(nev);
			
			kep = _kep;
			kep.smoothing = true;
			var arany: Number = kep.width / kep.height;
			kep.width = meret / arany;
			kep.height = meret / arany; // meretaranyos atmeretezes
			kep.x = 0;
			kep.y = 0;
			
			addChild(kep);
			addChild(felirat);
			
			mouseChildren = false;
			
			graphics.beginFill(0);
			graphics.drawRect(0, 0, kep.width, kep.height);
			graphics.endFill();
			
			addEventListener(MouseEvent.MOUSE_DOWN, egerGombLe);
		}
		
		private function egerGombLe(e: MouseEvent):void
		{
			e.stopPropagation(); // ne menjen vegig az event a teljes display list-en, a legfelso objektumnal lekezeljuk
			e.currentTarget.startDrag();
			
			parent.removeChild(this); // lekapjuk az aktualis helyiseg ablakarol
			Main.self.addChild(this); // athelyezzuk a Main-re arra az idore, amig mozgatjuk (hogy ne tunjon el)
			
			x = Main.self.mouseX - width/2; // az egerkurzor a kep kozepere mutasson
			y = Main.self.mouseY - height/2;
			
			Main.self.addEventListener(MouseEvent.MOUSE_UP, egerGombFel); // a teljes Main ablakan akarjuk figyelni az egergomb "felengedeset", ezert az eventlistenert a Main-hez adjuk hozza (lenne szebb megoldas is, de ez volt a leggyorsabb)
		}
		
		private function egerGombFel(e: MouseEvent): void
		{
			e.stopPropagation(); // lasd fentebb
			
			// itt megvizsgaljuk, hogy epp milyen objektumok vannak az egerkurzor alatt.
			var found: Boolean = false;
			var p:Point = new Point(Main.self.mouseX, Main.self.mouseY);
			var tmpArray: Array = Main.self.getObjectsUnderPoint(p); // tobb objektum is lehet alatta, igy egy tombot kell atnezni
			if (tmpArray.length == 0) // ha nincs alatta semmi, akkor nem szabad folytatni
				return;
			
			//trace("tmpArray.lenght =", tmpArray.length); // ez kiirja szamszeruen, hogy hany lathato objektum van a kurzor alatt
			
			for (var i:uint = 0; i < tmpArray.length - 1; i++) // vegigszaladunk a tombon es megnezzuk, hogy van-e benne Terem peldany
				if (tmpArray[i] is Terem) // az 'is' szoval tudunk objektumtipust vizsgalni
				{
					found = true; // ha talalt, akkor azt megjegyezzuk es befejezzuk a for ciklust
					break;
				}
			
			if (found == false) // ha a for ciklusban nem talaltunk Terem peldanyt, akkor vege ennek a rutinnak
				return;
				
			var destinationObject:Terem = tmpArray[i]; // i-ben van a helyes index, kiolvassuk a Terem peldanyat
			
			// itt lehet logolni a valtoztatast, pl. meghivhatsz egy web-service-t:
			// "http://www.szerverem.hu/sulieszkozok.php?ido=2011-03-29-10:31&eszkoz=Optoma 2&helyiseg=titkari"
			trace(felirat.szovegMezo.text + " atkerult a kovetkezo helyisegbe: " + destinationObject.felirat.szovegMezo.text);
			
			destinationObject.addChild(this); // hozzaadjuk onmagunkat gyermekkent
			
			x = destinationObject.mouseX - width/2; // beallitjuk az koordinatankat (ax x es y MINDIG a szulo koordinatarendszerere vonatkozik. mivel megvaltozott a szulo, ezert ezt ujra kell szamolni)
			y = destinationObject.mouseY - height/2;
			
			e.currentTarget.stopDrag();
			
			Main.self.removeEventListener(MouseEvent.MOUSE_UP, egerGombFel); // nem szabad elfeledkeznunk az 'egerGombLe'-ben a Main0hez hozzaadott event listenerrol. el kell tavolitanunk.
		}
	} // class

} // package