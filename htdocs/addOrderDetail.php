<?php
include 'databaseconnect.php';

$id = $_POST['product_id'];
$order_id = $_POST['order_id'];
$quantity = $_POST['quantity'];

$query = $connect->query("INSERT INTO order_detail(product_id, order_id,quantity) VALUES ('$id','$order_id','$quantity')");

if ($query) {
    echo "add order successfully";
} else {
    echo "Failed to update ";
}