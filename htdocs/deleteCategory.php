<?php
include 'databaseconnect.php';

$id= $_POST['id'];

$query = $connect->query("UPDATE categories SET status = 0 WHERE id = $id");