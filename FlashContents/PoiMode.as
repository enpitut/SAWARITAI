package {

	import flash.display.Sprite;
	import flash.events.*;

	import caurina.transitions.Tweener;

	public class PoiMode extends Sprite {


		private var _stageWidth:Number;
		private var _stageHeight:Number;

		private var _backSp:Sprite;
		private var _capSp:Sprite;
		private var _bottleSp:Sprite;
		private var _labelSp:Sprite;

		private var _capPoikun:Poikun;
		private var _bottlePoikun:Poikun;
		private var _labelPoikun:Poikun;

		private var _pet:Pet;
		private var _cap:Cap;
		private var _label:Label;
		private var _illustScale:Number = 0.5;

		private var _petExcalmation:Excalmation;
		private var _capExcalmation:Excalmation;
		private var _labelExcalmation:Excalmation;

		private var _petText:Texts;
		private var _capText:Texts;
		private var _labelText:Texts;



		private var _petDetectText:Texts;
		private var _capDetectText:Texts;
		private var _labelDetectText:Texts;

		private var _allow1:Allow;
		private var _allow2:Allow;
		private var _allow3:Allow;


		private var _capSpColor:uint = 0x5FA2D2;
		private var _bottleSpColor:uint = 0xF08534;
		private var _labelSpColor:uint = 0xF3C531;


		private var _timerBar:Sprite;
		private var _timerBarWidth:Number;
		private const TIMER_SPEED:uint = 5;


		public var startFlag:Boolean = false;

		private var _petMoveFlag:Boolean = false;
		private var _capMoveFlag:Boolean = false;
		private var _labelMoveFlag:Boolean = false;


		private var _petInFlag:Boolean = false;
		private var _capInFlag:Boolean = false;
		private var _labelInFlag:Boolean = false;

		public static const TIME_OVER:String = "timeover";
		public static const COMPLETE:String = "complete";


		public function PoiMode(sw:Number, sh:Number) {
			_stageWidth = sw;
			_stageHeight = sh

			makeObject();
			init();
		}

		private function makeObject():void {
			_backSp = new Sprite();
			addChild(_backSp);

			//poi君とその背景
			_capSp = new Sprite();
			_capSp.graphics.beginFill(_capSpColor);
			_capSp.graphics.drawRect(0, 0, _stageWidth/3, _stageHeight);
			_capSp.graphics.endFill();
			_backSp.addChild(_capSp);


			_bottleSp = new Sprite();
			_bottleSp.graphics.beginFill(_bottleSpColor);
			_bottleSp.graphics.drawRect(0, 0, _stageWidth/3, _stageHeight);
			_bottleSp.graphics.endFill();
			_backSp.addChild(_bottleSp);

			_labelSp = new Sprite();
			_labelSp.graphics.beginFill(_labelSpColor);
			_labelSp.graphics.drawRect(0, 0, _stageWidth/3, _stageHeight);
			_labelSp.graphics.endFill();
			_backSp.addChild(_labelSp);

			_capPoikun = new Poikun(_stageWidth, _stageHeight);
			_bottlePoikun = new Poikun(_stageWidth, _stageHeight);
			_labelPoikun = new Poikun(_stageWidth, _stageHeight);
			
			_capSp.addChild(_capPoikun);
			_bottleSp.addChild(_bottlePoikun);
			_labelSp.addChild(_labelPoikun);

			_pet = new Pet();
			_pet.name = "pet";
			_bottleSp.addChild(_pet);
			
			_cap = new Cap();
			_cap.name ="cap";
			_capSp.addChild(_cap);
			
			_label = new Label();
			_label.name = "label";
			_labelSp.addChild(_label);

			_petExcalmation = new Excalmation();
			_bottleSp.addChild(_petExcalmation);
			_capExcalmation = new Excalmation();
			_capSp.addChild(_capExcalmation);
			_labelExcalmation = new Excalmation();
			_labelSp.addChild(_labelExcalmation);

			_petText = new Texts("Yummy!",80,0xffffff);
			_bottleSp.addChild(_petText);
			_capText = new Texts("Good!",80,0xffffff);
			_capSp.addChild(_capText);
			_labelText = new Texts("Happy!",80,0xffffff);
			_labelSp.addChild(_labelText);

			_petDetectText = new Texts("bottle",80,0xffffff);
			_bottleSp.addChild(_petDetectText);
			_capDetectText = new Texts("cap",80,0xffffff);
			_capSp.addChild(_capDetectText);
			_labelDetectText = new Texts("label",80,0xffffff);
			_labelSp.addChild(_labelDetectText);

			_allow1 = new Allow();
			_bottleSp.addChild(_allow1);

			_allow2 = new Allow();
			_capSp.addChild(_allow2);

			_allow3 = new Allow();
			_labelSp.addChild(_allow3);

			_timerBar = new Sprite();
			_timerBar.visible = false;
			addChild(_timerBar);
			addEventListener(Event.ENTER_FRAME, onLoop);

		}

		public function init():void {

			_labelSp.x = 0;
			_bottleSp.x = _stageWidth/3;
			_capSp.x = _stageWidth/3*2;

			_capPoikun.scaleX = _capPoikun.scaleY = _bottlePoikun.scaleX = _bottlePoikun.scaleY = _labelPoikun.scaleX = _labelPoikun.scaleY = 0.5;
			
			_capPoikun.x = _stageWidth/3/2;
			_capPoikun.y = _stageHeight/2;

			_capPoikun.changeFace("smile");
			
			_bottlePoikun.x = _stageWidth/3/2;
			_bottlePoikun.y = _stageHeight/2;
			_bottlePoikun.changeFace("smile");

			_labelPoikun.x = _stageWidth/3/2;
			_labelPoikun.y = _stageHeight/2;
			_labelPoikun.changeFace("smile");

			//イラスト
			_pet.x = _bottlePoikun.x;
			_cap.x = _capPoikun.x;
			_label.x = _labelPoikun.x;
			_pet.y = _cap.y = _label.y = -200;

			_pet.scaleX = _pet.scaleY = _cap.scaleX = _cap.scaleY = _label.scaleX = _label.scaleY = _illustScale;
			_pet.alpha = _cap.alpha = _label.alpha = 0;


			//びっくりまーく
			
			_petExcalmation.x = _bottlePoikun.x;
			_petExcalmation.y = _bottlePoikun.y-150;
		
			_capExcalmation.x = _capPoikun.x;
			_capExcalmation.y = _capPoikun.y-150;
			
			_labelExcalmation.x = _labelPoikun.x;
			_labelExcalmation.y = _labelPoikun.y-150;
			
			_petExcalmation.scaleX = _petExcalmation.scaleY = _capExcalmation.scaleX = _capExcalmation.scaleY = _labelExcalmation.scaleX = _labelExcalmation.scaleY = 0.0;
			_petExcalmation.alpha = _capExcalmation.alpha = _labelExcalmation.alpha = 0;

			//セリフテキスト
			
			_petText.x = _bottlePoikun.x - _petText.width/2;
			_petText.y = _bottlePoikun.y + 100;
			_petText.alpha = 0;
			
			_capText.x = _capPoikun.x - _capText.width/2;
			_capText.y = _capPoikun.y + 100;
			_capText.alpha = 0;
			
			_labelText.x = _labelPoikun.x - _labelText.width/2;
			_labelText.y = _labelPoikun.y + 100;
			_labelText.alpha = 0;
			

			//指示テキスト
			_petDetectText.x = _bottlePoikun.x - _petText.width/2 + 100;
			_petDetectText.y = 50;
			_petDetectText.alpha = 1;

			_capDetectText.x = _capPoikun.x - _capDetectText.width/2 + 70;
			_capDetectText.y = 50;
			_capDetectText.alpha = 1;

			_labelDetectText.x = _labelPoikun.x - _labelDetectText.width/2 + 80;
			_labelDetectText.y = 50;
			_labelDetectText.alpha = 1;


			_allow1.x = _petDetectText.x - 70;
			_allow1.y = _petDetectText.y + 50;

			_allow2.x = _capDetectText.x - 70;
			_allow2.y = _capDetectText.y + 50;

			_allow3.x = _labelDetectText.x - 70;
			_allow3.y = _labelDetectText.y + 50;
			_allow1.scaleX = _allow1.scaleY = _allow2.scaleX = _allow2.scaleY = _allow3.scaleX = _allow3.scaleY = 0.3; 

			//timer bar
			_timerBarWidth = _stageWidth
			_timerBar.graphics.beginFill(0xffffff);
			_timerBar.graphics.drawRect(0, _stageHeight-75, _timerBarWidth, 75);
			_timerBar.graphics.endFill();

			startFlag = false;
			_petMoveFlag = false;
			_capMoveFlag = false;
			_labelMoveFlag = false;
			_petInFlag = false;
			_capInFlag = false;
			_labelInFlag = false;

			_allow1.alpha = _allow2.alpha = _allow3.alpha = 1;


		}

		private var _angle:Number = 0;

		private function onLoop(e:Event):void {
			if (Math.random() * 200 < 2) {
				_capPoikun.blink();
				_bottlePoikun.blink();
				_labelPoikun.blink();
			}

			_angle+=3;
			var rad = _angle * Math.PI / 180;

			_allow1.y = 75 + 20*Math.sin(rad);
			_allow2.y = _allow3.y = _allow1.y;


			//timer bar move
			if (startFlag) {
				if (_timerBarWidth > 0) {
					_timerBarWidth -= TIMER_SPEED;
					_timerBar.graphics.clear();
					_timerBar.graphics.beginFill(0xffffff);
					_timerBar.graphics.drawRect(0, _stageHeight-75, _timerBarWidth, 75);
					_timerBar.graphics.endFill();
				} else {
					trace("time over");
				}
			}

			if (_timerBarWidth < 1 && _capMoveFlag == false && _petMoveFlag == false  && _labelMoveFlag == false) {
				trace("NEXT!!");
				dispatchEvent(new Event(TIME_OVER));
				//init();
			}

			if (_labelInFlag && _capInFlag && _petInFlag) {
				dispatchEvent(new Event(COMPLETE));
				_labelInFlag = _capInFlag = _petInFlag = false;

				//init();
			}
		}


		public function poiGarbage(kind:String):void {

			switch(kind) {
				case "cap": {
					_capMoveFlag = true;
					_timerBarWidth += 400;
					_capPoikun.changeFace("surprise");
					/*
					Tweener.addTween(_capDetectText,{delay:0.2,time:1.0,alpha:0});
					Tweener.addTween(_allow2,{delay:0.2,time:1.0,alpha:0})
					Tweener.addTween(_capExcalmation,{delay:0.2,time:1.0,alpha:1,rotation:0,scaleX:0.5, scaleY:0.5, transition:"easeOutBounce"});
					Tweener.addTween(_capExcalmation,{delay:2.0,time:1.0,alpha:0,rotation:0,scaleX:0, scaleY:0});
					Tweener.addTween(_cap,{delay:0.2,time:2.0,alpha:1,y:900,rotation:810,transition:"easeOutBounce"});
					Tweener.addTween(_capPoikun,{delay:2.5, time:1,x:_capPoikun.x-50, y:750, onComplete:vacuum, onCompleteParams:[_capPoikun]});
					Tweener.addTween(_cap,{delay:3.5, time:2.5, rotation:720, alpha:0, scaleX:0, scaleY:0, x:_capPoikun.x, y:_capPoikun.y+200, transition:"easeInElastic"});
					Tweener.addTween(_capPoikun,{delay:7, time:1, x:_stageWidth/3/2, y:_stageHeight/2, onComplete:vacuumEnd, onCompleteParams:[_capPoikun, "cap"]});
					Tweener.addTween(_capText,{delay:9,time:1.0,alpha:1,y:_capText.y-20,onComplete:actionEnd, onCompleteParams:["cap"]});
					*/

					Tweener.addTween(_capDetectText,{delay:0.2,time:0.5,alpha:0});	//キャップ入れての文字を消す
					Tweener.addTween(_allow2,{delay:0.2,time:0.5,alpha:0})			//キャップ入れての矢印を消す

					Tweener.addTween(_capExcalmation,{delay:0.2,time:0.75,alpha:1,rotation:0,scaleX:0.5, scaleY:0.5, transition:"easeOutBounce"});	//驚きの矢印表示
					Tweener.addTween(_capExcalmation,{delay:1.5,time:0.75,alpha:0,rotation:0,scaleX:0, scaleY:0});									//驚きの矢印消す

					Tweener.addTween(_cap,{delay:0.2,time:0.75,alpha:1,y:900,rotation:810,transition:"easeOutBounce"});			//キャップが落ちてくる
					Tweener.addTween(_capPoikun,{delay:1.0, time:0.5,x:_capPoikun.x-50, y:750, onComplete:vacuum, onCompleteParams:[_capPoikun]});	//poi君がキャップまで移動
					Tweener.addTween(_cap,{delay:2.5, time:1.0, rotation:720, alpha:0, scaleX:0, scaleY:0, x:_capPoikun.x, y:_capPoikun.y+200, transition:"easeInElastic"}); //キャップを吸い込む
					Tweener.addTween(_capPoikun,{delay:3.5, time:1, x:_stageWidth/3/2, y:_stageHeight/2, onComplete:vacuumEnd, onCompleteParams:[_capPoikun, "cap"]});	//poi君戻る
					Tweener.addTween(_capText,{delay:5,time:0.5,alpha:1,y:_capText.y-20,onComplete:actionEnd, onCompleteParams:["cap"]});	//yammyなどの文字表示


					//moveIllust(kind);
					break;
				};

				case "bottle": {
					_petMoveFlag = true;
					_timerBarWidth += 400;
					_bottlePoikun.changeFace("surprise");
					/*
					Tweener.addTween(_petDetectText,{delay:0.2,time:1.0,alpha:0});
					Tweener.addTween(_allow1,{delay:0.2,time:1.0,alpha:0})
					Tweener.addTween(_petExcalmation,{delay:0.2,time:1.0,alpha:1,rotation:0,scaleX:0.5, scaleY:0.5, transition:"easeOutBounce"});
					Tweener.addTween(_petExcalmation,{delay:2.0,time:1.0,alpha:0,rotation:0,scaleX:0, scaleY:0});
					Tweener.addTween(_pet,{delay:0.2,time:2.0,alpha:1,y:900,rotation:810,transition:"easeOutBounce"});
					Tweener.addTween(_bottlePoikun,{delay:2.5, time:1,x:_bottlePoikun.x-50, y:750, onComplete:vacuum, onCompleteParams:[_bottlePoikun]});
					Tweener.addTween(_pet,{delay:3.5, time:2.5, rotation:720, alpha:0, scaleX:0, scaleY:0, x:_bottlePoikun.x, y:_bottlePoikun.y+200, transition:"easeInElastic"});
					Tweener.addTween(_bottlePoikun,{delay:7, time:1, x:_stageWidth/3/2, y:_stageHeight/2, onComplete:vacuumEnd, onCompleteParams:[_bottlePoikun, "pet"]});
					Tweener.addTween(_petText,{delay:9,time:1.0,alpha:1,y:_petText.y-20,onComplete:actionEnd, onCompleteParams:["pet"]});
					*/

					Tweener.addTween(_petDetectText,{delay:0.2,time:0.5,alpha:0});
					Tweener.addTween(_allow1,{delay:0.2,time:0.5,alpha:0})

					Tweener.addTween(_petExcalmation,{delay:0.2,time:0.75,alpha:1,rotation:0,scaleX:0.5, scaleY:0.5, transition:"easeOutBounce"});
					Tweener.addTween(_petExcalmation,{delay:1.5,time:0.75,alpha:0,rotation:0,scaleX:0, scaleY:0});

					Tweener.addTween(_pet,{delay:0.2,time:0.75,alpha:1,y:900,rotation:810,transition:"easeOutBounce"});
					Tweener.addTween(_bottlePoikun,{delay:1.0, time:0.5,x:_bottlePoikun.x-50, y:750, onComplete:vacuum, onCompleteParams:[_bottlePoikun]});
					Tweener.addTween(_pet,{delay:2.5, time:1.0, rotation:720, alpha:0, scaleX:0, scaleY:0, x:_bottlePoikun.x, y:_bottlePoikun.y+200, transition:"easeInElastic"});
					Tweener.addTween(_bottlePoikun,{delay:3.5, time:1, x:_stageWidth/3/2, y:_stageHeight/2, onComplete:vacuumEnd, onCompleteParams:[_bottlePoikun, "pet"]});
					Tweener.addTween(_petText,{delay:5,time:0.5,alpha:1,y:_petText.y-20,onComplete:actionEnd, onCompleteParams:["pet"]});

					//moveIllust(kind);
					break;
				};

				case "label": {
					_labelMoveFlag = true;
					_timerBarWidth += 400;
					_labelPoikun.changeFace("surprise");
					/*
					Tweener.addTween(_labelDetectText,{delay:0.2,time:1.0,alpha:0});
					Tweener.addTween(_allow3,{delay:0.2,time:1.0,alpha:0});
					Tweener.addTween(_labelExcalmation,{delay:0.2,time:1.0,alpha:1,rotation:0,scaleX:0.5, scaleY:0.5, transition:"easeOutBounce"});
					Tweener.addTween(_labelExcalmation,{delay:2.0,time:1.0,alpha:0,rotation:0,scaleX:0, scaleY:0});
					Tweener.addTween(_label,{delay:0.2,time:3.0,alpha:1,y:900,rotation:720,transition:"easeOutBounce"});
					Tweener.addTween(_labelPoikun,{delay:2.5, time:1,x:_labelPoikun.x-50, y:750, onComplete:vacuum, onCompleteParams:[_labelPoikun]});
					Tweener.addTween(_label,{delay:3.5, time:2.5, rotation:720, alpha:0, scaleX:0, scaleY:0, x:_labelPoikun.x, y:_labelPoikun.y+200, transition:"easeInElastic"});
					Tweener.addTween(_labelPoikun,{delay:7, time:1, x:_stageWidth/3/2, y:_stageHeight/2, onComplete:vacuumEnd, onCompleteParams:[_labelPoikun, "label"]});	
					Tweener.addTween(_labelText,{delay:9,time:1.0,alpha:1,y:_labelText.y-20,onComplete:actionEnd, onCompleteParams:["label"]});
					*/
					Tweener.addTween(_labelDetectText,{delay:0.2,time:0.5,alpha:0});
					Tweener.addTween(_allow3,{delay:0.2,time:0.5,alpha:0});
					
					Tweener.addTween(_labelExcalmation,{delay:0.2,time:0.75,alpha:1,rotation:0,scaleX:0.5, scaleY:0.5, transition:"easeOutBounce"});
					Tweener.addTween(_labelExcalmation,{delay:1.5,time:0.75,alpha:0,rotation:0,scaleX:0, scaleY:0});

					Tweener.addTween(_label,{delay:0.2,time:0.75,alpha:1,y:900,rotation:720,transition:"easeOutBounce"});
					Tweener.addTween(_labelPoikun,{delay:1.0, time:0.5,x:_labelPoikun.x-50, y:750, onComplete:vacuum, onCompleteParams:[_labelPoikun]});
					Tweener.addTween(_label,{delay:2.5, time:1.0, rotation:720, alpha:0, scaleX:0, scaleY:0, x:_labelPoikun.x, y:_labelPoikun.y+200, transition:"easeInElastic"});
					Tweener.addTween(_labelPoikun,{delay:3.5, time:1, x:_stageWidth/3/2, y:_stageHeight/2, onComplete:vacuumEnd, onCompleteParams:[_labelPoikun, "label"]});	
					Tweener.addTween(_labelText,{delay:5,time:0.5,alpha:1,y:_labelText.y-20,onComplete:actionEnd, onCompleteParams:["label"]});


					//moveIllust(kind);
					break;
				};
			}
		}

		private function vacuum(mc):void {
			mc.vacuumMouse();
		}

		private function vacuumEnd(mc,tag):void {
			mc.changeFace("happy");
		}

		private function actionEnd(tag):void {
			switch(tag) {
				case "cap": {
					_capMoveFlag = false;
					_capInFlag = true;
					break;
				};

				case "pet": {
					_petMoveFlag = false;
					_petInFlag = true;
					break;
				};

				case "label": {
					_labelMoveFlag = false;
					_labelInFlag = true;
					break;
				};
			}
		}
		private function moveIllust(kind:String):void {
			
		}
	}
}