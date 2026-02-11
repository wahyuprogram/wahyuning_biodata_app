class SiswaModel {
  final int id;
  final String nis, nama, tplahir, tglahir, kelamin, agama, alamat;

  SiswaModel({
    required this.id,
    required this.nis,
    required this.nama,
    required this.tplahir,
    required this.tglahir,
    required this.kelamin,
    required this.agama,
    required this.alamat,
  });

  // Mengubah JSON dari PHP menjadi Object Flutter
  factory SiswaModel.fromJson(Map<String, dynamic> json) {
    return SiswaModel(
      // PERBAIKAN: Menggunakan int.parse dengan proteksi jika ID berupa string atau null
      id: json['id'] == null ? 0 : int.parse(json['id'].toString()),
      nis: json['nis'] ?? '',
      nama: json['nama'] ?? '',
      tplahir: json['tplahir'] ?? '',
      tglahir: json['tglahir'] ?? '',
      kelamin: json['kelamin'] ?? '',
      agama: json['agama'] ?? '',
      alamat: json['alamat'] ?? '',
    );
  }

  // Mengubah Object Flutter menjadi JSON (untuk dikirim ke PHP)
  Map<String, dynamic> toJson() => {
    'id': id, // ID kita sertakan juga biar aman
    'nis': nis,
    'nama': nama,
    'tplahir': tplahir,
    'tglahir': tglahir,
    'kelamin': kelamin,
    'agama': agama,
    'alamat': alamat,
  };
}