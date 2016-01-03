package {
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	public class Texts extends TextField {
		
		private var _s:String;
		private var _size:Number;
		private var _col:uint;
		private var _bold:Boolean;
		
		public function Texts(s:String, n:Number = 10, col:uint = 0x0,bolds:Boolean = false) {
			_s = s;
			_size = n;
			_col = col;
			_bold = bolds
			init();
		}
		
		private function init():void {
			if (_bold) {
				this.defaultTextFormat = new TextFormat("ヒラギノ角ゴ Std", _size, _col,true);
			} else {
				this.defaultTextFormat = new TextFormat("ヒラギノ角ゴ Std", _size, _col);
			}
			this.autoSize = TextFieldAutoSize.LEFT;
			this.text = _s;
		}
		
			
		public function set txt(s:String):void {
			this.text = s;
			this.autoSize = TextFieldAutoSize.LEFT;
		}

		public function get txt():String {
			return this.text;
		}
	}
}