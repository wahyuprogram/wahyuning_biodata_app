import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biodata_app/models/api.dart';
import 'package:biodata_app/models/msiswa.dart';
import 'package:biodata_app/widgets/form.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Edit extends StatefulWidget {
  final SiswaModel sw;
  const Edit({super.key, required this.sw});

  @override
  EditState createState() => EditState();
}

class EditState extends State<Edit> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController nisController,
      namaController,
      tpController,
      tgController,
      kelaminController,
      agamaController,
      alamatController;

  // Fungsi Update Data ke PHP
  Future editSw() async {
    return await http.post(
      Uri.parse(BaseUrl.edit),
      body: {
        "id": widget.sw.id.toString(),
        "nis": nisController.text,
        "nama": namaController.text,
        "tplahir": tpController.text,
        "tglahir": tgController.text,
        "kelamin": kelaminController.text,
        "agama": agamaController.text,
        "alamat": alamatController.text
      },
    );
  }

  void _onConfirm(context) async {
    http.Response response = await editSw();
    final data = json.decode(response.body);
    if (data['success']) {
      Fluttertoast.showToast(
          msg: "Perubahan Data Berhasil Disimpan",
          backgroundColor: Colors.green,
          textColor: Colors.white);
      
      // Kembali ke layar sebelumnya (Details)
      // Kita pakai pushNamedAndRemoveUntil agar langsung refresh total ke Home (opsional),
      // tapi untuk simplenya kita pop saja
       Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    // Isi formulir dengan data lama siswa
    nisController = TextEditingController(text: widget.sw.nis);
    namaController = TextEditingController(text: widget.sw.nama);
    tpController = TextEditingController(text: widget.sw.tplahir);
    tgController = TextEditingController(text: widget.sw.tglahir);
    kelaminController = TextEditingController(text: widget.sw.kelamin);
    agamaController = TextEditingController(text: widget.sw.agama);
    alamatController = TextEditingController(text: widget.sw.alamat);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Siswa"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
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
              _onConfirm(context);
            }
          },
          child: const Text("UPDATE", style: TextStyle(fontSize: 18)),
        ),
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
    );
  }
}