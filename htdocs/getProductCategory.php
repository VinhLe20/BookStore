<?php
include 'databaseconnect.php';
$category_id = $_GET['categoryID'];
$queryResult = $connect->query("SELECT * FROM products WHERE status = 1 AND category_id = $category_id");

$result = array();

while($fetchData = $queryResult->fetch_assoc()){
    $result[] =$fetchData;
}

echo json_encode($result);