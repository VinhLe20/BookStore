<?php

include "databaseconnect.php";
$id = $_POST['id'];

$query = $connect->query("UPDATE orders SET status = 'Đang chờ giao hàng' WHERE id = $id ");