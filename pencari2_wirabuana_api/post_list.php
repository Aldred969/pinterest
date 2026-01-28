<?php
include 'koneksi.php';

$query = mysqli_query(
  $connection,
  "SELECT posts.id, posts.caption, posts.image, users.username 
   FROM posts 
   JOIN users ON posts.user_id = users.id
   ORDER BY posts.id DESC"
);

$data = [];

while ($row = mysqli_fetch_assoc($query)) {
  $data[] = [
    "id" => $row['id'],
    "caption" => $row['caption'],
    "image" => $row['image'], // contoh: uploads/images/img.jpg
    "username" => $row['username']
  ];
}

echo json_encode($data);
