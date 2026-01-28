<?php
include 'koneksi.php';

$id = $_POST['id'] ?? null;
$caption = $_POST['caption'] ?? null;

if (!$id || !$caption) {
  echo json_encode([
    "status" => false,
    "message" => "Data tidak lengkap"
  ]);
  exit;
}

$query = mysqli_query(
  $connection,
  "UPDATE posts SET caption='$caption' WHERE id='$id'"
);

if ($query) {
  echo json_encode([
    "status" => true,
    "message" => "Post berhasil diupdate"
  ]);
} else {
  echo json_encode([
    "status" => false,
    "message" => "Gagal update post"
  ]);
}
