package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Zoltan Majoros
	 */
	public class Main extends Sprite 
	{
		private var bitmap: Bitmap;
		private var bitmapData: BitmapData;
		private var firstParticle: Particle;
		private var bitmapRect: Rectangle;
		private var vectorField: Vector.<uint>;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			resize(null);
			addEventListener(Event.ENTER_FRAME, update);
			addEventListener(Event.RESIZE, resize);
			stage.frameRate = 25;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//drawPerlin();
			var bmpData: BitmapData = new BitmapData(stage.stageWidth, stage.stageHeight, false, 0);
			
			bmpData.perlinNoise(128, 128, 6, 123456, true, false, 7, true);
			bmpData.applyFilter(bmpData, bmpData.rect, new Point(0, 0), new BlurFilter(20, 20, 1));
			vectorField = bmpData.getVector(bmpData.rect);
			bmpData.dispose();
		}
		
		private function drawPerlin():void
		{
			var bmpData: BitmapData = new BitmapData(stage.stageWidth, stage.stageHeight, false, 0);
			var bmp: Bitmap = new Bitmap(bmpData);
			
			bmpData.perlinNoise(128, 128, 6, 123456, true, false, 7, true);
			bmpData.applyFilter(bmpData, bmpData.rect, new Point(0, 0), new BlurFilter(20, 20, 1));
			addChild(bmp);
		}
		
		private function update(e:Event):void
		{
			bitmapData.lock();
			bitmapData.fillRect(bitmapRect, 0);
			
			var vec: Vector.<uint> = bitmapData.getVector(bitmapRect);
			var w: uint = bitmapRect.width;
			var h: uint = bitmapRect.height;
			
			var p:Particle = firstParticle;
			while (p)
			{
				//p.x += p.vx;
				//p.y += p.vy;
				
				//p.x = vectorField[w * int(p.y) + int(p.x)];				
				//p.y = vectorField[w * int(p.y) + int(p.x)];
				var pos: uint = (w*int(p.y) + int(p.x));
				var velocities : int = vectorField[pos];
				var velXU : int = ((velocities>>8)&0xFF)-127.5;
				var velYU : int = ((velocities) & 0xFF) - 127.5;
				
				p.x += velXU / 100;
				p.y += velYU / 100;
	
				if (p.x < 0 || p.x >= w)
					p.x = p.spawnX;
					
				if (p.y < 0 || p.y >= h)
					p.y = p.spawnY;
					
				vec[int(w*int(p.y) + int(p.x))] = 0xffffff;
					
				p = p.next;
			}
			bitmapData.setVector(bitmapRect, vec);
			bitmapData.unlock();
		}
		
		private function resize(e:Event):void
		{
			trace("resize called.");
			
			graphics.beginFill(0);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
			
			while (numChildren)
				removeChildAt(0);
			
			bitmapData = new BitmapData(stage.stageWidth, stage.stageHeight, false, 0);
			bitmap = new Bitmap(bitmapData);
			addChild(bitmap);
			bitmapRect = bitmapData.rect;
			
			var particle: Particle;
			var prevParticle: Particle;
			for (var i:uint = 0; i < 5000; i++)
			{
				particle = new Particle(Math.random() * stage.stageWidth, Math.random() * stage.stageHeight, Math.random() * 2 - 1, Math.random() * 2 - 1);
				particle.next = prevParticle;
				prevParticle = particle;
			}
			
			firstParticle = particle;
			
		} // resize()
		
	} // class
	
} // package

/**
private function init():void
{
    //Get some perlin noise in grayscale to read in our pixelbender filter.
    var perlinMap:BitmapData = new BitmapData(WIDTH, HEIGHT, false, 0x000000);
    perlinMap.perlinNoise(128, 128, 6, 123456, true, false,7,true);
 
    //Load the embedded shader bytearray into a new shader.
    var velocityConverterShader : Shader = new Shader(new VelocityConverter() as ByteArray);
    var velocityConverterFilter : ShaderFilter = new ShaderFilter(velocityConverterShader);
 
    //Create a new temporary bitmapdata to write the filter result too.
    var perlinVelocityMap : BitmapData = perlinMap.clone();
    perlinVelocityMap.applyFilter(perlinMap, perlinMap.rect, perlinMap.rect.topLeft, velocityConverterFilter);
 
    // And get the result into a fastly readable vector
    velocityVector = perlinVelocityMap.getVector(perlinVelocityMap.rect);
 
    //Nicely dispose of the memory used by the two bitmapdata's.
    perlinVelocityMap.dispose();
    perlinMap.dispose();
 
    //Create a canvas to draw too
    bitmapData = new BitmapData(WIDTH, HEIGHT, false, 0x000000);
    bitmapRect = bitmapData.rect;
    bitmap = new Bitmap(bitmapData);
    addChild(bitmap);
 
    //Initialize the particles and keep them as a linked list.
    var particle:Particle;
    var previousParticle:Particle;
    for(var i:int = 0; i<=1000;i++){
        particle = new Particle(Math.random() * WIDTH, Math.random() * HEIGHT, Math.random() * 2 - 1, Math.random() * 2 - 1);
        particle.next = previousParticle;
        previousParticle = particle;
    }
    firstParticle = particle;
 
    //Wait to be added to stage
    addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
}
**/