//********************************************************************
//* フォトリフレクタからの入力を表示するプログラム
//********************************************************************
const int sensorNum = 2;//フォトリフレクタの数
int analogPins[sensorNum];//アナログピン
int val[sensorNum];//ループごとのそれぞれのフォトリフレクタの値
int firstVal[sensorNum];//それぞれのフォトリフレクタの初期値
int recDiff = 3;//いくつ変化したらINしたとみなすか
unsigned long startTime = 0.;//INしたときの時間
unsigned long span = 300.;//次のINの認識まで何ミリ秒待つか
boolean recognize = true;//今INを認識する状態か否か

void setup() {
  //Serial.begin(9600);
  Serial.begin(38400);
  Serial.println("start");

  for(int i = 0; i < sensorNum; i++){
    analogPins[i] = i;
    firstVal[i] = analogRead(analogPins[i]);  
  }
}

void loop() {

  for(int i = 0; i < sensorNum; i++){
    val[i] = analogRead(analogPins[i]) ; //アナログ0番ピンからセンサ値を読み込み
  }

  for(int i = 0; i < sensorNum; i++){
    //Serial.print(i); // シリアルモニターへ表示
    //Serial.print(": "); // シリアルモニターへ表示
    //Serial.println(val[i]) ; // シリアルモニターへ表示
  
    if(val[i] < firstVal[i] - recDiff){
      if(recognize){
        if(i == 0){
          Serial.println("BOTTLE IN!!!!!!") ; // シリアルモニターへ表示(ボトル)
        }
        if(i == 1){
          Serial.println("CAP IN!!!!!!") ; // シリアルモニターへ表示(キャップ)
        }
        startTime = millis();
        recognize = false;
      }
    }
    if(millis() - startTime > span){
      recognize = true;
    }
  }

  delay(1); // 1ms待つ
}
