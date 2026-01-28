<?php
header('Content-Type: application/json');
include 'koneksi.php';

$username = $_POST['username'] ?? '';
$password = $_POST['password'] ?? '';

if ($username == '' || $password == '') {
  echo json_encode([
    'status' => false,
    'message' => 'Username dan password wajib diisi'
  ]);
  exit;
}

$query = mysqli_query(
  $connection,
  "SELECT * FROM users WHERE username='$username' LIMIT 1"
);

$data = mysqli_fetch_assoc($query);

if ($data && password_verify($password, $data['password'])) {
echo json_encode([
  'status' => true,
  'user_id' => $data['id'],
  'nama' => $data['nama'],
  'bio' => $data['bio']
]);
} else {
  echo json_encode([
    'status' => false,
    'message' => 'Username atau password salah'
  ]);
}
