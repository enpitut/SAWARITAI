package {

	import flash.display.Sprite;
	public class Ball extends Sprite {


		private var _col:uint;

		public function Ball(col:uint) {
			_col = col;
			init();
		}

		private function init():void {

			this.graphics.lineStyle(10,_col);
			this.graphics.beginFill(0xffffff);
			this.graphics.drawCircle(0,0,Math.random()*100 + 20);
			this.graphics.endFill();

		}
	}
}