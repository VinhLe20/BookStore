<?php
include 'databaseconnect.php';

$name = $_POST['ten'];

$query = $connect->query("INSERT INTO categories(name) VALUES('$name')");