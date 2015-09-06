package {
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Particle extends Sprite {
		
		private var _b:Ball;
		
		private var _vx:Number;
		private var _vy:Number;
		private var _ay:Number;
		private var _x:Number;
		private var _y:Number;
		
		private var _rad:Number;
		
		public function Particle(x:Number,y:Number,vx:Number,vy:Number,ay:Number) {
			
			_x = x;
			_y = y;
			_vx = vx;
			_vy = vy;
			_ay = ay;
			_rad = -180 + Math.random()*360;
			init();
		}
		
		private function init():void {
			_b = new Ball(0x9bbb59);
			addChild(_b);
			_b.x = _x;
			_b.y = _y;
			_b.alpha = Math.random() * 0.5+0.5;
			_b.addEventListener(Event.ENTER_FRAME,onLoop);
			
		}
		
		private function onLoop(e:Event):void {
			_b.x += Math.sin(_rad) * _vx; //左右に振れる動き
			_b.y -= _vy;
			_vy += _ay;
			_rad += 0.1;
			
			if (_b.x > stage.stageWidth || _b.x < 0 || _b.y < 0) { //画面外に出たら解放
				_b.removeEventListener(Event.ENTER_FRAME, onLoop);
				removeChild(_b);
				parent.removeChild(this);
				_b = null;
			}
		}
	}
}