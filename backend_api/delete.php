<?php
header('Content-Type: application/json');
include "konekdb.php";

$id = (int) $_POST['id'];
$stmt = $db->prepare("DELETE FROM siswa WHERE id = ?");
$result = $stmt->execute([$id]);

echo json_encode(['id' => $id, 'success' => $result]);
?>