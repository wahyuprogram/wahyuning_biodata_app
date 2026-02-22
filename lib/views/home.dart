import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:biodata_app/models/msiswa.dart';
import 'package:biodata_app/models/api.dart';
import 'package:http/http.dart' as http;

import 'create.dart';
import 'details.dart'; 

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

  // Fungsi untuk refresh data
  void refreshData() {
    setState(() {
      sw = getSwList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50, // Warna background natural
      appBar: AppBar(
        title: const Text("Data Siswa", style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black, // Teks hitam agar elegan
        elevation: 0,
      ),
      body: Center(
        child: FutureBuilder<List<SiswaModel>>(
          future: sw,
          builder: (BuildContext context, AsyncSnapshot<List<SiswaModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(color: Colors.blue);
            } 
            else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_open, size: 60, color: Colors.grey),
                  SizedBox(height: 16),
                  Text("Belum ada data siswa", style: TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                var data = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 0, // Dibuat flat natural
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200), // Garis luar kotak
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade50,
                      child: const Icon(Icons.person, color: Colors.blue),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                    title: Text(
                      "${data.nis} - ${data.nama}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("${data.tplahir}, ${data.tglahir}", style: TextStyle(color: Colors.grey.shade600)),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => Details(sw: data)
                      )).then((value) {
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
        backgroundColor: Colors.blue, // Dibuat senada
        foregroundColor: Colors.white,
        elevation: 2,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const Create();
          })).then((value) {
            if (value == true) {
              refreshData(); 
            }
          });
        },
      ),
    );
  }
}