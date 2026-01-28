<?php
include 'koneksi.php';

$comment_id = $_POST['comment_id'];
$user_id    = $_POST['user_id'];

$query = mysqli_query($connection, "
    DELETE FROM comments 
    WHERE id = '$comment_id' AND user_id = '$user_id'
");

if ($query) {
    echo json_encode([
        "status" => true,
        "message" => "Komentar berhasil dihapus"
    ]);
} else {
    echo json_encode([
        "status" => false,
        "message" => "Gagal menghapus komentar"
    ]);
}
