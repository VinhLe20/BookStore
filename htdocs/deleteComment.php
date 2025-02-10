<?php
include 'databaseconnect.php';

$id= $_POST['id'];

$query = $connect->query("UPDATE review_comments SET status = 0 WHERE id = $id");