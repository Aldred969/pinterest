<?php
include 'koneksi.php';

$user_id = $_POST['user_id'];
$caption = $_POST['caption'];

$image = $_FILES['image']['name'];
$tmp   = $_FILES['image']['tmp_name'];

$ext = pathinfo($image, PATHINFO_EXTENSION);
$filename = "post_" . time() . "." . $ext;

// PATH FISIK SERVER
$path = "uploads/images/" . $filename;

move_uploaded_file($tmp, $path);

mysqli_query($connection, "
  INSERT INTO posts (user_id, caption, image)
  VALUES ('$user_id', '$caption', '$path')
");

echo json_encode(["status" => true]);
