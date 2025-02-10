<?php
include 'databaseconnect.php';

$queryResult = $connect->query("SELECT products.*, categories.name as category_name FROM products,categories WHERE products.category_id = categories.id AND products.status = 1");

$result = array();

while($fetchData = $queryResult->fetch_assoc()){
    $result[] =$fetchData;
}

echo json_encode($result);