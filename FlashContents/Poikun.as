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

		private var _faceKinds:Array = ["smile","happy","sleep","surprise","white"];
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


		private var _mouseMoveFlag:Boolean = true;


		//天気用
		//private var _sunny:Sunny;
		//private var _degree:Degree;



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
			//_backColor = 0x99cccc;
			//_backSp.graphics.beginFill(_backColor);
			//_backSp.graphics.drawRect(0,0,_stageWidth,_stageHeight);
			//_backSp.graphics.endFill();
			//addChild(_backSp);

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
			//_smile.x = (_stageWidth )/2;
			//_smile.y = (_stageHeight)/2;
			changeFillColor(_smile,0xffffff);
			_poikun.addChild(_smile);
			_leftEyeArray.push(_smile.LeftEye);
			_rightEyeArray.push(_smile.RightEye);
			_mouseArray.push(_smile.Mouse);
			_faceObject["smile"] = _smile;

			//happyface.
			_happy = new HappyFace();
			//_happy.x = _stageWidth/2;
			//_happy.y = _stageHeight/2;
			changeFillColor(_happy,0xffffff);
			_poikun.addChild(_happy);
			_leftEyeArray.push(_happy.LeftEye);
			_rightEyeArray.push(_happy.RightEye);
			_mouseArray.push(_happy.Mouse);
			_faceObject["happy"] = _happy;

			//sleepface.
			_sleep = new SleepFace();
			//_sleep.x = _stageWidth/2;
			//_sleep.y = _stageHeight/2;
			changeFillColor(_sleep,0xffffff);
			_poikun.addChild(_sleep);
			_leftEyeArray.push(_sleep.LeftEye);
			_rightEyeArray.push(_sleep.RightEye);
			_mouseArray.push(_sleep.Mouse);
			_faceObject["sleep"] = _sleep;

			//surpriseface.
			_surprise = new SurpriseFace();
			//_surprise.x = _stageWidth/2;
			//_surprise.y = _stageHeight/2;
			changeFillColor(_surprise,0xffffff);
			_poikun.addChild(_surprise);
			_leftEyeArray.push(_surprise.LeftEye);
			_rightEyeArray.push(_surprise.RightEye);
			_mouseArray.push(_surprise.Mouse);
			_faceObject["surprise"] = _surprise;

			//whiteface.
			_white = new WhiteFace();
			//_white.x = _stageWidth/2;
			//_white.y = _stageHeight/2;
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
				trace(key);
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
			//_eyeMoveTargetX = Math.random() * _stageWidth;
			//_eyeMoveTargetY = Math.random() * _stageHeight;
			_eyeMoveTargetX = 1 * _stageWidth;
			_eyeMoveTargetY = 1 * _stageHeight;

			

			//天気
/*
			_sunny = new Sunny();
			_degree = new Degree();
			addChild(_sunny);
			addChild(_degree);

			_sunny.x = 1388;
			_sunny.y = 957;
			_sunny.alpha = 0;
			_sunny.scalseX = _sunny.scaleY = 0;
			_degree.x = 1703;
			_degree.y = 963;
			_degree.alpha = 0;
			_degree.scaleX = _degree.scaleY = 0;
*/
			addEventListener(Event.ENTER_FRAME, onLoop);
			//addEventListener(MouseEvent.CLICK, onClick);
			defaultExpression();

		}
		

		private function onLoop(e:Event):void {

			//顔の変化

			/*
			if (!_changeFaceFlag && !_nowPetGetFlag) {
				if (Math.random() * 100 < 1) {
					if (!_nowChanging) {
						var facekind:uint = Math.floor(Math.random()*_faceKinds.length);
						trace(facekind + "next:" + _faceKinds[facekind]);
						if (_nowFaceKind != _faceKinds[facekind] && _faceKinds[facekind] != "surprise") changeFace(_faceKinds[facekind]);
					}
				}
			}
			*/

			/*
			*
			以下Poikunの顔と目の動きを制御するスクリプト
			*
			*/

			//右目目標値との角度
			var rightEyeRad = Math.atan2(_eyeMoveTargetY - _rightEyeParam["defY"] , _eyeMoveTargetX - _rightEyeParam["defX"]);
			//trace("re:" + rightEyeRad);
			//左目目標値との角度
			var leftEyeRad = Math.atan2(_eyeMoveTargetY - _leftEyeParam["defY"] , _eyeMoveTargetX - _leftEyeParam["defX"]);
			//口の目標値とのなす角度
			var mouseRad = Math.atan2(_eyeMoveTargetY - _mouseParam["defY"], _eyeMoveTargetX - _mouseParam["defX"]);
			
			//右目の動き
			_rigthEyeMoveToX = _rightEyeParam["defX"] + Math.cos(rightEyeRad)*50;
			_rigthEyeMoveToY = _rightEyeParam["defY"] + Math.sin(rightEyeRad)*50;

			trace("remt : " + _rigthEyeMoveToX);

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


			/*
			以下移動量の決定と，瞬き，セリフの管理
			*/
			
			//顔の向きを動かしてみるテスト

			/*
			if (Math.random() * 50 < 1) { 
				_eyeMoveTargetX = Math.random() * _stageWidth;
				_eyeMoveTargetY = Math.random() * _stageHeight;
			}
			
			//まばたきしてみるテスト
			
			
			//コメント出してみるテスト
			if (Math.random() * 1000 < 3 && _nowPetGetFlag == false) {
				commentAnimation();
			}
			*/
		}



		public function changePositionX(tx:Number):void {
			_eyeMoveTargetX = tx;
		}

		public function changePositionY(ty:Number):void {
			_eyeMoveTargetY = ty;
		}

		public function blink():void {
			_blinkFlag = true;
			_blinkDegree = -90;
		}

		public function changeMovePositionX(mx:Number):void {

		}

		public function changeMovePositionY(my:Number):void {

		}

		/*
		顔の変化と変化後の後処理
		*/

		public function changeFace(kind:String):void {

			_nowChanging = true;
			_preFaceKind = _nowFaceKind;
			trace(_faceObject[kind]);
			Tweener.addTween(_faceObject[_nowFaceKind],{time:0.5,alpha:0,transition:"easeInQuint"});
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

		/********/

		/*
		吸い込むときの口の動き
		*/

		public function vacuumMouse():void {
			for (var key in _faceObject){
				Tweener.addTween(_faceObject[key].Mouse,{time:0.5,scaleY:1.5,transition:"easeInElastic"});
				Tweener.addTween(_faceObject[key].Mouse,{delay:1,time:1,scaleY:2,transition:"easeInElastic"});
				Tweener.addTween(_faceObject[key].Mouse,{delay:3,time:0.5,scaleY:0.8,transition:"easeInElastic"});
			}
		}

		/*
		コメントの表示と後処理
		*/
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
			if (_nowPetGetFlag == false) _commentFlag = true;
		}
		/************************/


		/*
		各オブジェクトの位置や大きさの初期か
		*/
		public function defaultExpression():void {
			
			//吹き出し
			addChild(_comment1);
			//_comment1.scaleX = _comment1.scaleY = 0.8;
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