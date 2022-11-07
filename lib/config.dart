import 'dart:convert';

import 'funciones_generales.dart';

const String BASE_URL = 'http://44.212.34.192/data';
//const String BASE_URL = 'http://127.0.0.1:8000';
//const String BASE_URL_IMAGEN="http://127.0.0.1:8000/storage/";  //se usa para evitar CROSS
const String BASE_URL_IMAGEN = "http://44.212.34.192/storage/"; //se usa para evitar CROSS

//const String BASE_URL = 'http://10.0.1.112';

Future<String> UrlLogin(String uri) async {
  Map user = await getUser();
  if (user != null) {
    if (user['id_sesion'] != null) {
      String id_session = user['id_sesion'] ?? 0;
      return "$BASE_URL/api_rapida.php?id_sesion=$id_session&evento=$uri";
    } else {
      return "$BASE_URL/api_rapida.php?id_sesion=0&evento='uuuuu'";
    }
  } else {
    return "$BASE_URL/api_rapida.php?id_sesion=0&evento='uuuuu'";
  }
}

String UrlNoLogin(String uri) {
  return "$BASE_URL/api_rapida.php?evento=$uri";
}

getUser() async {
  String user = await getData('user');
  if (user != null) {
    return jsonDecode(user);
  } else {
    return null;
  }
}
