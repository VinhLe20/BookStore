<?php
include 'databaseconnect.php';
$id = $_GET['id'];
$queryResult = $connect->query("SELECT * FROM users WHERE id=$id");

$result = array();

while($fetchData = $queryResult->fetch_assoc()){
    $result[] =$fetchData;
}

echo json_encode($result);