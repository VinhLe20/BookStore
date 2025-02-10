<?php
include 'databaseconnect.php';
$id = $_POST['id'];
$name = $_POST['name'];

$query = $connect->query("UPDATE categories SET name='$name' WHERE id='$id'");


if ($query) {
    echo "updated successfully";
} else {
    echo "Failed to update ";
}