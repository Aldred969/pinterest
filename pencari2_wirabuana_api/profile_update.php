<?php
include 'koneksi.php';

$user_id = $_POST['user_id'];
$nama    = $_POST['nama'];
$bio     = $_POST['bio'];

$query = mysqli_query(
  $connection,
  "UPDATE users SET nama='$nama', bio='$bio' WHERE id='$user_id'"
);

if ($query) {
  echo json_encode([
    "status" => true,
    "message" => "Profile berhasil diperbarui"
  ]);
} else {
  echo json_encode([
    "status" => false,
    "message" => "Gagal update profile"
  ]);
}
