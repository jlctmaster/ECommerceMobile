import 'dart:convert';

import 'package:biomercados/funciones_generales.dart';


//const String BASE_URL = 'http://bio.frontuari.net';
//const String BASE_URL = 'http://10.10.50.110';
//const String BASE_URL = 'http://192.168.0.110';
//const String BASE_URL = 'http://192.168.0.102';
const String BASE_URL = 'http://199.188.204.152';
const String BASE_URL_IMAGEN="$BASE_URL/storage/"; 
//const String BASE_URL = 'http://10.0.1.112';

Future<String> UrlLogin(String uri) async {
  Map user= await getUser();
  if(user!=null) {
    if (user['id_sesion'] != null) {
      String id_session = user['id_sesion'] ?? 0;
      return "$BASE_URL/api_rapida.php?id_sesion=$id_session&evento=$uri";
    } else {
      return "$BASE_URL/api_rapida.php?id_sesion=0&evento='uuuuu'";
    }
  }else{
    return "$BASE_URL/api_rapida.php?id_sesion=0&evento='uuuuu'";
  }
}

getUser() async {
  String user = await getData('user');
  if (user != null) {
    return jsonDecode(user);
  }else{
    return null;
  }
}
