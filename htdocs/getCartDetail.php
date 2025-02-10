<?php
include 'databaseconnect.php';

$queryResult = $connect->query("SELECT *,carts.quantity as cart_quantity FROM carts ,products WHERE carts.product_id = products.id");

$result = array();

while($fetchData = $queryResult->fetch_assoc()){
    $result[] =$fetchData;
}

echo json_encode($result);