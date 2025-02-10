<?php
include 'databaseconnect.php';

$queryResult = $connect->query("SELECT * FROM categories WHERE status = 1");

$result = array();

while($fetchData = $queryResult->fetch_assoc()){
    $result[] =$fetchData;
}

echo json_encode($result);