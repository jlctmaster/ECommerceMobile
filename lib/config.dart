import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//const String BASE_URL = 'http://bio.frontuari.net';
//const String BASE_URL = 'http://10.10.50.110';
//const String BASE_URL = 'http://192.168.0.110';
const String BASE_URL = 'http://199.188.204.152';
const String BASE_URL_IMAGEN="$BASE_URL/storage/";
//const String BASE_URL = 'http://192.168.1.105';
final storage = FlutterSecureStorage();
Future<String> UrlLogin(String uri) async {
  Map user= await getUser();
  String id_session=user['id_sesion'];
  return "$BASE_URL/api_rapida.php?id_sesion=$id_session&evento=$uri";
}
getUser() async {
  String user = await storage.read(key: 'user');
  if (user != null) {
    return jsonDecode(user);
  }
}