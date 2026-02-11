import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:biodata_app/models/msiswa.dart';
import 'package:biodata_app/models/api.dart';
import 'package:http/http.dart' as http;

import 'create.dart';
import 'details.dart'; // SUDAH DIAKTIFKAN

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  late Future<List<SiswaModel>> sw;

  @override
  void initState() {
    super.initState();
    sw = getSwList();
  }

  // Fungsi untuk mengambil data dari API (PHP)
  Future<List<SiswaModel>> getSwList() async {
    try {
      final response = await http.get(Uri.parse(BaseUrl.data));
      if (response.statusCode == 200) {
        final List<dynamic> items = json.decode(response.body);
        return items.map((json) => SiswaModel.fromJson(json)).toList();
      } else {
        throw Exception('Gagal mengambil data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Fungsi untuk refresh data (dipanggil setelah tambah/edit/hapus data)
  void refreshData() {
    setState(() {
      sw = getSwList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List Data Siswa"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: FutureBuilder<List<SiswaModel>>(
          future: sw,
          builder: (BuildContext context, AsyncSnapshot<List<SiswaModel>> snapshot) {
            // Jika loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } 
            // Jika data kosong atau error
            else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text(
                "Belum ada data siswa",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              );
            }

            // Jika ada data
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                var data = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  elevation: 2,
                  child: ListTile(
                    leading: const Icon(Icons.person, size: 40, color: Colors.blue),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    title: Text(
                      "${data.nis} - ${data.nama}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("${data.tplahir}, ${data.tglahir}"),
                    onTap: () {
                      // Navigasi ke halaman Details
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => Details(sw: data)
                      )).then((value) {
                        // Jika kembali dari detail membawa sinyal 'true' (artinya habis hapus/edit)
                        // Maka refresh list di sini
                        if (value == true) {
                          refreshData();
                        }
                      });
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () {
          // Navigasi ke halaman Create
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const Create();
          })).then((value) {
            // Cek jika kembali membawa nilai 'true' (berhasil simpan)
            if (value == true) {
              refreshData(); // Refresh list di halaman Home
            }
          });
        },
      ),
    );
  }
}