<?php
header("Content-Type: application/json");

$connection = new mysqli(
  "localhost",
  "pencari2_wirabuana",
  "wirasdnkld12",
  "pencari2_wirabuana_pinterest"
);

if ($connection->connect_error) {
  echo json_encode([
    "status" => false,
    "message" => "Koneksi database gagal"
  ]);
  exit;
}
?>