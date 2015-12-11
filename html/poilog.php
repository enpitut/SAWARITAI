<?php

ini_set('display_errors',1);

# GETでidを受け取る
$id = (string)$_GET['id'];

# MySQLに接続
$mysqli = new mysqli("localhost", "root", "poi", "poipet");
# 接続状況をチェック
if ($mysqli->connect_errno) {
    printf("Connect failed: %s\n", $mysqli->connect_error);
    exit();
}
$mysqli->query('SET NAMES utf8'); // 日本語設定

# nameが存在するか確認
$result1 = $mysqli->query("SELECT * from users where user_id='${id}'");
if($row = $result1->fetch_assoc()){
    $user_id = $row['user_id'];
    $user_name = $row['user_name'];
}else{
    printf("user does not exist");
    exit();
}
$result1->close();


# xml生成
$rootNode = new SimpleXMLElement('<?xml version="1.0" encoding="UTF-8" ?><pois></pois>');
# ユーザのポイログを取得
$result2 = $mysqli->query("SELECT * FROM pois LEFT JOIN poipets ON pois.poipet_id = poipets.poipet_id WHERE user_id='${user_id}' ORDER BY date");

$rootNode->addChild('user_name',$user_name);
while($row = $result2->fetch_assoc()){
    $itemNode = $rootNode->addChild('poi');
    $itemNode->addChild('poi_id',$row['poi_id']);
    if($row['poipet_id']){
        $itemNode->addChild('poipet_id',$row['poipet_id']);
        $itemNode->addChild('location',$row['locate']);
    }else
        $itemNode->addChild('poipet_id','NULL');
    $datetime = explode(' ', $row['date']);
    $date = explode('-',$datetime[0]);
    $itemNode->addChild('year',$date[0]);
    $itemNode->addChild('month',$date[1]);
    $itemNode->addChild('day',$date[2]);
    $itemNode->addChild('time',$datetime[1]);
    $itemNode->addChild('bottle',$row['bottle']);
    $itemNode->addChild('cap',$row['cap']);
    $itemNode->addChild('label',$row['label']);
}
$result2->close();
# xmlを整形
$dom = new DOMDocument( '1.0', 'UTF-8');
$dom->loadXML( $rootNode->asXML() );
$dom->formatOutput = true;
# xmlを出力
echo $dom->saveXML();

?>
