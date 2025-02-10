<?php
include 'databaseconnect.php';

$id = $_POST['id'];
$user_id = $_POST['user_id'];
$total = $_POST['total'];
$pay = $_POST['pay'];
$create = $_POST['create'];
$query = $connect->query("INSERT INTO `orders`(`id`, `user_id`, `total_price`, `create`, `pay`, `status`)  VALUES ('$id','$user_id','$total',NOW(),'$pay','Đang chờ')");

if ($query) {
    echo "add order successfully";
} else {
    echo "Failed to update ";
}