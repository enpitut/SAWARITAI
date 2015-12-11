<?php
#ini_set('display_errors',1);
#ini_set('default_charset', 'Shift_JIS');
/* 現在の内部文字エンコーディングを表示 */
#echo mb_internal_encoding();

# MySQLに接続
$mysqli = new mysqli("localhost", "root", "poi", "poipet");
# 接続状況をチェック
if ($mysqli->connect_errno) {
    printf("Connect failed: %s\n", $mysqli->connect_error);
    exit();
}

$mysqli->query('SET NAMES utf8'); // 日本語設定

#POST['felica_id']を$felica_idに入れる
if (strlen($_POST['felica_id'])){
    $felica_id = (string)$_POST['felica_id'];
}else{
    echo "felica_id is missing";
    exit();
}


#POSTで受け取ったfelica_idがusersテーブルに存在すれば$user_nameを返す
$result1 = $mysqli->query("SELECT * FROM users WHERE user_id = '${felica_id}'");
if($row1 = $result1->fetch_assoc()){
    $user_name = $row1['user_name'];
    #$user_name_sjis = mb_convert_encoding($user_name,"SJIS","UTF-8");
    echo "user_name=",$user_name;
    exit();
}

###felica_idがusersテーブルに存在しなければ、登録用idを返す
#felica_idがtmp_usesテーブルに存在すれば、登録済の登録用idを返す
$result2 = $mysqli->query("SELECT tmp_id FROM tmp_users WHERE felica_id = '${felica_id}'");
if($row2 = $result2->fetch_assoc()){
    $tmp_id = $row2['tmp_id'];
    echo "tmp_id=",str_pad($tmp_id, 4, 0, STR_PAD_LEFT);
}else{
    #felica_idがtmp_usersテーブルに存在しなければ、新しい登録用idを返す
    $result3 = $mysqli->query("SELECT tmp_id FROM tmp_users WHERE felica_id is NULL ORDER BY RAND()");
    if($row3 = $result3->fetch_assoc()){
        $tmp_id = $row3['tmp_id'];
        echo "tmp_id=",str_pad($tmp_id, 4, 0, STR_PAD_LEFT);
    }else{
        echo "tmp_id not available";
        exit();
    }
    $result3->close();
}
$result2->close();
if($mysqli -> query("UPDATE tmp_users SET felica_id = '${felica_id}', date = cast(now() as DATETIME) WHERE tmp_id = ${tmp_id}")){
    
}else{
    echo "  UPDATE failed";
    exit();
}
$result1->close();

?>
