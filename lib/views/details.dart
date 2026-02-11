import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biodata_app/models/api.dart';
import 'package:biodata_app/models/msiswa.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'edit.dart'; // Nanti kita aktifkan setelah file edit.dart dibuat

class Details extends StatefulWidget {
  final SiswaModel sw;
  const Details({super.key, required this.sw});

  @override
  DetailsState createState() => DetailsState();
}

class DetailsState extends State<Details> {
  
  // Fungsi Menghapus Data
  void deleteSiswa(context) async {
    http.Response response = await http.post(
      Uri.parse(BaseUrl.hapus),
      body: {
        'id': widget.sw.id.toString(),
      },
    );
    final data = json.decode(response.body);
    if (data['success']) {
      Fluttertoast.showToast(
          msg: "Data Berhasil Dihapus",
          backgroundColor: Colors.red,
          textColor: Colors.white);
      // Kembali ke Home dengan sinyal 'true' agar Home me-refresh list
      Navigator.of(context).pop(true);
    }
  }

  // Fungsi Konfirmasi Hapus (Dialog)
  void confirmDelete(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text('Apakah Anda yakin ingin menghapus data ini?'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Icon(Icons.cancel),
            ),
            ElevatedButton(
              onPressed: () => deleteSiswa(context),
              child: const Icon(Icons.check_circle),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Siswa"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          // Tombol Hapus (Tong Sampah) di pojok kanan atas
          IconButton(
            onPressed: () => confirmDelete(context),
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "ID : ${widget.sw.id}",
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              "NIS : ${widget.sw.nis}",
              style: const TextStyle(fontSize: 20),
            ),
            const Padding(padding: EdgeInsets.all(10)),
            Text(
              "Nama : ${widget.sw.nama}",
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              "Tempat Lahir : ${widget.sw.tplahir}",
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              "Tanggal Lahir : ${widget.sw.tglahir}",
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              "Jenis Kelamin : ${widget.sw.kelamin}",
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              "Agama : ${widget.sw.agama}",
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              "Alamat : ${widget.sw.alamat}",
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      // Tombol Edit (Pensil)
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.edit),
        onPressed: () {
          // Navigasi ke halaman Edit (Kita aktifkan nanti)
          Navigator.of(context).push(
             MaterialPageRoute(
               builder: (BuildContext context) => Edit(sw: widget.sw),
             ),
           );
        },
      ),
    );
  }
}