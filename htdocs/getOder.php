<?php
include 'databaseconnect.php';

$query = $connect->query("SELECT * FROM oders WHERE status = đang chờ");

$result = array();

while($row = $query->fetch_assoc()){
    $result[] = $row;
}

echo json_encode($result);