import 'dart:convert';

import 'package:biomercados/auth/cambiarClavePublico.dart';
import 'package:biomercados/auth/confirmarCodRecuperacion.dart';
import 'package:biomercados/config.dart';
import 'package:biomercados/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:provider/provider.dart';

import '../funciones_generales.dart';
import 'auth_block.dart';


class Modelo {
  final storage = FlutterSecureStorage();
  Map resJson;
  List resJsonList;
  bool citiesCargado=false;
  List dataCities=null;
  bool addressCargado=false;
  bool regionsCargado=false;
  List dataRegions=null;
  bool statesCargado=false;
  List dataStates=null;
  List dataAddress;
  bool cargando=false;

  Future<Map> cambiarClave(String password,String passwordActual) async {

    String url=await UrlLogin('cambiarClave');
    final response = await http.post(url,
        headers: {"Accept": "application/json"},
        body: {
          'password':     password,
          'passwordActual':     passwordActual,
        });
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      resJson= jsonDecode(response.body);
    } else {
      resJson= jsonDecode(response.body);
    }
  }

/*
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
*/
  Future getCities(_regions_id) async {
    if(citiesCargado==false) {
      String url = "$BASE_URL/api_rapida.php?evento=getCities&regions_id=$_regions_id";
      final response = await http.get(
          url, headers: {"Accept": "application/json"});
      dataCities = jsonDecode(response.body);
      if(response.statusCode==200 && dataCities!=null ) {
        citiesCargado = true;
      }

    }
    return dataCities;
  }
  Future getRegions(_states_id) async {
    if(regionsCargado==false) {
      String url = "$BASE_URL/api_rapida.php?evento=getRegions&states_id=$_states_id";
      final response = await http.get(
          url, headers: {"Accept": "application/json"});
      dataRegions = jsonDecode(response.body);
      if(response.statusCode==200 && dataRegions!=null ) {
        regionsCargado = true;
      }

    }
    return dataRegions;
  }
  Future getStates() async {
    if(statesCargado==false) {
      String url = "$BASE_URL/api_rapida.php?evento=getStates";
      final response = await http.get(
          url, headers: {"Accept": "application/json"});
      dataStates = jsonDecode(response.body);
      if(response.statusCode==200 && dataStates!=null ) {
        statesCargado = true;
      }

    }
    return dataStates;
  }
  Future getAdreess() async {
   // if(addressCargado==false) {
      String url=await UrlLogin('getAdreess');
      final response = await http.get(
          url, headers: {"Accept": "application/json"});
      print(response.body);
      dataAddress = jsonDecode(response.body);
      if(response.statusCode==200 && dataAddress!=null ) {
        addressCargado = true;
      }

   // }
    return dataAddress;
  }
  Future<Map> guardarDireccion(campo,id) async {
    String url;
    if(id!=null){
      url=await UrlLogin('guardarDireccion&id=$id');
    }else{
      url=await UrlLogin('guardarDireccion');
    }
    final response = await http.post(url,
        headers: {"Accept": "application/json"},
        body: campo);
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      resJson= jsonDecode(response.body);
    } else {
      resJson= jsonDecode(response.body);
    }
  }

  Future<Map> eliminarDireccion(id) async {

    String url=await UrlLogin('eliminarDireccion&id=$id');
    final response = await http.get(url,
        headers: {"Accept": "application/json"});
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      resJson= jsonDecode(response.body);
    } else {
      resJson= jsonDecode(response.body);
    }
  }



}