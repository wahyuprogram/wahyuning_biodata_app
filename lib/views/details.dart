import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biodata_app/models/api.dart';
import 'package:biodata_app/models/msiswa.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'edit.dart'; 

class Details extends StatefulWidget {
  final SiswaModel sw;
  const Details({super.key, required this.sw});

  @override
  DetailsState createState() => DetailsState();
}

class DetailsState extends State<Details> {
  
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
      Navigator.of(context).pop(true);
    }
  }

  void confirmDelete(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: const Text('Apakah Anda yakin ingin menghapus data ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog dulu
                deleteSiswa(context); // Baru jalankan hapus
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("Detail Siswa", style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => confirmDelete(context),
            icon: const Icon(Icons.delete_outline, color: Colors.red),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Agar kotak menyesuaikan isi
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.blue.shade50,
                      child: const Icon(Icons.person, size: 50, color: Colors.blue),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  Text("ID : ${widget.sw.id}", style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text("NIS : ${widget.sw.nis}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Divider(height: 30),
                  
                  Text("Nama : ${widget.sw.nama}", style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 12),
                  Text("Tempat Lahir : ${widget.sw.tplahir}", style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 12),
                  Text("Tanggal Lahir : ${widget.sw.tglahir}", style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 12),
                  Text("Jenis Kelamin : ${widget.sw.kelamin}", style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 12),
                  Text("Agama : ${widget.sw.agama}", style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 12),
                  Text("Alamat : ${widget.sw.alamat}", style: const TextStyle(fontSize: 18)),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: const Icon(Icons.edit),
        onPressed: () async {
           // Menangkap sinyal 'true' dari halaman Edit
           var result = await Navigator.of(context).push(
             MaterialPageRoute(
               builder: (BuildContext context) => Edit(sw: widget.sw),
             ),
           );
           
           // Jika sukses edit, langsung tutup detail & perbarui Home
           if (result == true) {
             Navigator.of(context).pop(true);
           }
        },
      ),
    );
  }
}