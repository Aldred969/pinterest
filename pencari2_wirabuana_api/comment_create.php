<?php
include 'koneksi.php';

$post_id = $_POST['post_id'];
$user_id = $_POST['user_id'];
$comment = $_POST['comment'];

if (!$post_id || !$user_id || !$comment) {
  echo json_encode(['status'=>false,'message'=>'Data tidak lengkap']);
  exit;
}

mysqli_query($connection,
  "INSERT INTO comments (post_id,user_id,comment)
   VALUES ('$post_id','$user_id','$comment')"
);

echo json_encode(['status'=>true]);
