<?php
include 'databaseconnect.php';
$productid = $_POST['product_id'];
$user_id=$_POST['user_id'];
$sql =$connect->query("DELETE FROM carts WHERE product_id = $productid AND user_id = $user_id");
$result = mysqli_query($connect, $sql);
// Kiểm tra kết quả
if ($result) {
    // Xóa thành công
    echo "Sản phẩm đã được xóa thành công";
} else {
    // Xóa thất bại
    echo "Xóa sản phẩm không thành công";
}
