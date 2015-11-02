const int sensorNum = 3;//フォトリフレクタの数
int analogPins[sensorNum];//アナログピン
int val[sensorNum];//ループごとのそれぞれのフォトリフレクタの値
int firstVal[sensorNum];//それぞれのフォトリフレクタの初期値
int recDiff = 10;//いくつ変化したらINしたとみなすか
unsigned long startTime = 0.;//INしたときの時間
unsigned long span = 300.;//次のINの認識まで何ミリ秒待つか
boolean recognize = true;//今INを認識する状態か否か

const int u_sensorNum = 3;//測距センサの数
int interval[u_sensorNum]; //超音波の受信までにかかった時間
double distance[u_sensorNum]; //距離
double Distance[u_sensorNum][3]; //直前３回までの距離履歴
double LowPass[u_sensorNum][2]; //直前２回までのローパスの値

void setup() {
  Serial.begin(9600);
//  Serial.begin(38400);
  Serial.println("start");
  
  //測距センサ
  pinMode( 2, OUTPUT );
  pinMode( 3, INPUT );
  pinMode( 4, OUTPUT );
  pinMode( 5, INPUT );
  pinMode( 6, OUTPUT );
  pinMode( 7, INPUT );
    
  //LED(測距テスト用)
  pinMode(8, OUTPUT);
  pinMode(9, OUTPUT);
  pinMode(10, OUTPUT);
    
  for(int i = 0; i < 3; i++){
    for(int j = 0; j < 3; j++){
      Distance[i][j] = 0;
      LowPass[i][j] = 0;
    }
  }

  for(int i = 0; i < sensorNum; i++){
    analogPins[i] = i;
    firstVal[i] = analogRead(analogPins[i]);  
  }
}

void loop() {
  
//  if ( Serial.available() > 0 ) {

//        Serial.read();

        // pulse !
        for(int i = 0; i < u_sensorNum + 2; i += 2){
          digitalWrite( i+2, HIGH );
          delayMicroseconds( 100 );
          digitalWrite( i+2, LOW );
        
          // mesure the interval 
          interval[i/2] = pulseIn( i+3, HIGH );
        
          delay(10);
        }

        for(int i = 0; i < 3; i++){
          distance[i] = interval[i] * 0.017; //cm
        }
        
//        Serial.print( distance[0], 4 );
//        Serial.print( "\t" );
//        Serial.print( distance[1], 4 );
//        Serial.print( "\t" );
//        Serial.print( distance[2], 4 );
//        Serial.print( "\n" );
        
        Serial.print("left:");
        Serial.print((int)distance[0]);
        Serial.print(";");
        Serial.print("center:");
        Serial.print((int)distance[1]);
        Serial.print(";");
        Serial.print("right:");
        Serial.print((int)distance[2]);
        Serial.print(";");
        
        for(int i = 0; i < u_sensorNum; i++){
          if(distance[i] < 100){
            digitalWrite(i+8, HIGH);
          }
          else{
            digitalWrite(i+8, LOW);
          }
        }
        
        //average lowpass
//        for(int i = 0; i < u_sensorNum; i++){
//          Distance[i][0] = distance[i]
//          Distance[i][1] = Distance[i][0];
//          Distance[i][2] = Distance[i][1];
//        }
//
//        distance1 = average(LowPass1, Distance1);
//        distance2 = average(LowPass2, Distance2);
//        distance3 = average(LowPass3, Distance3);
        
        //lowpass
        for(int i = 0; i < u_sensorNum; i++){
          LowPass[i][1] = LowPass[i][0];
          LowPass[i][0] = lowPass(LowPass[i][1], distance[i]);
          distance[i] = LowPass[i][0];
        }

//        Serial.print( interval, DEC );
//        Serial.print( "\t" );

//      }
  
//
  for(int i = 0; i < sensorNum; i++){
    val[i] = analogRead(analogPins[i]) ; //アナログ0番ピンからセンサ値を読み込み
  }

  for(int i = 0; i < sensorNum; i++){
  
    if(val[i] > firstVal[i] + recDiff){
      if(recognize){
        if(i == 0){
          Serial.print("petIn;") ; // シリアルモニターへ表示(ボトル)
        }
        if(i == 1){
          Serial.print("capIn;") ; // シリアルモニターへ表示(キャップ)
        }
        if(i == 2){
          Serial.print("labelIn;"); // シリアルモニターへ表示(ラベル)
        }
        startTime = millis();
        recognize = false;
      }
    }
    if(millis() - startTime > span){
      recognize = true;
    }
  }
}

double average(double data[]){
  
  return (data[0] + data[1] + data[2]) / 3;
}

double lowPass(double lowpass, double data){

  return 0.9*lowpass + 0.1*data;
}
