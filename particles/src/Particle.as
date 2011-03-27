package 
{
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author Zoltan Majoros
	 */
	final public class Particle 
	{
		
		public var x: Number;
		public var y: Number;
		public var vx: Number;
		public var vy: Number;
		public var spawnX: Number;
		public var spawnY: Number;
		public var next: Particle;
		
		public function Particle(x:Number, y:Number, vx:Number, vy:Number)
		{
			this.spawnX = this.x = x;
			this.spawnY = this.y = y;
			this.vx = vx;
			this.vy = vy;
		}
		
	} // class
} // package