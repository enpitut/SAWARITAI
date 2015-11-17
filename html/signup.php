<?php
ini_set('display_errors',1); 

# MySQLに接続
$mysqli = new mysqli("localhost", "root", "poi", "poipet");
# 接続状況をチェック
if ($mysqli->connect_errno) {
    printf("Connect failed: %s\n", $mysqli->connect_error);
    exit();
}


if (strlen($_POST['tmp_id'])){
    $tmp_id = (string)$_POST['tmp_id'];
}else{
    echo "tmp_id is missing";
    exit();
}
if (strlen($_POST['user_name'])){
    $user_name = (string)$_POST['user_name'];
}else{
    echo "user_name is missing";
    exit();
}


#POSTで受け取ったtmp_idがDBに存在すればそのfelica_idを$user_idにいれる

$result1 = $mysqli->query("SELECT felica_id from tmp_users where tmp_id = ${tmp_id}");
if($row = $result1->fetch_assoc()){
    $user_id = $row['felica_id'];
    echo $user_id;
}else{
    printf("tmp_id does not exist in tmp_users talbe");
    exit();
}
$result1->close();


if($result = $mysqli -> query("INSERT into users(user_id,user_name) values(${user_id},'${user_name}')")){
    #echo '   insert success';
    if($result = $mysqli -> query("DELETE from tmp_users where tmp_id = ${tmp_id}")){
        #echo " delete success";
    }else{
        echo " delete failed";
        exit();
    }
}else{
    echo '   insert failed';
    exit();
}

?>
