<?php

include "databaseconnect.php";
$id = $_POST['id'];

$query = $connect->query("UPDATE orders SET status = 'Đã hủy' WHERE id = $id ");