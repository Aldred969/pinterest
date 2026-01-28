<?php
include 'koneksi.php';

$post_id = $_GET['post_id'];

$query = mysqli_query($connection, "
    SELECT 
        comments.id,
        comments.comment,
        users.nama AS nama
    FROM comments
    JOIN users ON comments.user_id = users.id
    WHERE comments.post_id = '$post_id'
    ORDER BY comments.id DESC
");

$data = [];
while ($row = mysqli_fetch_assoc($query)) {
    $data[] = $row;
}

echo json_encode($data);
