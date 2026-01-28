<?php
include 'koneksi.php';

$user_id = $_GET['user_id'];

$query = mysqli_query(
  $connection,
  "SELECT nama, bio FROM users WHERE id='$user_id' LIMIT 1"
);

$data = mysqli_fetch_assoc($query);

if ($data) {
  echo json_encode([
    "status" => true,
    "nama" => $data['nama'],
    "bio" => $data['bio']
  ]);
} else {
  echo json_encode([
    "status" => false,
    "message" => "User tidak ditemukan"
  ]);
}
