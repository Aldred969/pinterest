<?php
include 'koneksi.php';

$username = $_POST['username'];
$password = $_POST['password'];
$nama     = $_POST['nama'];

$cek = mysqli_query(
  $connection,
  "SELECT id FROM users WHERE username='$username'"
);

if (mysqli_num_rows($cek) > 0) {
  echo json_encode([
    "status" => false,
    "message" => "Username sudah digunakan"
  ]);
  exit;
}

$hash = password_hash($password, PASSWORD_DEFAULT);

mysqli_query(
  $connection,
  "INSERT INTO users (username, password, nama)
   VALUES ('$username', '$hash', '$nama')"
);

echo json_encode([
  "status" => true
]);
