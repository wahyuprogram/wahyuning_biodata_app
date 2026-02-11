import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:biodata_app/models/api.dart';
import 'package:biodata_app/widgets/form.dart'; // Memanggil form yang tadi dibuat

class Create extends StatefulWidget {
  const Create({super.key});

  @override
  CreateState createState() => CreateState();
}

class CreateState extends State<Create> {
  final formKey = GlobalKey<FormState>();

  // Controller untuk menampung teks inputan
  final nisController = TextEditingController();
  final namaController = TextEditingController();
  final tpController = TextEditingController();
  final tgController = TextEditingController();
  final kelaminController = TextEditingController();
  final agamaController = TextEditingController();
  final alamatController = TextEditingController();

  // Fungsi Mengirim Data ke PHP
  Future _simpan() async {
    try {
      final response = await http.post(
        Uri.parse(BaseUrl.tambah),
        body: {
          "nis": nisController.text,
          "nama": namaController.text,
          "tplahir": tpController.text,
          "tglahir": tgController.text,
          "kelamin": kelaminController.text,
          "agama": agamaController.text,
          "alamat": alamatController.text,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          Fluttertoast.showToast(
              msg: "Data Berhasil Disimpan",
              backgroundColor: Colors.green,
              textColor: Colors.white);
          
          // Kembali ke Home dan hilangkan halaman create dari history
          Navigator.of(context).pop(true); 
        } else {
          Fluttertoast.showToast(msg: "Gagal Menyimpan Data");
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Siswa"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: AppForm(
          formkey: formKey,
          nisController: nisController,
          namaController: namaController,
          tpController: tpController,
          tgController: tgController,
          kelaminController: kelaminController,
          agamaController: agamaController,
          alamatController: alamatController,
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              _simpan();
            }
          },
          child: const Text("SIMPAN", style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}