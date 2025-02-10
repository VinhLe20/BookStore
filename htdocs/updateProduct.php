<?php

include 'databaseconnect.php';

$id = $_POST['id']; 
$name = $_POST['ten'];
$price = $_POST['dongia'];
$quantity = $_POST['soluong'];
$mota = $_POST['mota'];
$category_id = $_POST['theloai'];
$author = $_POST['tacgia'];

if (isset($_FILES['image']) && $_FILES['image']['error'] == UPLOAD_ERR_OK) {
    $image = $_FILES['image']['name'];
    $imagePath = 'uploads/' . $image;
    $tmp_name = $_FILES['image']['tmp_name'];
    move_uploaded_file($tmp_name, $imagePath);

    // Update with image
    $query = $connect->query("UPDATE products SET name='$name', quantity='$quantity', price='$price', description='$mota', image='$image',category_id = '$category_id',author = '$author' WHERE id='$id'");
} else {
    // Update without image
    $query = $connect->query("UPDATE products SET name='$name', quantity='$quantity', price='$price', description='$mota' ,category_id = '$category_id',author = '$author' WHERE id='$id'");
}

if ($query) {
    echo "Product updated successfully";
} else {
    echo "Failed to update product";
}
?>
