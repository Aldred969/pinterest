<?php
header("Content-Type: application/json");
include 'koneksi.php';

$user_id = $_GET['user_id'] ?? '';

if ($user_id == '') {
    echo json_encode([
        "status" => false,
        "message" => "user_id tidak boleh kosong"
    ]);
    exit;
}

$query = mysqli_query(
    $connection,
    "SELECT posts.id, posts.image, posts.caption, posts.created_at
     FROM posts
     WHERE posts.user_id = '$user_id'
     ORDER BY posts.id DESC"
);

$data = [];

while ($row = mysqli_fetch_assoc($query)) {
    $data[] = $row;
}

echo json_encode($data);
