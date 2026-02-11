import 'package:flutter/material.dart';
import 'package:biodata_app/views/home.dart'; // Mengimpor halaman Home

void main() {
  runApp(const MaterialApp(
    title: 'Biodata Siswa',
    home: Home(), // Menjadikan Home sebagai halaman awal
    debugShowCheckedModeBanner: false,
  ));
}