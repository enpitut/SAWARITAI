package {

	import flash.display.*;
	import flash.display.Sprite;
	import flash.display.Graphics;

	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;

	import flash.geom.ColorTransform;
	import flash.text.*;



	import flash.utils.Timer;



	import flash.geom.Point;

	import caurina.transitions.Tweener;

	public class Poikun extends Sprite {


		//顔のパーツ管理
		private var _poikun:Sprite;
		private var _faceObject:Object;
		private var _leftEyeArray:Array;
		private var _rightEyeArray:Array;
		private var _mouseArray:Array;

		//各パーツの現在位置
		private var _leftEyeParam:Object;
		private var _rightEyeParam:Object;
		private var _mouseParam:Object;

		//顔のパーツ素材
		private var _smile:SmileFace;
		private var _happy:HappyFace;
		private var _sleep:SleepFace;
		private var _surprise:SurpriseFace;
		private var _white:WhiteFace;


		//現在の顔
		private var _nowFaceKind:String;
		private var _preFaceKind:String;

		private var _nowFaceScale:Number = 1.0;

		private var _faceKinds:Array = ["smile","happy","sleep","surprise","whiteface"];
		private var _nowChanging:Boolean = false;
		//変形flag
		private var _changeFaceFlag:Boolean = false;


		//環境パラメータ
		private var _stageWidth:Number;
		private var _stageHeight:Number;

		//まばたき
		private var _blinkFlag:Boolean;
		private var _blinkDegree:Number;


		private var _eyeMoveTargetX:Number;
		private var _eyeMoveTargetY:Number;

		private var _rigthEyeMoveToX:Number;
		private var _rigthEyeMoveToY:Number;
		private var _rightEyeScaleX:Number;
		private var _rightEyeScaleY:Number;

		private var _leftEyeMoveToX:Number;
		private var _leftEyeMoveToY:Number;
		private var _leftEyeScaleX:Number;
		private var _leftEyeScaleY:Number;

		private var _mouseMoveToX:Number;
		private var _mouseMoveToY:Number;
		private var _mouseMoveScaleX:Number;
		private var _mouseMoveScaleY:Number;

		private var _mouseScaleYVal:Number = 0.8;


		private var _comment1:Comment1;
		private var _excalmation:Excalmation;
		private var _pet:Pet;



		//セリフ用
		private var _poikunText:Texts;
		private var _commentFlag:Boolean = true;
		private var _nowPetGetFlag:Boolean = false;
		private var _textKind:Array = ["Hello!","Please\nBottle!","I'm\nPoikun!"];

		private var _thankText:Texts;

		private var _jiro:Jirokun;

		private var _mouseMoveFlag:Boolean = true;


		//ペットボトル


		//泡
		private var _p:Particle;

		//ペットボトル移動用
		private const CORRECTION_MAG:Number = 10;

		private var _backSp:Sprite;
		private var _backColor:uint;

		public function Poikun(sw:Number, sh:Number) {
			_stageWidth = sw;
			_stageHeight = sh;
			_blinkFlag = false;
			_blinkDegree = -90;

			init();
		}

		private function init():void {

			_backSp = new Sprite();
			_backColor = 0xFFA500;
			_backSp.graphics.beginFill(_backColor);
			_backSp.graphics.drawRect(0,0,_stageWidth,_stageHeight);
			_backSp.graphics.endFill();
			addChild(_backSp);

			_nowFaceKind = "smile";
			_comment1 = new Comment1();

			//faceSprite
			_poikun = new Sprite();
			addChild(_poikun);

			//_poikun.x = _stageWidth/2;
			//_poikun.y = _stageHeight/2;

			_faceObject = new Object();
			_leftEyeArray = new Array();
			_rightEyeArray = new Array();
			_mouseArray = new Array();

			//faceParam
			_leftEyeParam = new Object();
			_rightEyeParam = new Object();
			_mouseParam = new Object();

			//smileface.
			_smile = new SmileFace();
			_smile.x = (_stageWidth )/2;
			_smile.y = (_stageHeight)/2;
			changeFillColor(_smile,0xffffff);
			_poikun.addChild(_smile);
			_leftEyeArray.push(_smile.LeftEye);
			_rightEyeArray.push(_smile.RightEye);
			_mouseArray.push(_smile.Mouse);
			_faceObject["smile"] = _smile;

			//happyface.
			_happy = new HappyFace();
			_happy.x = _stageWidth/2;
			_happy.y = _stageHeight/2;
			changeFillColor(_happy,0xffffff);
			_poikun.addChild(_happy);
			_leftEyeArray.push(_happy.LeftEye);
			_rightEyeArray.push(_happy.RightEye);
			_mouseArray.push(_happy.Mouse);
			_faceObject["happy"] = _happy;

			//sleepface.
			_sleep = new SleepFace();
			_sleep.x = _stageWidth/2;
			_sleep.y = _stageHeight/2;
			changeFillColor(_sleep,0xffffff);
			_poikun.addChild(_sleep);
			_leftEyeArray.push(_sleep.LeftEye);
			_rightEyeArray.push(_sleep.RightEye);
			_mouseArray.push(_sleep.Mouse);
			_faceObject["sleep"] = _sleep;

			//surpriseface.
			_surprise = new SurpriseFace();
			_surprise.x = _stageWidth/2;
			_surprise.y = _stageHeight/2;
			changeFillColor(_surprise,0xffffff);
			_poikun.addChild(_surprise);
			_leftEyeArray.push(_surprise.LeftEye);
			_rightEyeArray.push(_surprise.RightEye);
			_mouseArray.push(_surprise.Mouse);
			_faceObject["surprise"] = _surprise;

			//whiteface.
			_white = new WhiteFace();
			_white.x = _stageWidth/2;
			_white.y = _stageHeight/2;
			changeFillColor(_white,0xffffff);
			_poikun.addChild(_white);
			_leftEyeArray.push(_white.LeftEye);
			_rightEyeArray.push(_white.RightEye);
			_mouseArray.push(_white.Mouse);
			_faceObject["white"] = _white;


			//顔のパーツのデフォルト位置,現在位置を初期化
			_leftEyeParam["defX"] = _smile.LeftEye.x;
			_leftEyeParam["defY"] = _smile.LeftEye.y;
			_leftEyeParam["nowX"] = _smile.LeftEye.x;
			_leftEyeParam["nowY"] = _smile.LeftEye.y;
			_leftEyeParam["defScaleX"] = 1;
			_leftEyeParam["defScaleY"] = 1;
			_leftEyeParam["nowScaleX"] = 1;
			_leftEyeParam["nowScaleY"] = 1;

			_rightEyeParam["defX"] = _smile.RightEye.x;
			_rightEyeParam["defY"] = _smile.RightEye.y;
			_rightEyeParam["nowX"] = _smile.RightEye.x;
			_rightEyeParam["nowY"] = _smile.RightEye.y;
			_rightEyeParam["defScaleX"] = 1;
			_rightEyeParam["defScaleY"] = 1;
			_rightEyeParam["nowScaleX"] = 1;
			_rightEyeParam["nowScaleY"] = 1;

			_mouseParam["defX"] = _smile.Mouse.x;
			_mouseParam["defY"] = _smile.Mouse.y;
			_mouseParam["nowX"] = _smile.Mouse.x;
			_mouseParam["nowY"] = _smile.Mouse.y;
			_mouseParam["defScaleX"] = 1;
			_mouseParam["defScaleY"] = 1;
			_mouseParam["nowScaleX"] = 1;
			_mouseParam["nowScaleY"] = 1;


			_rightEyeScaleX = 1.0;
			_rightEyeScaleY = 1.0;
			_leftEyeScaleX = 1.0;
			_leftEyeScaleY = 1.0;
			_mouseMoveScaleX = 1.0;
			_mouseMoveScaleY = 1.0;
			//すべての顔を一旦非表示に
			for (var key in _faceObject){
				_faceObject[key].visible = false;
			}
			_faceObject["smile"].visible = true;

			//セリフ用変数の初期化
			_poikunText = new Texts("Hello!",180,0xffffff);
			_poikunText.x = 100;
			_poikunText.y = (_stageHeight - _poikunText.height)/2;
			_poikunText.alpha = 0;
			addChild(_poikunText);

			_thankText = new Texts("Yummy!!",200,0xffffff);
			_thankText.x = (_stageWidth - _thankText.width)/2;
			_thankText.y = _stageHeight - 300;
			_thankText.alpha = 0;
			addChild(_thankText);

			//表情のランダムウォーク基準点
			_eyeMoveTargetX = Math.random() * _stageWidth;
			_eyeMoveTargetY = Math.random() * _stageHeight;

			
			//neta
			_jiro = new Jirokun();
			_jiro.x = _stageWidth/2;
			_jiro.y = _stageHeight/2;
			_jiro.alpha = 0;

			addChild(_jiro);

			addEventListener(Event.ENTER_FRAME, onLoop);
			addEventListener(MouseEvent.CLICK, onClick);
			defaultExpression();

		}


		public function onGetPet():void {
			
			if (_nowPetGetFlag == false) {
				var toY:Number = (_stageHeight - _poikunText.height) / 2;
				Tweener.addTween(_poikunText,{time:0.5,alpha:0,y:toY-50,onComplete:deleteComment});
				_nowPetGetFlag = true;
				
				Tweener.addTween(_pet,{delay:0.2,time:2.0,alpha:1,y:900,rotation:810,transition:"easeOutBounce"});

				for (var key in _faceObject){
					Tweener.addTween(_faceObject[key],{delay:0,time:1,x:150,y:850,scaleX:0.5,scaleY:0.5,transition:"easeInQuint",onComplete:FaceChange});
				}
			}
		}

		public function onGetPet2():void {

			trace("ongetpet2");
			if (_nowPetGetFlag == false) {
				var toY:Number = (_stageHeight - _poikunText.height) / 2;
				Tweener.addTween(_poikunText,{time:0.5,alpha:0,y:toY-50,onComplete:deleteComment});
				_nowPetGetFlag = true;
				_pet.y = -300;
				_pet.alpha = 0.5;

				changeFace("white");
				for (var key in _faceObject){
					Tweener.addTween(_faceObject[key],{delay:1.0,time:1,scaleX:0.9,scaleY:0.9,x:600,transition:"easeOutElastic",onComplete:makeBubble});
				}
				Tweener.addTween(_pet,{delay:0.5,time:3.0,alpha:1,y:1500,rotation:720,transition:"easeOutBounce"});
			}

		}

		private function makeBubble():void {
			Bubble(5);
			Tweener.addTween(_backSp,{delay:0.5,time:1.5,alpha:0,onComplete:backspUp});

			for (var key in _faceObject){
				Tweener.addTween(_faceObject[key],{delay:0,time:1,y:850,transition:"easeInQuint"});
			}	
		}

		private function backspUp():void {
			for (var key in _faceObject){
				_faceObject[key].x = _stageWidth/2;
			}	
			_backSp.y = 3000;
			_backSp.graphics.clear();
			_backSp.graphics.beginFill(0x9bbb59);
			_backSp.graphics.drawRect(0,0,_stageWidth,_stageHeight);
			_backSp.graphics.endFill();
			Tweener.addTween(_backSp,{delay:0.5,time:2.0,alpha:1,y:_stageHeight/2,transition:"easeOutBounce"});


			Tweener.addTween(_backSp,{delay:5,time:1.5,alpha:1,y:0});
			for (var key in _faceObject){
				Tweener.addTween(_faceObject[key],{delay:5,time:1.5,y:_stageHeight/2,onComplete:toDefaultBack});
			}

		}

		private function toDefaultBack():void {
			changeFace("happy");
			Tweener.addTween(_backSp,{delay:2,time:1.0,alpha:0,onComplete:toDefaultBack2});
		}

		private function toDefaultBack2():void {
			_backSp.graphics.clear();
			_backSp.x = _backSp.y = 0;
			_backSp.graphics.beginFill(_backColor);
			_backSp.graphics.drawRect(0,0,_stageWidth,_stageHeight);
			_backSp.graphics.endFill();
			Tweener.addTween(_backSp,{time:1.0,alpha:1,onComplete:vauumEnd});
		}

		private function Bubble(n:Number):void {
			
			for (var i:uint = 0; i < n; i++) {
				_p = new Particle(Math.random()*stage.stageWidth, stage.stageHeight + 30,  Math.random() * 4,  Math.random() * 5+2, Math.random()*0.2+1);	 // x, y, vx, vy, ay
				addChild(_p);
			}
		}

		private function FaceChange():void {
			_nowFaceScale = 0.5;
			changeFace("surprise");

			Tweener.addTween(_excalmation,{time:0.5,alpha:1,scaleX:0.7, scaleY:0.7,rotation:720});
			Tweener.addTween(_excalmation,{time:0.2,delay:1,rotation:10});
			Tweener.addTween(_excalmation,{time:0.2,delay:1.2,rotation:0});
			Tweener.addTween(_excalmation,{time:0.2,delay:1.4,rotation:10});
			Tweener.addTween(_excalmation,{time:0.2,delay:1.6,rotation:0});
			Tweener.addTween(_excalmation,{time:0.5,delay:2,alpha:0,scaleX:0,scaleY:0,rotation:0,transition:"easeInQuart",onComplete:movePoikun});

		}
		private function movePoikun():void {
			_changeFaceFlag = true;
			for (var key in _faceObject){
				//Tweener.addTween(_faceObject[key],{delay:0,time:1.5,x:150,y:850,scaleX:0.5,scaleY:0.5,transition:"easeInQuint"});
				Tweener.addTween(_faceObject[key],{delay:1,time:1.5,x:1100,onComplete:stopMouseMove});
				Tweener.addTween(_faceObject[key].Mouse,{delay:3,time:0.5,scaleY:1.5,transition:"easeInElastic"});
				Tweener.addTween(_faceObject[key].Mouse,{delay:4,time:1,scaleY:2,transition:"easeInElastic"});
				Tweener.addTween(_faceObject[key].Mouse,{delay:6,time:0.5,scaleY:0.8,transition:"easeInElastic"});
				Tweener.addTween(_faceObject[key],{delay:8,time:1.0,x:_stageWidth/2,y:_stageHeight/2,scaleX:1.0,scaleY:1.0,onComplete:vauumEnd});
			}
			
			Tweener.addTween(_pet,{delay:3,time:3.0,rotation:720,alpha:0,scaleX:0,scaleY:0,x:1150,transition:"easeInElastic"});
 			
		}

		private function stopMouseMove():void {
			_mouseMoveFlag = false;
		}
		private function vauumEnd():void {
			_mouseMoveFlag = true;
			_pet.x = 1600;
			_pet.y = -100;
			_pet.scaleX = _pet.scaleY = 1.5;
			_pet.alpha = 0;
			changeFace("happy");
			_nowFaceScale = 1.0;
			thankAnimation();
		}

		

		private function onClick(e:MouseEvent):void {
			trace("click");
			_blinkDegree = -90;
			_blinkFlag = true;
		}

		private function onLoop(e:Event):void {

			if (!_changeFaceFlag && !_nowPetGetFlag) {
				if (Math.random() * 100 < 1) {
					if (!_nowChanging) {
						var facekind:uint = Math.floor(Math.random()*_faceKinds.length);
						trace(facekind + "next:" + _faceKinds[facekind]);
						if (_nowFaceKind != _faceKinds[facekind] && _faceKinds[facekind] != "surprise") changeFace(_faceKinds[facekind]);
					}
				}
			}
			//if (!_changeFaceFlag) {
				//右目目標値との角度
				var rightEyeRad = Math.atan2(_eyeMoveTargetY - _rightEyeParam["defY"] , _eyeMoveTargetX - _rightEyeParam["defX"]);
				//左目目標値との角度
				var leftEyeRad = Math.atan2(_eyeMoveTargetY - _leftEyeParam["defY"] , _eyeMoveTargetX - _leftEyeParam["defX"]);
				//口の目標値とのなす角度
				var mouseRad = Math.atan2(_eyeMoveTargetY - _mouseParam["defY"], _eyeMoveTargetX - _mouseParam["defX"]);
				
				//右目の動き
				_rigthEyeMoveToX = _rightEyeParam["defX"] + Math.cos(rightEyeRad)*50;
				_rigthEyeMoveToY = _rightEyeParam["defY"] + Math.sin(rightEyeRad)*50;

				for (var i:uint = 0; i < _rightEyeArray.length; i++) {
					_rightEyeArray[i].x += (_rigthEyeMoveToX - _rightEyeArray[i].x) / 16;
					_rightEyeArray[i].y += (_rigthEyeMoveToY - _rightEyeArray[i].y) / 16;
					_rightEyeArray[i].scaleX += (_rightEyeScaleX - _rightEyeArray[i].scaleX) / 8;
					_rightEyeArray[i].scaleY += (_rightEyeScaleY - _rightEyeArray[i].scaleY) / 8;
				}

				//左目の動き
				_leftEyeMoveToX = _leftEyeParam["defX"] + Math.cos(leftEyeRad)*50;
				_leftEyeMoveToY = _leftEyeParam["defY"] + Math.sin(leftEyeRad)*50;
				
				for (var i:uint = 0; i < _leftEyeArray.length; i++) {
					_leftEyeArray[i].x += (_leftEyeMoveToX - _leftEyeArray[i].x) / 16;
					_leftEyeArray[i].y += (_leftEyeMoveToY - _leftEyeArray[i].y) / 16;
					_leftEyeArray[i].scaleX += (_leftEyeScaleX - _leftEyeArray[i].scaleX) / 8;
					_leftEyeArray[i].scaleY += (_leftEyeScaleY - _leftEyeArray[i].scaleY) / 8;
				}

				//口の動き
				if (_mouseMoveFlag) {
					_mouseMoveToX = _mouseParam["defX"] + Math.cos(mouseRad)*50;
					_mouseMoveToY = _mouseParam["defY"] + Math.sin(mouseRad)*50;
					_mouseMoveScaleY = 0.2 +  Math.sin(mouseRad) * _mouseScaleYVal;

					for (var i:uint = 0; i < _mouseArray.length; i++) {
						_mouseArray[i].x += (_mouseMoveToX - _mouseArray[i].x) / 16;
						_mouseArray[i].y += (_mouseMoveToY - _mouseArray[i].y) / 16;
						_mouseArray[i].scaleX += (_mouseMoveScaleX - _mouseArray[i].scaleX) / 8;
						_mouseArray[i].scaleY += (_mouseMoveScaleY - _mouseArray[i].scaleY) / 8;
					}
				}
			//}


			//顔の向きを動かしてみるテスト
			if (Math.random() * 50 < 1) { 
				_eyeMoveTargetX = Math.random() * _stageWidth;
				_eyeMoveTargetY = Math.random() * _stageHeight;
			}
			
			//まばたきしてみるテスト
			if (Math.random() * 300 < 2) {
				_blinkFlag = true;
				_blinkDegree = -90;
			}
			if (_blinkFlag) {
				_blinkDegree+=4;
				for (var i:uint = 0; i < _leftEyeArray.length; i++) {
					_leftEyeArray[i].scaleY = 1 - Math.cos(_blinkDegree/180*Math.PI);
					_rightEyeArray[i].scaleY = 1 - Math.cos(_blinkDegree/180*Math.PI);
				}
				//_rigthEye.scaleY = 1 - Math.cos(_blinkDegree/180*Math.PI);
				//_leftEye.scaleY = 1 - Math.cos(_blinkDegree/180*Math.PI);

				if (_blinkDegree > 90) {
					_blinkFlag = false;
				}
			}

			
			//コメント出してみるテスト
			if (Math.random() * 1000 < 3 && _nowPetGetFlag == false) {
				commentAnimation();
			}
		}

		public function changeFace(kind:String):void {

			trace(_faceObject[kind].scaleX,_faceObject[kind].scaleY);
			_jiro.alpha =0;
			_nowChanging = true;
			_preFaceKind = _nowFaceKind;
			trace(_faceObject[kind]);
			Tweener.addTween(_faceObject[_nowFaceKind],{time:0.5,alpha:0,transition:"easeInQuint"});
			//_faceObject[_nowFaceKind].scaleY = 0;
			//_faceObject[_nowFaceKind].alpha = 0;
			_nowFaceKind = kind;
			Tweener.addTween(_faceObject[kind],{delay:0.5,time:0.5,alpha:1,transition:"easeInQuad",onComplete:faceChanged});
			_nowFaceKind = kind;
		}

		private function faceChanged():void {
			_blinkFlag = true;
			_blinkDegree = -90;

			_faceObject[_preFaceKind].visible = false;
			_faceObject[_preFaceKind].scaleY = _nowFaceScale;
			_faceObject[_preFaceKind].alpha = 0;
			_faceObject[_nowFaceKind].visible = true;
			_faceObject[_nowFaceKind].scaleY = _nowFaceScale;
			_faceObject[_nowFaceKind].alpha = 1;
			_nowChanging = false;
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


		private function thankAnimation():void {
			var toY:Number = _stageHeight-300;
			_thankText.y = toY + 200;
			_thankText.alpha = 0;
			Tweener.addTween(_thankText,{time:1.0,delay:1.0,alpha:1,y:toY});
			Tweener.addTween(_thankText,{time:1.0,delay:4.0,alpha:0,y:toY-50,onComplete:toDefault});
		}

		private function toDefault():void {
			_changeFaceFlag = false;
			_nowPetGetFlag = false;
			_commentFlag = true;
		}

		private function deleteComment():void {
			if (_nowPetGetFlag == false) _commentFlag = true;
		}

		public function defaultExpression():void {
			//吹き出し
			addChild(_comment1);
			_comment1.scaleX = _comment1.scaleY = 0.8;
			_comment1.scaleX = _comment1.scaleY = 0;
			_comment1.rotation = 0;
			_comment1.alpha = 0; 
			_comment1.x -= 100;
			_comment1.y += 100;

			//びっくりマーク
			_excalmation = new Excalmation();
			_excalmation.x =  100;
			_excalmation.y = 650;
			_excalmation.alpha = 0;
			_excalmation.scaleX = _excalmation.scaleY = 0;
			_poikun.addChild(_excalmation);
			//trace(_excalmation.x);
			//ペットボトル
			_pet = new Pet();
			_pet.x = 1600;
			_pet.y = -100;
			_pet.alpha = 0;
			_pet.scaleX = _pet.scaleY = 1.5;
			addChild(_pet);
		}

        //色変えてくれるくん
        private function changeFillColor(targetSp:Sprite, col:uint):void {
        	var ctran:ColorTransform = new ColorTransform();
  			ctran.color = col;
			targetSp.transform.colorTransform = ctran;
        }
	}
}