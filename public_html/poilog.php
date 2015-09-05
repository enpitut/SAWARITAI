<?php
ini_set('display_errors',1);

# GETでnameとpassを受け取る
$name = (string)$_GET['name'];
$pass = (string)$_GET['pass'];

# MySQLに接続
$mysqli = new mysqli("localhost", "root", "poi", "poipet");
# 接続状況をチェック
if ($mysqli->connect_errno) {
    printf("Connect failed: %s\n", $mysqli->connect_error);
    exit();
}

# nameとパスが存在するか確認
$result1 = $mysqli->query("SELECT user_id from users where user_name='${name}' and pass = '${pass}'");
$user_id = NULL;
if($row = $result1->fetch_assoc()){
    $user_id = $row['user_id'];
}else{
    printf("user does not exist, or password is incorrect");
    exit();
}
$result1->close();


# xml生成
$rootNode = new SimpleXMLElement("<?xml version='1.0' encoding='UTF-8' standalone='yes'?><pois></pois>");
# ユーザのポイログを取得
$result2 = $mysqli->query("SELECT * from pois where user_id='${user_id} order by date'");
while($row = $result2->fetch_assoc()){
    $itemNode = $rootNode->addChild('poi');
    $itemNode->addChild('id',$row['poi_id']);
    $datetime = explode(' ', $row['date']);
    $date = explode('-',$datetime[0]);
    $itemNode->addChild('year',$date[0]);
    $itemNode->addChild('month',$date[1]);
    $itemNode->addChild('day',$date[2]);
    $itemNode->addChild('time',$datetime[1]);
    $itemNode->addChild('cap',$row['cap']);
}
$result2->close();
 
# xmlを整形
$dom = new DOMDocument( '1.0' );
$dom->loadXML( $rootNode->asXML() );
$dom->formatOutput = true;
# xmlを出力
echo $dom->saveXML();

