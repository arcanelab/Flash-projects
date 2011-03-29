package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Zoltan Majoros
	 */
	public class Main extends Sprite 
	{
		[Embed(source = "Kathrin_small.png")]
		public static var ImageClass:Class;
		
		private var sourceData: BitmapData;
		private var resultData: BitmapData;
		private var sourceBmp: Bitmap;
		private var resultBmp: Bitmap;
		private var sourceSprite: Sprite;
		private var resultSprite: Sprite;
		private var midBmp: Bitmap;
		private var midData: BitmapData;
		
		// ----------------------------------------------------------------------------------
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		// ----------------------------------------------------------------------------------
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.addEventListener(MouseEvent.CLICK, mouseClick);
			
			//sourceData = new BitmapData(stage.stageWidth/2, stage.stageHeight/2, false, 0);
			//sourceData.perlinNoise(128, 128, 6, 123456, true, false, 7, true);
			//sourceBmp = new Bitmap(sourceData);
			
			// create source bitmap
			sourceBmp = new ImageClass();
			sourceData = sourceBmp.bitmapData;
			sourceSprite = new Sprite();
			sourceSprite.graphics.beginFill(0);
			sourceSprite.graphics.drawRect(0, 0, sourceBmp.width, sourceBmp.height);
			sourceSprite.graphics.endFill();
			//sourceSprite.addChild(sourceBmp)
			
			// create destination bitmap
			resultData = new BitmapData(sourceBmp.width, sourceBmp.height, false, 0);
			resultBmp = new Bitmap(resultData);
			resultSprite = new Sprite();
			resultSprite.addChild(resultBmp);
			resultSprite.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			
			// create middle bitmap
			midData = new BitmapData(sourceBmp.width, sourceBmp.height, false, 0);
			midBmp = new Bitmap(midData);
			
			// make processings
			convertImageToGrayscale(sourceData, sourceData);
			centralDifference(sourceData, midData);
//			displaceImage(sourceData, midData, resultData);
			//blurImage(sourceData, resultData);
			
			// display images
			addChild(midBmp);
			addChild(resultSprite);
			resultSprite.x = sourceSprite.width + 1;
		}
		
		private function mouseMove(e:Event):void
		{
			var mx: int, my: int;
			
			mx = mouseX - resultSprite.x;
			my = mouseY - resultSprite.y;
			
		}
		
		// ----------------------------------------------------------------------------------
		private function mouseClick(e:Event):void
		{
			var mx: int, my: int;
			var Lx:int, Ly: int, Lz: int; // light vector == mouse coords
			var Nx:int, Ny: int, Nz: int; // normal vector == heightmap values
			var NNx:Number, NNy:Number, NNz:Number; // normalized normal vector :)
			var drn:Number, dgn:Number, dbn:Number; // diffuse color components: image rgb in [0-1]
			var ir:uint, ig:uint, ib:uint; // final rgb values
			var tmp: uint;
			var tx: Number, ty:Number, tz:Number; // temporary variables
			var LL: Number; // lenght of Light vector
			var LNx: Number, LNy:Number, LNz:Number; // normalized Light vector coordinates
			
			mx = (mouseX - resultSprite.x);
			my = (mouseY - resultSprite.y);
//			mx = mx / 2;//sourceData.width / 2;
//			mx = sourceData.width / 2 - mx;
//			my = -(sourceData.height / 2) - my;
			
			sourceSprite.graphics.beginFill(0);
			sourceSprite.graphics.drawRect(0, 0, sourceBmp.width, sourceBmp.height);
			sourceSprite.graphics.endFill();
			
			var xxx: int, yyy:int;
			
			for (var yy: uint = 0; yy < sourceData.height; yy++)
				for (var xx: uint = 0; xx < sourceData.width; xx++)
				{
//					xxx = xx - sourceData.width / 2;
//					yyy = -(yy + sourceData.height / 2);
					
					Lx = mx - xx;
					Ly = my - yy;
					Lz = 30;
					
					LL = Math.sqrt(Lx*Lx + Ly*Ly + Lz*Lz);
					LNx = Lx / LL;
					LNy = Ly / LL;
					LNz = Lz / LL;
					
					tmp = midData.getPixel(xx, yy);
					Nx = ((tmp & 0xff0000) >> 16) - 127;
					Ny = ((tmp & 0xff00) >> 8) - 127;
					Nz = (tmp & 0xff) - 127;
					
					NNx = 0.5 - Nx / 256;
					NNy = 0.5 - Ny / 256;
					NNz = 0.5 - Ny / 256;
					
					tmp = sourceData.getPixel(xx, yy);
/*					drn = ((tmp & 0xff0000) >> 16) / 128 - 1;
					dgn = ((tmp & 0xff00) >> 8) / 128 - 1;
					dbn = (tmp & 0xff) / 128 - 1;*/
					drn = ((tmp & 0xff0000) >> 16) / 256;
					dgn = ((tmp & 0xff00) >> 8) / 256;
					dbn = (tmp & 0xff) / 256;
					
/*					ir = drn * 256;
					ig = (dgn * clamp(LNx * NNx, 0, 1)) * 256;
					ib = (dbn * clamp(LNy * NNy, 0, 1)) * 256;
*/					
					//var tx: Number, ty:Number, tz:Number;
					tx = (LNx / 2) + 0.5;
					ty = (LNy / 2) + 0.5;
					tz = (LNz / 2) + 0.5;
					//tz = (LNz / 2) + 0.5;
//					var tempL:Number = 1 - (LL / 200);// Math.sqrt(tx * tx + ty * ty);
					var tempL:Number = 1-(LL / 200);// Math.sqrt(tx * tx + ty * ty);
					
					ir = drn * clamp(NNx * tx * 2, 0, 1) * 255;
					ig = dgn * clamp(NNy * ty * 2, 0, 1) * 255;
					ib = dbn * clamp(NNz * tz * 2, 0, 1) * 255;
					
/*					ir = clamp(drn * tempL, 0, 1) * 255;
					ig = clamp(dgn * tempL, 0, 1) * 255;
					ib = clamp(dbn * tempL, 0, 1) * 255;
					ir = drn * clamp(NNx * tempL, 0, 1) * 255;
					ig = dgn * clamp(NNy * tempL, 0, 1) * 255;
					ib = dbn * clamp(NNz * tempL, 0, 1) * 255;
					ir = clamp(tempL, 0, 1) * 255;
					ig = clamp(tempL, 0, 1) * 255;
					ib = clamp(tempL, 0, 1) * 255;
*/					
					//tmp = sourceData.getPixel(xx + ig, yy + ib);
					//resultData.setPixel(xx, yy, tmp);
					resultData.setPixel(xx, yy, ir << 16 | ig << 8 | ib);
/*					
					if (Math.random() > 0.9995)
					{
						//trace(drn, dgn, dbn);
						//trace(tempL);
						trace(LNx, LNy, LNz, NNx, NNy, NNz);
						//trace(tx, ty);
						//trace(mx, my);
						sourceSprite.graphics.lineStyle(1, 0xffffff);
						sourceSprite.graphics.moveTo(xx, yy);
						sourceSprite.graphics.lineTo(mx, my);
					}*/
				}
		}
		
		// ----------------------------------------------------------------------------------
		private function clamp_int(value:int, min:int, max:int):int
		{
			if (value < min)
				value = min;
			if (value > max)
				value = max;
			
			return int(value);
		}
		
		// ----------------------------------------------------------------------------------
		private function clamp(value:Number, min:Number, max:Number):Number
		{
			if (value < min)
				value = min;
			if (value > max)
				value = max;
			
			return Number(value);
		}
		// ----------------------------------------------------------------------------------
		private function displaceImage(src: BitmapData, dispmap:BitmapData, dest: BitmapData):void
		{
			var pixel: uint;
			var dx: int, dy: int;
			var sr: uint, sg:uint, sb:uint;
			var dr:Number, dg:Number, db:Number;
			//var sr: uint, sg:uint, sb:uint;
			
			for (var _y:uint = 0; _y < src.height; _y++)
			{
				for (var _x:uint = 0; _x < src.width; _x++)
				{
					pixel = dispmap.getPixel(_x, _y);
					dx = ((pixel & 0xff00) >> 8) - 127;
					dy = (pixel & 0xff) - 127;
					
					//trace(dx, dy);
					
					pixel = src.getPixel(_x + dx, _y + dy);
					sr = (pixel & 0xff0000) >> 16;
					sg = (pixel & 0xff00) >> 8;
					sb = pixel & 0xff;
					
					pixel = src.getPixel(_x, _y);
					dr = (pixel & 0xff0000) >> 16;
					dg = (pixel & 0xff00) >> 8;
					db = pixel & 0xff;
					
					dr -= sr;
					dg -= sg;
					db -= sb;
					
					dr = clamp_int(dr, 0, 255);
					dg = clamp_int(dg, 0, 255);
					db = clamp_int(db, 0, 255);
					
					dest.setPixel(_x, _y, dr << 16 | dg << 8 | db);
				}
			}			
		}
		
		// ----------------------------------------------------------------------------------
		private function centralDifference(src: BitmapData, dest:BitmapData):void
		{
			var pxP: uint, pxN:uint, pyP:uint, pyN:uint;
			var dx: int, dy: int;
			var r: uint, g:uint, b:uint;
			var result: uint;
			
			for (var _y:uint = 0; _y < src.height; _y++)
			{
				for (var _x:uint = 0; _x < src.width; _x++)
				{
					pxN = src.getPixel(_x - 1, _y) & 0xff;
					pxP = src.getPixel(_x + 1, _y) & 0xff;
					pyN = src.getPixel(_x, _y - 1) & 0xff;
					pyP = src.getPixel(_x, _y + 1) & 0xff;
					
					dx = pxP - pxN;
					dy = pyP - pyN;
					
					r = int(dx / 2) + 127;
					g = int(dy / 2) + 127;
					b = clamp_int(r+g, 0, 255);
					
					dest.setPixel(_x, _y, r<<16 | g<<8 | b);
				}
			}
		}
		
		// ----------------------------------------------------------------------------------
		private function blurImage(src: BitmapData, dest: BitmapData):void
		{
			var p1: uint, p2:uint, p3:uint, p4:uint;
			var result: uint;
			
			for (var _y:uint = 0; _y < src.height; _y++)
			{
				for (var _x:uint = 0; _x < src.width; _x++)
				{
					p1 = src.getPixel(_x - 1, _y) & 0xff;
					p2 = src.getPixel(_x + 1, _y) & 0xff;
					p3 = src.getPixel(_x, _y - 1) & 0xff;
					p4 = src.getPixel(_x, _y + 1) & 0xff;
					
					result = (p1 + p2 + p3 + p4) / 4;
					
					dest.setPixel(_x, _y, result<<16|result<<8|result);
				}
			}			
		}
		
		// ----------------------------------------------------------------------------------
		private function convertImageToGrayscale(src: BitmapData, dest: BitmapData):void
		{
			var result: uint;
			var pixel: uint;
			var r: uint;
			var g: uint;
			var b: uint;
			for (var _y:uint = 0; _y < src.height; _y++)
			{
				for (var _x:uint = 0; _x < src.width; _x++)
				{
					pixel = src.getPixel(_x, _y);
					r = (pixel & 0xff0000) >> 16;
					g = (pixel & 0xff00) >> 8;
					b = pixel & 0xff;
					
					result = uint((r + g + b) / 3);
					
					dest.setPixel(_x, _y, result<<16|result<<8|result);
				}
			}			
		}
			
		// ----------------------------------------------------------------------------------
	} // class
	

} // package