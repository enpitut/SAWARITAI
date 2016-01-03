package {

	import flash.display.Sprite;
	import flash.display.*;
	import flash.events.KeyboardEvent;
	import flash.ui.Mouse;
	import flash.text.*;
	import flash.events.Event;
	import flash.net.*;
	import flash.media.*;


	import caurina.transitions.Tweener;

//for arduino
	import com.quetwo.Arduino.ArduinoConnector;
	import com.quetwo.Arduino.ArduinoConnectorEvent;


	public class Main extends Sprite {

		private var _backSp:Sprite;
		private var _width:Number;
		private var _height:Number;
		private var _backColor:uint;


		private var _poikun:Poikun;
		private var _waitMode:WaitingMode;
		private var _peopleNearMode:PeopleNearMode;
		private var _poiMode:PoiMode;
		private var _thankMode:ThankyouMode;


		private var _nowViewMode:Sprite;
		private var _nextViewMode:Sprite;

		private var _modeNames:Array = ["wait","peopleNear","poi","thankyou"];
		private var _modeObjects:Object;
		private var _nowModeName:String;


		private var _txt:Texts;

		private var param:URLVariables;
		private var req:URLRequest;
		private var _sound_obj:Sound;


		private var _arduino:ArduinoConnector;

		private var _distanceLeft:Number;
		private var _distanceCenter:Number;
		private var _distanceRight:Number;


		private var _capInFlag:Boolean = false;
		private var _petInFlag:Boolean = false;
		private var _labelInFlag:Boolean = false;

		private var _nowPoiFlag:Boolean = false;

		private var _nowNearFlag:Boolean = false;


		private const TEXT_VISIBLE:Boolean = false;

		public static const FULL_SCREEN_INTERACTIVE:String = "fullScreenInteractive"



		//設定ファイル
		private var _settingXml:XML;
		private var _settingLoader:URLLoader;
		private var _settingXmlPath:String = "setting.xml";

		public function Main() {

			//設定ファイルの読み込み
			_settingLoader = new URLLoader();
			_settingLoader.load(new URLRequest(_settingXmlPath));
			_settingLoader.addEventListener(Event.COMPLETE,onSetting);

			

			//var url : URLRequest = new URLRequest("http://webapi.aitalk.jp/webapi/v1/ttsget.php?username=MA11WebAPIJ&password=tRWjUhJB&ext=wav&range=2.0&pitch=2.0&&joy=0.5&&text=こんにちわ，ぽいぺっとです．");
			//var url : URLRequest = new URLRequest("shutter.mp3");

			//_sound_obj = new Sound(url);
			//_sound_obj.addEventListener (Event.COMPLETE,SoundCompleteFunc);
			
		}

		private var _arduinoPort:String;
		private function onSetting(e:Event):void {
			_settingXml = new XML(e.target.data);
			_arduinoPort = _settingXml.arduinoSerial;
			init();
		}
		private function SoundCompleteFunc(e:Event):void {
			//trace("load comp");
			///_sound_obj.play();
		}
		private function init():void {
			_width = stage.stageWidth;
			_height = stage.stageHeight;
		
			//_poikun = new Poikun(_width, _height);

			//各モードの初期か
			_waitMode = new WaitingMode(_width, _height);
			addChild(_waitMode);
			_waitMode.visible = false;
			_waitMode.alpha = 0;

			_peopleNearMode = new PeopleNearMode(_width, _height);
			addChild(_peopleNearMode);
			_peopleNearMode.visible = false;
			_peopleNearMode.alpha = 0;

			_poiMode = new PoiMode(_width, _height);
			addChild(_poiMode);
			_poiMode.visible = false;
			_poiMode.alpha = 0;

			_thankMode = new ThankyouMode(_width, _height);
			addChild(_thankMode);
			_thankMode.visible = false;
			_thankMode.alpha = 0;

			_modeObjects = new Object();
			_modeObjects["wait"] = _waitMode;
			_modeObjects["peopleNear"] = _peopleNearMode;
			_modeObjects["poi"] = _poiMode;
			_modeObjects["thankyou"] = _thankMode;


			_nowModeName = _modeNames[0];
			_modeObjects[_nowModeName].visible = true;
			_modeObjects[_nowModeName].alpha = 1;


			//for keyboardDebug
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);


			_poiMode.addEventListener("timeover",onTimeOver);
			_poiMode.addEventListener("complete",onComplete);
			_thankMode.addEventListener("complete",toWaiting);



			addEventListener(Event.ENTER_FRAME, onLoop);

			_distanceLeft = 1000;
			_distanceRight = 1000;
			_distanceCenter = 1000;
			_nowPoiFlag = false;
			_capInFlag = false;
			_labelInFlag = false;
			_petInFlag = false;
			_nowNearFlag = false;


			_txt = new Texts("poipet",48);
			//_txt.defaultTextFormat = new TextFormat("",32);
			addChild(_txt);
			_txt.visible = TEXT_VISIBLE;
			
			//textUpdate(_distanceLeft,_distanceRight,_distanceCenter);
			

			//arduinoInit();
			//comm();
		}


		//arduinoとの通信部分
		
		/*
		private function arduinoInit():void {			

			_arduino = new ArduinoConnector();
			trace(_arduino.getComPorts()); 
		}

		private function comm():void {
			_arduino.connect(_arduinoPort,9600);
			_arduino.addEventListener("socketData",onSock);
		}


		private function onSock(e:Event):void {
			trace("new message");
			var str:String = _arduino.readBytesAsString();
			
			//改行コードがなくなるまで
			while (str.indexOf(";") != -1) {
				var tempStr = str.indexOf(";");
				var operateStr = str.substring(0,tempStr);
				
				str = str.substring(tempStr+1,str.length);
				_txt.text += "===";
				_txt.text += operateStr;
				_txt.text += "==="
				serialExecute(operateStr);
			}


			//_txt.text += "===";
			
			//var tempStr = str.substring(0,3);
			//_txt.text += "'" + tempStr + "'";


			
			/*
			if (Math.random()*100 < 50) {
				_poikun.onGetPet();
			} else {
				_poikun.onGetPet();	
			}
			postMessage();
			
		}
		*/

		private var _location:uint = 0;

		private function serialExecute(tempStr:String):void {

			var tempStr2 = tempStr.substring(0,3);
			switch(tempStr2) {

				case "loc": {
					var where = tempStr.indexOf(":");
					var tempStr3 = tempStr.substring(where+1,tempStr.length);
					_location = Number(tempStr3);
					_txt.text = "location : " + _location;
					break;
				};
				case "lef": {
					var where = tempStr.indexOf(":");
					var tempStr3 = tempStr.substring(where+1,tempStr.length);
					_distanceLeft = Number(tempStr3);

					break;
				};

				case "cen": {

					var where = tempStr.indexOf(":");
					var tempStr3 = tempStr.substring(where+1,tempStr.length);
					_distanceCenter = Number(tempStr3);
				
					break;
				};

				case "rig": {
					var where = tempStr.indexOf(":");
					var tempStr3 = tempStr.substring(where+1,tempStr.length);
					_distanceRight = Number(tempStr3);
					break;
				};

				case "cap": {
					
					if (_capInFlag == false) {
						_poiMode.poiGarbage("cap");
						_thankMode.capFlag = true;
						_capInFlag = true;
					}
					
					toPoiMode();

					break;
				};

				case "pet": {
					if (_petInFlag == false) {
						_poiMode.poiGarbage("bottle");
						_petInFlag = true;
						_thankMode.petFlag = true;
						postMessage();
					}
					toPoiMode();
					break;
				};

				case "lab": {
					if (_labelInFlag == false) {
						_poiMode.poiGarbage("label");
						_labelInFlag = true;
						_thankMode.labelFlag = true;
					}	
					toPoiMode();
					break;
				};
			}


			//textUpdate(_distanceLeft, _distanceCenter, _distanceRight);
		}
		

		//左から 1, 2, 3, 4, 5

		private var _count:uint = 0;
		private function onLoop(e:Event):void {

			//trace(mouseX);
			if (_nowNearFlag == false && (_location != 0)) {
				_nowNearFlag = true;
				changeMode("peopleNear");
				_count = 0;
			} 

			//if (_distanceLeft > 100 && _distanceCenter > 100 && _distanceRight > 100) {
			if (_location == 0) {
				_count++;

				if (_count > 300) {
					if (_nowPoiFlag == false) {
						//changeMode("wait");
						//toWaitMode();
					}
					_count = 0;
				}
			}
			if (_nowPoiFlag == false || _nowNearFlag == false) {
				
				if (_location != 0) {
					_peopleNearMode.changePos(_location);
				}
				
				/*
				if (_distanceLeft < 100 && _distanceCenter < 100) {
					_peopleNearMode.changePos(2);
					trace("2");
				} else if (_distanceRight < 100 && _distanceCenter < 100) {
					_peopleNearMode.changePos(4);
					trace("4");
				} else if (_distanceLeft < 100) {
					_peopleNearMode.changePos(1);
					trace("1");
				} else if (_distanceCenter < 100) {
					_peopleNearMode.changePos(3);
					trace("3");
				} else if (_distanceRight < 100) {
					_peopleNearMode.changePos(5);
					trace("5");
				} else {
					//changeMode("wait");
				}
				*/
			}
		}


		private function toPoiMode():void {
			if (_nowPoiFlag == false) {
				_nowPoiFlag = true;
				changeMode("poi");
				_poiMode.startFlag = true;
			}
		}
		private function textUpdate(lef:Number, cent:Number, rig:Number):void {
			_txt.text = "left : " + lef + "\n" + "center : " + cent + "\n" + "right : " + rig;
		}

		private function postMessage():void {

			trace("request!");
			req = new URLRequest("http://210.140.67.223/insert.php");
			req.method = URLRequestMethod.POST;
			param = new URLVariables();
			param.user_name = "kimura1";
			//param.date = "2000-11-11 11:11:11";
			param.cap = 1;
			//trace(param.flash_text);
			req.data = param;
			var loader:URLLoader = new URLLoader(req);
			//navigateToURL(req, "_self");
		}



		//for keyboardDebug
		private function keyDownListener(e:KeyboardEvent):void {

			if (e.keyCode == 32) {
				//_poikun.onGetPet();
				fullSc();
			}

			switch(e.keyCode) {

				//keycode49 = "1"
				case 49: {
					changeMode("peopleNear");
					//_poikun.changeFace("smile");
					//_poikun.tempChange();
					break;
				};
				//2
				case 50: {

					var num = Math.floor(Math.random()*5)+1;
					_peopleNearMode.changePos(num);
					//_poikun.changeFace("happy");
					break;
				};
				//3
				case 51: {
					changeMode("poi");
					_poiMode.startFlag = true;
					//_poikun.changeFace("sleep");
					break;
				};
				//4
				case 52: {
					//_poikun.changeFace("surprise");
					break;
				};
				//5
				case 53: {
					//_poikun.changeFace("white");
					break;
				};
				//6
				case 54: {
				//	_poikun.onGetPet2();
					//postMessage();
					break;
				};
				//7
				case 55: {
					//changeMode("thankyou");
					//_thankMode.comment1();
					break;
				};

				//8
				case 56: {

					if (_capInFlag == false) {
						_poiMode.poiGarbage("cap");
						_thankMode.capFlag = true;
						_capInFlag = true;
					}
					
					toPoiMode();

					break;
				};
				//9
				case 57: {
					if (_petInFlag == false) {
						_poiMode.poiGarbage("bottle");
						_petInFlag = true;
						_thankMode.petFlag = true;
						_waitMode.num++;
						//postMessage();
					}
					toPoiMode();
					break;
				};
				//0
				case 48: {
					if (_labelInFlag == false) {
						_poiMode.poiGarbage("label");
						_labelInFlag = true;
						_thankMode.labelFlag = true;
					}	
					toPoiMode();
					break;
				};


				//"smile","happy","sleep","surprise","white"]
				case 65 : {
					_waitMode.poiChangeFace("smile");
					break;
				};


				case 66 : {
					_waitMode.poiChangeFace("happy");
					break;
				};

				case 67 : {
					_waitMode.poiChangeFace("sleep");
					break;
				};


				case 68 : {
					_waitMode.poiChangeFace("surprise");
					break;
				};
				case 69 : {
					_waitMode.poiChangeFace("white");
					break;
				};


				//felica 
				case 70 : {
					_waitMode.poiChangeFace("white");
					break;
				};
			}
		}

		private function onTimeOver(e:Event):void {
			trace("timeoverです");
			changeMode("thankyou");
			_thankMode.comment1();
		}

		private function onComplete(e:Event):void {
			trace("completです");
			changeMode("thankyou");
			_thankMode.comment1();
		}

		private function toWaiting(e:Event):void {
			toWaitMode();
		}


		private function toWaitMode():void {
			changeMode("wait");

			_nowNearFlag = false;
			_nowPoiFlag = false;
			_capInFlag = false;
			_labelInFlag = false;
			_petInFlag = false;
		}

		private function changeMode(nextModeName:String):void {
			_modeObjects[_nowModeName].visible = true;
			_modeObjects[nextModeName].visible = true;

			Tweener.addTween(_modeObjects[_nowModeName],{time:1,alpha:0,transition:"easeInQuint",onComplete:modeInit,onCompleteParams:[_nowModeName]});
			Tweener.addTween(_modeObjects[nextModeName],{delay:0.5,time:1,alpha:1,transition:"easeInQuad"});
			_nowModeName = nextModeName;
		}

		private function modeInit(mode):void {
			_modeObjects[mode].init();
		}

		private function fullSc():void {
			Mouse.hide();//マウス非表示
			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;//フルスクリーン
		}
	}
}