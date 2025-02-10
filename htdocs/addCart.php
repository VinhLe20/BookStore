<?php

include 'databaseconnect.php';

$user_id = $_POST['user_id'];
$product_id = $_POST['product_id'];
$quantity = $_POST['quantity'];
$query = $connect->query("INSERT INTO carts(user_id,product_id,quantity) VALUES('$user_id','$product_id','$quantity')");