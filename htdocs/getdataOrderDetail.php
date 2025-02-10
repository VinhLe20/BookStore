<?php
include 'databaseconnect.php';

$query = $connect->query("SELECT *,categories.name as category_name,products.name as product_name,orders.id as order_id,orders.status as order_status FROM orders,users,products,order_detail,categories WHERE products.category_id = categories.id AND products.id = order_detail.product_id AND order_detail.order_id = orders.id AND orders.user_id = users.id  ORDER BY orders.id DESC");

$result = array();

while($row = $query->fetch_assoc()){
    $result[] = $row;
}

echo json_encode($result);