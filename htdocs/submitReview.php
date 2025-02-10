<?php
include 'databaseconnect.php';

$review = $_POST['review'];
$user_id = $_POST['user_id'];
$product_id = $_POST['product_id'];
$time = $_POST['time'];
$rate = $_POST['rating'];
$query = $connect->query("INSERT INTO `review_comments`(`product_id`, `user_id`, `comment`, `rate`, `time`) VALUES ('$product_id','$user_id','$review','$rate',NOW())");

if ($query) {
    echo "add order successfully";
} else {
    echo "Failed to update ";
}