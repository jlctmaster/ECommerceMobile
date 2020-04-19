
import 'dart:convert';

import 'package:biomercados/config.dart';

import 'package:http/http.dart' as http;
class Favorites{

  int id;
  int users_id;
  int products_id;
  var res;
  Favorites({this.id,this.users_id,this.products_id});


  Future<Map> guardar() async {
    String url=await UrlLogin('guardarFavorito&products_id=$products_id');
    final response = await http.get(url,
      headers: {"Accept": "application/json"},);
    print(response.body);
    print(response.statusCode);
    res= jsonDecode(response.body);
  }
  Future<Map> consultar() async {
    String url=await UrlLogin('consultarFavorito&products_id=$products_id');
    final response = await http.get(url,
        headers: {"Accept": "application/json"},);
    print(response.body);
    print(response.statusCode);
    res= jsonDecode(response.body);

  }

}