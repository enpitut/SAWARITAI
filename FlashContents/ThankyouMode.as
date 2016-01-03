package {


	import flash.display.Sprite;
	import flash.events.*;
	import flash.utils.Timer;
	import caurina.transitions.Tweener;
	import flash.net.*;
	import flash.media.*;


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
		private var _textKind:Array = ["分別してくれて\nありがとう!","ありがとう!\n次はさらに分別してみて！"];


		//poikun
		private var _poikun:Poikun;

		private var _cloudIcon:CloudIcon;
		private var _sunnyIcon:SunnyIcon;
		private var _tempText:Texts;

		private var _sound_obj:Sound;

		public static const COMPLETE:String = "complete";


		public var capFlag:Boolean = false;
		public var petFlag:Boolean = false;
		public var labelFlag:Boolean = false;


		private var _pet:Pet;
		private var _cap:Cap;
		private var _label:Label;


		private var _url:URLRequest;

		public function ThankyouMode(sw:Number, sh:Number) {
			_stageWidth = sw;
			_stageHeight = sh;
			//_backColor = 0xcccccc;
			makeObject();
			init();
		}

		private function makeObject():void {
			_backSprite = new Sprite();
			addChild(_backSprite);

			_poikun = new Poikun(_stageWidth, _stageHeight);
			addChild(_poikun);

			_poikunText = new Texts("Hello!",80,0xffffff);
			addChild(_poikunText);

			_cloudIcon = new CloudIcon();
			_sunnyIcon = new SunnyIcon();

			_tempText = new Texts("16℃",120,0xffffff);
			addChild(_tempText);

			addChild(_cloudIcon);
			addChild(_sunnyIcon);


			addEventListener(Event.ENTER_FRAME, onLoop);

			_url = new URLRequest("poikun.mp3");
			_sound_obj = new Sound(_url);


			_pet = new Pet();
			_pet.name = "pet";
			addChild(_pet);
			
			_cap = new Cap();
			_cap.name ="cap";
			addChild(_cap);
			
			_label = new Label();
			_label.name = "label";
			addChild(_label);
		}
		public function init():void {
			
			capFlag = false;
			petFlag = false;
			labelFlag = false;

			_backSprite.graphics.beginFill(0xFFA500);
			_backSprite.graphics.drawRect(0, 0, _stageWidth, _stageHeight);
			_backSprite.graphics.endFill();

			_poikun.x = _stageWidth/2 - 600;
			_poikun.y = _stageHeight/2;

			_poikunText.x = _stageWidth/2 - 100;
			_poikunText.y = (_stageHeight - _poikunText.height)/2;
			_poikunText.alpha = 0;

			_cloudIcon.alpha = 0;
			_sunnyIcon.alpha = 0;

			_tempText.x = _stageWidth/2 + 500;
			_tempText.y = _stageHeight/2 - 50;
			_tempText.alpha = 0;
			_cloudIcon.x = _sunnyIcon.x =  _stageWidth/2 -150 + 500;
			_cloudIcon.y = _sunnyIcon.y = _stageHeight/2;

			_cloudIcon.scaleX = _cloudIcon.scaleY = _sunnyIcon.scaleX = _sunnyIcon.scaleY = 0;
			
			_pet.x = _stageWidth/2 - 100;
			_pet.y = 800;
			_label.x = _stageWidth/2 + 200;
			_label.y = 800;
			_cap.x = _stageWidth/2 + 500;
			_cap.y = 800;

			_pet.alpha = _label.alpha = _cap.alpha = 0;

			_pet.scaleX = _pet.scaleY = _label.scaleX = _label.scaleY = _cap.scaleX = _cap.scaleY = 0.5;
		}

		public function comment1():void {
			var toY:Number = (_stageHeight - _poikunText.height) / 2;
			//_poikunText.y = toY;
			_poikunText.alpha = 0;

			if (capFlag && labelFlag && petFlag) {
				_poikunText.txt = _textKind[0];
			} else {
				_poikunText.txt = _textKind[1];
			}
			
			if (!capFlag) {
				Tweener.addTween(_cap,{time:1.0,delay:2.0,alpha:1});
				Tweener.addTween(_cap,{time:2.0,delay:6.0,alpha:0});
			}
			if (!labelFlag) {
				Tweener.addTween(_label,{time:1.0,delay:2.0,alpha:1});
				Tweener.addTween(_label,{time:2.0,delay:6.0,alpha:0});
			}

			if (!petFlag) {
				Tweener.addTween(_pet,{time:1.0,delay:2.0,alpha:1});
				Tweener.addTween(_pet,{time:2.0,delay:6.0,alpha:0});
			}
			Tweener.addTween(_poikunText,{time:1.0,delay:2.0,alpha:1,y:toY-50, onComplete:playSound});
			Tweener.addTween(_poikunText,{time:3.0,delay:6.0,alpha:0,y:toY-100,onComplete:deleteComment});

			Tweener.addTween(_tempText,{time:1.0,delay:9.0,alpha:1});
			//Tweener.addTween(_cloudIcon,{time:1.0,delay:9.0,scaleX:0.5,scaleY:0.5,alpha:1});
			Tweener.addTween(_sunnyIcon,{time:1.0,delay:9.0,scaleX:0.5,scaleY:0.5,alpha:1});

			Tweener.addTween(_tempText,{time:1.0,delay:13.0,alpha:0});
			//Tweener.addTween(_cloudIcon,{time:1.0,delay:13.0,scaleX:0.0,scaleY:0,alpha:0});
			Tweener.addTween(_sunnyIcon,{time:1.0,delay:13.0,scaleX:0.0,scaleY:0,alpha:0});

			Tweener.addTween(_poikunText,{time:1.0,delay:14.0,alpha:1,y:toY-50});
			Tweener.addTween(_poikunText,{time:2.0,delay:17.0,alpha:0,y:toY-100,onComplete:toWaiting});
			//capFlag = labelFlag = petFlag = false;
		}

		private function playSound():void {
			if (capFlag && labelFlag && petFlag) {
				_sound_obj.play();
			}
		}
		private function toWaiting():void {
			dispatchEvent(new Event(COMPLETE));
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

			/*
			if (Math.random() * 1000 < 3 && _nowPetGetFlag == false) {
				commentAnimation();
			}
			*/
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
			_poikunText.txt = "Have a nice Day!";
			_poikunText.y = (_stageHeight - _poikunText.height)/2;
			_commentFlag = true;
		}
	}
}