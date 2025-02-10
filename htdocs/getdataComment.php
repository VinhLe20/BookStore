<?php

include 'databaseconnect.php';


$queryResult = $connect->query("SELECT *,users.name as user_name,review_comments.id as comment_id,products.name as products_name FROM review_comments,users,products WHERE review_comments.product_id = products.id AND review_comments.user_id = users.id AND review_comments.status = 1");

$result = array();

while($fetchData = $queryResult->fetch_assoc()){
    $result[] =$fetchData;
}

echo json_encode($result);