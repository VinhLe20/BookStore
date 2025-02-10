<?php
include 'databaseconnect.php';
$id = $_POST['id'];
$product_id = $_POST['product_id'];
$quantity = $_POST['quantity'];
$query =$connect->query( "UPDATE carts SET quantity = $quantity WHERE user_id = $id AND product_id = $product_id");
$result = mysqli_query($connection, $query);

if ($result) {
  // Quantity updated successfully
  echo "Quantity updated";
} else {
  // Error updating quantity
  echo "Error updating quantity";
}

?>
