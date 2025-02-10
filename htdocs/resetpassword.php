<?php
include 'databaseconnect.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $email = $_POST['email'];
    $password = $_POST['password'];

    // Kiểm tra xem email có tồn tại hay không
    $sql = "SELECT * FROM users WHERE email = '$email'";
    $result = $connect->query($sql);

    if ($result->num_rows > 0) {
        // Cập nhật mật khẩu mới vào cơ sở dữ liệu
        $updateSql = "UPDATE users SET password = '$password' WHERE email = '$email'";
        if ($connect->query($updateSql) === TRUE) {
            echo "Cập nhật mật khẩu thành công";
        } else {
            echo "Lỗi khi cập nhật mật khẩu: " . $connect->error;
        }
    } else {
        echo "Email không tồn tại";
    }
}
?>