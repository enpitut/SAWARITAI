package {

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.*;

	public class PeopleNearMode extends Sprite {

		//環境パラメータ
		private var _stageWidth:Number;
		private var _stageHeight:Number;
		private var _backSprite:Sprite;
		private var _backColor:uint;

		//poikun
		private var _poikun:Poikun;
		private var _poikunToX:Number;
		private var _poikunToY:Number;

		private var _poikunText:Texts;
		private var _nowPoisition:uint;
		private var _nowFace:uint;
		private var _faceKinds:Array = ["smile","happy","sleep","surprise","white"];

		//illust
		private var _iconSprite:Sprite;

		private var _pet:PoiPet;
		private var _cap:PoiCap;
		private var _label:PoiLabel;

		private var _allow1:Allow;
		private var _allow2:Allow;
		private var _allow3:Allow;


		private var _illustPositionX:Array;
		private var _illustPositionY:Number;
		private var _illustScale:Number = 0.5;

		private var _movePoints:Array;



		public function PeopleNearMode(sw:Number, sh:Number) {
			_stageWidth = sw;
			_stageHeight = sh;
			_backColor = 0xaaA500;
			
			_illustPositionX = new Array();
			_illustPositionX = [350, _stageWidth/2+100, _stageWidth-200];
			_illustPositionY = 150;

			makeObject();
			init();
		}

		private function makeObject():void {
			_backSprite = new Sprite();
			addChild(_backSprite);
			_poikun = new Poikun(_stageWidth, _stageHeight);
			_iconSprite = new Sprite();

			_pet = new PoiPet();
			_cap = new PoiCap();
			_label = new PoiLabel();
			_allow1 = new Allow();
			_allow2 = new Allow();
			_allow3 = new Allow();

			_iconSprite.addChild(_pet);
			_iconSprite.addChild(_cap);
			_iconSprite.addChild(_label);
			_iconSprite.addChild(_allow1);
			_iconSprite.addChild(_allow2);
			_iconSprite.addChild(_allow3);

			addChild(_iconSprite);
			addChild(_poikun);
			_movePoints = new Array();

			_poikunText = new Texts("Please Bottle!",140,0xffffff);
			addChild(_poikunText);

			addEventListener(Event.ENTER_FRAME, onLoop);

		}

		public function init():void {

			_backSprite.graphics.beginFill(0xFFA500);
			_backSprite.graphics.drawRect(0, 0, _stageWidth, _stageHeight);
			_backSprite.graphics.endFill();
			
			_pet.x = _illustPositionX[1];
			_pet.y = _illustPositionY;
			
			_cap.x = _illustPositionX[2];
			_cap.y = _illustPositionY;
			
			_label.x = _illustPositionX[0];
			_label.y = _illustPositionY;

			_pet.scaleX = _pet.scaleY = _cap.scaleX = _cap.scaleY = _label.scaleX = _label.scaleY = _illustScale;

			_allow1.x = _pet.x - 170;
			_allow1.y = _pet.y;

			_allow2.x = _cap.x - 170;
			_allow2.y = _cap.y;

			_allow3.x = _label.x - 170;
			_allow3.y = _label.y;

			_allow1.scaleX = _allow1.scaleY = _allow2.scaleX = _allow2.scaleY = _allow3.scaleX = _allow3.scaleY = 0.5;
			
			_movePoints = [new Point(200,_stageHeight-250), 
							//new Point(500,_stageHeight-250),  
							new Point(_stageWidth/2,_stageHeight-250), 
							//new Point(1300,_stageHeight-250), 
							new Point(_stageWidth-300,_stageHeight-250)];

			_poikun.scaleX = _poikun.scaleY = 0.8;
			_poikun.x = _stageWidth/2;
			_poikun.y = _movePoints[0];

			_poikunToX = _stageWidth/2;
			_poikunToY = _movePoints[0].y;
			
			//セリフ用変数の初期化
			_poikunText.x = _stageWidth/2 - _poikunText.width/2;
			_poikunText.y = _movePoints[0].y - 350;
			_poikunText.alpha = 1;

			_nowPoisition = 1;
			_nowFace = 0;


			
		}

		public function changePos(num:uint):void {
			if (num == 1) {
				_poikunToX = _movePoints[0].x;
				_poikunToY = _movePoints[0].y;
			} else if (num == 2) {
				_poikunToX = _movePoints[1].x;
				_poikunToY = _movePoints[1].y;
			} else if (num == 3) {
				_poikunToX = _movePoints[2].x;
				_poikunToY = _movePoints[2].y;
			} /*else if (num == 4) {
				_poikunToX = _movePoints[3].x;
				_poikunToY = _movePoints[3].y;
			} else if (num == 5) {
				_poikunToX = _movePoints[4].x;
				_poikunToY = _movePoints[4].y;
			}*/

			/*動くたびに顔がかわる
			if (num != _nowPoisition) {
				while(1) {
					var face:uint = Math.floor(Math.random() * _faceKinds.length);
					if (face != _nowFace) {
						_nowFace = face;
						break;
					}
				}
				_poikun.changeFace(_faceKinds[face]);
			}
			*/
			_nowPoisition = num;
		}

		private var _angle:Number = 0;

		private var _textAlpha:Number = 1;
		private var _degree:Number = 0;

		private function onLoop(e:Event):void {
			_poikun.x += (_poikunToX - _poikun.x)/8;
			_poikun.y += (_poikunToY - _poikun.y)/8;

			_degree+= 4;
			var rad:Number = _degree * (Math.PI/180);

			_textAlpha = (Math.sin(rad) + 1) / 2;
			_poikunText.alpha = _textAlpha;


			/*
			_poikunText.x = _poikun.x - 200;
			if (_poikunText.x + _poikunText.width > 1900) {
				_poikunText.x = _stageWidth - _poikunText.width;
			}
			*/
 
			//_poikun.changePositionX(_stageWidth);
			//_poikun.changePositionY(_stageHeight);

			if (Math.random() * 50 < 1) { 
				var tx  = Math.random() * _stageWidth;
				var ty = Math.random() * _stageHeight;
				_poikun.changePositionX(tx);
				_poikun.changePositionY(ty);
			}

			_angle+=3;
			var rad = _angle * Math.PI / 180;

			_allow1.y = _illustPositionY + 20*Math.sin(rad);
			_allow2.y = _allow3.y = _allow1.y;

			if (Math.random() * 300 < 2) {
				_poikun.blink();
			}

		}
	}
}