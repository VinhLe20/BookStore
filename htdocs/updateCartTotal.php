<?php
include 'databaseconnect.php';
$id = $_POST['id'];
$total = $_POST['total'];

$query = $connect->query("UPDATE carts SET total='$total' WHERE id='$id'");


if ($query) {
    echo "updated successfully";
} else {
    echo "Failed to update ";
}