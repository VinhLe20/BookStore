<?php
include 'databaseconnect.php';
$email = $_POST['email'];
$password = $_POST['password'];
// Thêm người dùng vào cơ sở dữ liệu
$sql =$connect->query( "INSERT INTO users (email, password) VALUES ('$email', '$password')"); 
?>
