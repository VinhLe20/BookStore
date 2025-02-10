<?php

include "databaseconnect.php";
$id = $_POST['id'];

$query = $connect->query("UPDATE orders SET status = 'Đã giao thành công', pay='đã thanh toán' WHERE id = $id ");