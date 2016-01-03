package {


	import flash.display.Sprite;
	import flash.events.*;
	import flash.utils.Timer;
	import caurina.transitions.Tweener;

	public class WaitingMode extends Sprite {


		//環境パラメータ
		private var _stageWidth:Number;
		private var _stageHeight:Number;
		private var _backSprite:Sprite;
		private var _backColor:uint;

		//セリフ用
		private var _poikunText:Texts;
		private var _commentFlag:Boolean = true;
		private var _nowPetGetFlag:Boolean = false;
		//private var _textKind:Array = ["Hello!","Please\nBottle!","I'm\nPoikun!",""];
		private var _textKind:Array = ["ペットボトルを\n捨ててね！","分別して捨ててね","ペットボトル箱の\nPoi君です",""];

		public var num:uint = 3;
		//poikun
		private var _poikun:Poikun;


		public function WaitingMode(sw:Number, sh:Number) {
			_stageWidth = sw;
			_stageHeight = sh;
			_backColor = 0xFFA500;
			//_backColor = 0xB22222;
			makeObject();
			init();
		}

		private function makeObject():void {
			_backSprite = new Sprite();
			addChild(_backSprite);
			_poikun = new Poikun(_stageWidth, _stageHeight);
			addChild(_poikun);
			_poikunText = new Texts("Hello!",70,0xffffff,true);
			

			//for movie
			_poikunText.visible = false;

			addChild(_poikunText);
			addEventListener(Event.ENTER_FRAME, onLoop);
		}

		public function init():void {
			
			_backSprite.graphics.beginFill(_backColor);
			_backSprite.graphics.drawRect(0, 0, _stageWidth, _stageHeight);
			_backSprite.graphics.endFill();
			
			_poikun.x = _stageWidth / 2;
			_poikun.y = _stageHeight / 2;

			_poikunText.x = 100;
			_poikunText.y = (_stageHeight - _poikunText.height) / 2;
			_poikunText.alpha = 0;			
			_commentFlag = true;
			_nowPetGetFlag = false;
			commentAnimation();
		}


		private var _changeFaceFlag:Boolean = false;
		private var _faceKinds:Array = ["smile","happy","sleep","surprise","white"];
		private function onLoop(e:Event):void {


			_poikun.x += (mouseX - _poikun.x) / 8;
			_poikun.y += (mouseY - _poikun.y) / 8;



			//comment out for movie
			/*
			if (!_changeFaceFlag) {
				if (Math.random() * 700 < 1) {
					var face:uint = Math.floor(Math.random() * _faceKinds.length);
					_poikun.changeFace(_faceKinds[face]);				
				}
			}
			*/
			
			//mouseカーソルに対応
			_poikun.changePositionX(mouseX);
			_poikun.changePositionY(mouseY);
			trace(mouseX);

			/*
			if (Math.random() * 50 < 1) { 
				var tx  = Math.random() * _stageWidth;
				var ty = Math.random() * _stageHeight;
				_poikun.changePositionX(tx);
				_poikun.changePositionY(ty);

			}
			*/

			if (Math.random() * 300 < 2) {
				_poikun.blink();
			}	

			/*
			if (Math.random() * 500 < 2 && _nowPetGetFlag == false) {
				commentAnimation();
			}
			*/


		}

		private var _commnetCount:uint = 0;
		private function commentAnimation():void {
			//trace("commentAnimation");
			if (_commentFlag) {

				//var kind:uint = Math.floor(Math.random() * _textKind.length);
				var kind:uint = ++_commnetCount % _textKind.length;

				if (kind == 3) {
					_textKind[kind] = "今" + num + "本\n捨てられています";
				}
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
			commentAnimation();
		}

		public function poiChangeFace(s:String):void {
			_poikun.changeFace(s);
		}
	}
}