class BaseUrl {
  // KHUSUS WEB (CHROME): Gunakan localhost
  static String ipAddress = "localhost"; 
  static String path = "/biodata"; 

  static String tambah = "http://$ipAddress$path/create.php";
  static String lihat  = "http://$ipAddress$path/details.php";
  static String edit   = "http://$ipAddress$path/update.php";
  static String hapus  = "http://$ipAddress$path/delete.php";
  static String data   = "http://$ipAddress$path/list.php";
}