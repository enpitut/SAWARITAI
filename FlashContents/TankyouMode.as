package {


	import flash.display.Sprite;
	import flash.events.*;
	import flash.utils.Timer;
	import caurina.transitions.Tweener;

	public class ThankyouMode extends Sprite {


		//環境パラメータ
		private var _stageWidth:Number;
		private var _stageHeight:Number;
		private var _backSprite:Sprite;
		private var _backColor:uint;

		//セリフ用
		private var _poikunText:Texts;
		private var _commentFlag:Boolean = true;
		private var _nowPetGetFlag:Boolean = false;
		private var _textKind:Array = ["Hello!","Please\nBottle!","I'm\nPoikun!"];


		//poikun
		private var _poikun:Poikun;


		public function ThankyouMode(sw:Number, sh:Number) {
			_stageWidth = sw;
			_stageHeight = sh;
			_backColor = 0xcccccc;
			init();
		}

		private function init():void {
			_backSprite = new Sprite();
			_backSprite.graphics.beginFill(0xFFA500);
			_backSprite.graphics.drawRect(0, 0, _stageWidth, _stageHeight);
			_backSprite.graphics.endFill();
			addChild(_backSprite);

			_poikun = new Poikun(_stageWidth, _stageHeight);

			addChild(_poikun);

			_poikun.x = _stageWidth/2;
			_poikun.y = _stageHeight/2;

			_poikunText = new Texts("Hello!",180,0xffffff);
			_poikunText.x = 100;
			_poikunText.y = (_stageHeight - _poikunText.height)/2;
			_poikunText.alpha = 0;
			addChild(_poikunText);
			
			addEventListener(Event.ENTER_FRAME, onLoop);
		}


		private function onLoop(e:Event):void {

			if (Math.random() * 50 < 1) { 
				var tx  = Math.random() * _stageWidth;
				var ty = Math.random() * _stageHeight;
				_poikun.changePositionX(tx);
				_poikun.changePositionY(ty);

			}

			if (Math.random() * 300 < 2) {
				_poikun.blink();
			}	

			if (Math.random() * 1000 < 3 && _nowPetGetFlag == false) {
				commentAnimation();
			}

		}

		private function commentAnimation():void {
			//trace("commentAnimation");
			if (_commentFlag) {

				var kind:uint = Math.floor(Math.random() * _textKind.length);
				_poikunText.txt = _textKind[kind];

				var toY:Number = (_stageHeight - _poikunText.height) / 2;
				_poikunText.y = toY + 200;
				_poikunText.alpha = 0;
				Tweener.addTween(_poikunText,{time:1.0,alpha:1,y:toY});
				Tweener.addTween(_poikunText,{time:1.0,delay:3.0,alpha:0,y:toY-50,onComplete:deleteComment});
				_commentFlag = false;
				
			}
		}

		private function deleteComment():void {
			//_comment1.alpha = 0;
			_commentFlag = true;
		}
	}
}