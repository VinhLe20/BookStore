<?php
 
include 'databaseconnect.php';

$name = $_POST['ten'];
$price = $_POST['dongia'];
$quantity = $_POST['soluong'];
$mota = $_POST['mota'];
$category =  $_POST['theloai'];
$author = $_POST['tacgia'];
$image = $_FILES['image']['name'];
$imagePath = 'uploads/'.$image;
$tmp_name = $_FILES['image']['tmp_name'];
move_uploaded_file($tmp_name,$imagePath);

$query = $connect->query("INSERT INTO products(name,category_id,quantity,price,description,image,author) VALUES('$name','$category','$quantity','$price','$mota','$image','$author')");