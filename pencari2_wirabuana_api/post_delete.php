<?php
include 'koneksi.php';

$id = $_POST['id'];
$user_id = $_POST['user_id'];

// pastikan post milik user
$cek = mysqli_query($connection,
  "SELECT * FROM posts WHERE id='$id' AND user_id='$user_id'"
);

if (mysqli_num_rows($cek) == 0) {
  echo json_encode([
    "status" => false,
    "message" => "Postingan tidak ditemukan atau bukan milik anda"
  ]);
  exit;
}

// HAPUS KOMENTAR DULU
mysqli_query($connection,
  "DELETE FROM comments WHERE post_id='$id'"
);

// HAPUS POST
mysqli_query($connection,
  "DELETE FROM posts WHERE id='$id'"
);

echo json_encode(["status" => true]);
