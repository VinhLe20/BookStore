<?php
include 'databaseconnect.php';
$id = $_POST['id'];
$quantity = $_POST['quantity'];

$query = $connect->query("UPDATE products SET quantity = quantity - '$quantity' WHERE id='$id'");


if ($query) {
    echo "updated successfully";
} else {
    echo "Failed to update ";
}