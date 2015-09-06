package {

	import flash.display.Sprite;
	import flash.display.*;
	import flash.events.KeyboardEvent;
	import flash.ui.Mouse;

	import flash.text.TextField;
	import flash.events.Event;

	import flash.net.*;

	import com.quetwo.Arduino.ArduinoConnector;
	import com.quetwo.Arduino.ArduinoConnectorEvent;


	public class Main extends Sprite {

		private var _width:Number;
		private var _height:Number;

		private var _poikun:Poikun;
		private var _txt:TextField;

		private var param:URLVariables;
		private var req:URLRequest;

		private var _arduino:ArduinoConnector;


		private const ARDUINO_PORT:String = "/dev/tty.usbmodem1421";
		private const ARDUINO_SERIAL_SPEED:uint = 38400
		private const POST_URL:String = "http://210.140.67.223/insert.php";
		private const PORT_USER:String = "kimura1";


		public function Main() {
			init();
		}

		private function init():void {
			_width = stage.stageWidth;
			_height = stage.stageHeight;
		
			_poikun = new Poikun(_width, _height);
			addChild(_poikun);

			/*
			_txt = new TextField();
			addChild(_txt);
			_txt.text = "testttt";
			addChild(_txt);
			_txt.visible = false;
			*/
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);

			_arduino = new ArduinoConnector();
			trace(_arduino.getComPorts()); 
			comm();
		}

		private function comm():void {
			_arduino.connect(ARDUINO_PORT, ARDUINO_SERIAL_SPEED);
			_arduino.addEventListener("socketData",onSock);
		}

		private function onSock(e:Event):void {
			//trace("new message receved");
			var str:String = _arduino.readBytesAsString();

			if (Math.random()*100 < 50) {
				_poikun.onGetPet();
			} else {
				_poikun.onGetPet();	
			}
			postMessage();
			/*
			_txt.text += str;
			_txt.text += "\r";
			*/
		}

		private function postMessage():void {

			req = new URLRequest(POST_URL);
			req.method = URLRequestMethod.POST;
			param = new URLVariables();
			param.user_name = PORT_USER;
			//param.date = "2000-11-11 11:11:11";
			param.cap = 1;
			req.data = param;
			var loader:URLLoader = new URLLoader(req);
		}

		//for debug mode 
		private function keyDownListener(e:KeyboardEvent):void {
			
			switch(e.keyCode) {
				//keycode49 is "space" key
				case 32: {
					fullSc();
					break;
				};

				//keycode49 is "1" key
				case 49: {
					_poikun.changeFace("smile");
					break;
				};
				case 50: {
					_poikun.changeFace("happy");
					break;
				};
				case 51: {
					_poikun.changeFace("sleep");
					break;
				};
				case 52: {
					_poikun.changeFace("surprise");
					break;
				};
				case 53: {
					_poikun.changeFace("white");
					break;
				};
				case 54: {
					_poikun.onGetPet2();
					postMessage();
					break;
				};
			}
		}

		private function fullSc():void {
			Mouse.hide();//マウス非表示
			stage.displayState = StageDisplayState.FULL_SCREEN;//フルスクリーン
		}
	}
}