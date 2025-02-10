<?php
include 'databaseconnect.php';   

header('Content-Type: application/json');

$data = json_decode(file_get_contents('php://input'), true);

$id = $data['id'];
$name = $data['name'];
$email = $data['email'];
$phone = $data['phone'];
$address = $data['address'];

if (empty($email)) {
    $response = ['status' => 'error', 'message' => 'Email cannot be null'];
} else {
    // Update the user data
    $sql = $connect->query("UPDATE users SET name='$name', email='$email', phone='$phone', address='$address' WHERE id='$id'");

    if ($sql) {
        $response = ['status' => 'success', 'message' => 'User updated successfully'];
    } else {
        $response = ['status' => 'error', 'message' => 'Failed to update user'];
    }
}

echo json_encode($response);
?>
