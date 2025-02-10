<?php
include "databaseconnect.php";
$name = $_POST['name'];
$age = $_POST['age'];
$address = $_POST['address'];

$query = $connect->query("UPDATE sinhvien SET name ='".$name."',age ='".$age."',address = '".$address."' WHERE id = '1' ");