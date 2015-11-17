<?php
ini_set('display_errors',1); 

# MySQLに接続
$mysqli = new mysqli("localhost", "root", "poi", "poipet");
# 接続状況をチェック
if ($mysqli->connect_errno) {
    printf("Connect failed: %s\n", $mysqli->connect_error);
    exit();
}

#POSTで受け取ったuser_nameがDBに存在すればそのユーザのIDを$user_idにいれる
$user_name = (string)$_POST['user_name'];
if($user_name){
    $user_id = 'NULL';
    $result1 = $mysqli->query("SELECT user_id from users where user_name='${user_name}'");
    if($row = $result1->fetch_assoc()){
        $user_id = $row['user_id'];
        echo $user_id;
    }else{
        $user_id = 'NULL';
    }
    $result1->close();
}else{
    $user_id = 'NULL';
}

#POSTで受け取ったpoipet_idがDBに存在すればそのまま、存在しなければNULLにする
$poipet_id = (string)$_POST['poipet_id'];
if($poipet_id){
    $result1 = $mysqli->query("SELECT * from poipets where poipet_id='${poipet_id}'");
    if($row = $result1->fetch_assoc()){
        echo $poipet_id;
    }else{
        $poipet_id = 'NULL';
    }
    $result1->close();  
}else{
    $poipet_id = 'NULL';
}

#日付　dateで取得
#$date = (string)$_POST['date'];
#date_default_timezone_set('Asia/Tokyo');
#$date = date("Y-m-d H:i:s");

#キャップの有無 1/0
$cap = (string)$_POST['cap'];
   
echo $user_name;
echo $poipet_id;
echo $cap;
if($result2 = $mysqli->query("insert into pois(user_id,poipet_id,date,cap) values(${user_id},${poipet_id}, cast(now() as DATETIME), ${cap})")){
    echo '  insert成功';
}else{
    echo '  insert失敗';
}

?>
