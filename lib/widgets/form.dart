import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal
import 'package:dropdown_button2/dropdown_button2.dart'; // Untuk dropdown agama

class AppForm extends StatefulWidget {
  final GlobalKey<FormState> formkey;
  final TextEditingController nisController,
      namaController,
      tpController,
      tgController,
      kelaminController,
      agamaController,
      alamatController;

  const AppForm({
    super.key,
    required this.formkey,
    required this.nisController,
    required this.namaController,
    required this.tpController,
    required this.tgController,
    required this.kelaminController,
    required this.agamaController,
    required this.alamatController,
  });

  @override
  AppFormState createState() => AppFormState();
}

class AppFormState extends State<AppForm> {
  // Data Pilihan Dropdown
  final List<String> genderItems = ["Laki-laki", "Perempuan"];
  final List<String> agamaItems = [
    "Islam", "Katholik", "Protestan", "Hindu", "Budha", "Khonghucu", "Lainnya"
  ];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formkey,
      autovalidateMode: AutovalidateMode.always,
      child: SingleChildScrollView(
        child: Column(
          children: [
            txtInput(widget.nisController, "NIS", Icons.card_membership),
            const SizedBox(height: 10),
            txtInput(widget.namaController, "Nama Lengkap", Icons.person),
            const SizedBox(height: 10),
            txtInput(widget.tpController, "Tempat Lahir", Icons.location_city),
            const SizedBox(height: 10),
            txtTanggal(), // Input Khusus Tanggal
            const SizedBox(height: 10),
            ddKelamin(), // Dropdown Kelamin
            const SizedBox(height: 10),
            ddAgama(), // Dropdown Agama
            const SizedBox(height: 10),
            txtInput(widget.alamatController, "Alamat", Icons.home),
          ],
        ),
      ),
    );
  }

  // WIDGET: Input Teks Biasa (NIS, Nama, Tempat, Alamat)
  Widget txtInput(TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label tidak boleh kosong';
        }
        return null;
      },
    );
  }

  // WIDGET: Input Tanggal (Date Picker)
  Widget txtTanggal() {
    return TextFormField(
      controller: widget.tgController,
      readOnly: true, // Supaya tidak bisa diketik manual
      decoration: InputDecoration(
        labelText: "Tanggal Lahir",
        prefixIcon: const Icon(Icons.calendar_today),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          setState(() {
            widget.tgController.text =
                DateFormat('yyyy-MM-dd').format(pickedDate);
          });
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) return 'Pilih Tanggal Lahir';
        return null;
      },
    );
  }

  // WIDGET: Dropdown Jenis Kelamin
  Widget ddKelamin() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Jenis Kelamin',
        prefixIcon: const Icon(Icons.wc),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
      value: widget.kelaminController.text.isEmpty
          ? null
          : widget.kelaminController.text,
      items: genderItems.map((item) => DropdownMenuItem(
            value: item,
            child: Text(item),
          )).toList(),
      onChanged: (value) {
        setState(() {
          widget.kelaminController.text = value!;
        });
      },
      validator: (value) => value == null ? 'Pilih Jenis Kelamin' : null,
    );
  }

  // WIDGET: Dropdown Agama (Pakai package dropdown_button2 sesuai PDF)
  Widget ddAgama() {
    return DropdownButtonFormField2<String>(
      isExpanded: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
      hint: const Text('Pilih Agama', style: TextStyle(fontSize: 14)),
      items: agamaItems.map((item) => DropdownMenuItem<String>(
            value: item,
            child: Text(item, style: const TextStyle(fontSize: 14)),
          )).toList(),
      value: widget.agamaController.text.isEmpty
          ? null
          : widget.agamaController.text,
      onChanged: (value) {
        setState(() {
          widget.agamaController.text = value.toString();
        });
      },
      validator: (value) => value == null ? 'Pilih Agama' : null,
    );
  }
}