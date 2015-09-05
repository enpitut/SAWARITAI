<?php
ini_set('display_errors',1);   

$mysqli = new mysqli("localhost", "root", "poi", "poipet");
$result = $mysqli->query("SELECT * FROM pois");
while($row = $result->fetch_assoc()){
    echo htmlentities($row['date']);
}

?>