<?php
include 'databaseconnect.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $email = $_POST['email'];
    $password = $_POST['password'];

    // Kiểm tra xem email có tồn tại hay không
    $sql = "SELECT * FROM users WHERE email = '$email'";
    $result = $connect->query($sql);

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        // Kiểm tra mật khẩu
        if ($password == $row['password']) {
            echo json_encode(['success' => true, 'message' => 'Đăng nhập thành công']);
          

        } else {
            echo json_encode(['success' => false, 'message' => 'Mật khẩu không đúng']);
        }
    } else {
        echo json_encode(['success' => false, 'message' => 'Email không tồn tại']);
    }

   
} else {
    echo json_encode(['success' => false, 'message' => 'Phương thức yêu cầu không hợp lệ']);
}
?>  