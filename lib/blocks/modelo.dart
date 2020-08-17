import 'dart:convert';
import '../config.dart';
import 'package:http/http.dart' as http;
import '../funciones_generales.dart';

class Modelo {
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

  Future getCities(_regions_id,{all=false}) async {
     Map data=Map();
    if(citiesCargado==false) {
      if(all){
        data = jsonDecode(await getData('citiesAll'));
      }else{
        data = jsonDecode(await getData('cities'));
      }
      List lista=data['data'];
      List listaNueva=List();
      if (data['success']) {
        int cant = lista.length;
        print(cant);
        for (int i = 0; i < cant; i++) {
          if (lista[i]['regions_id'] == _regions_id) {
            listaNueva.add(lista[i]);
          }
        }
        dataCities = listaNueva;
        citiesCargado = true;
      } else {
        print(data['msj_general']);
      }
    }
    return dataCities;
  }





  Future getRegions(_states_id,{all=false}) async {
    Map data=Map();
    if(regionsCargado==false) {
      if(all){
        data = jsonDecode(await getData('regionsAll'));
      }else{
        data = jsonDecode(await getData('regions'));
      }
    
      List lista=data['data'];
      List listaNueva=List();
      if (data['success']) {
        int cant = lista.length;
        print(cant);
        for (int i = 0; i < cant; i++) {
         if (lista[i]['states_id'] == _states_id) {
           listaNueva.add(lista[i]);
         }
        }
        dataRegions = listaNueva;
        regionsCargado = true;
      } else {
        print(data['msj_general']);
      }
    }
    return dataRegions;
  }




  Future getStates({all=false}) async {

    Map data=Map();
    if(statesCargado==false) {
      if(all){

        data = jsonDecode(await getData('statesAll'));

      }else{
        data = jsonDecode(await getData('states'));
      }
        statesCargado = true;
        if(data['success']==true){
          dataStates=data['data'];
        }else{
          return false;
        }

    }
    return dataStates;
  }
  Future getAdreess() async {

   Map data=jsonDecode(await getData('address'));
   if(data['success']){
     return data['data'];
   }
    return dataAddress;
  }
  Future<Map> guardarDireccion(campo,id) async {
    String url;
    if(id!=null){
      url=await UrlLogin('guardarDireccion&id=$id');
    }else{
      url=await UrlLogin('guardarDireccion');
    }
    Map res=await peticionPost(url,campo);
//print(res['data'][0]);
    saveData('address',res);
    resJson=res;
  }
  Future<Map> guardarDireccionHabitacion(campo,id) async {
    String url;
    if(id!=null){
      url=await UrlLogin('guardarDireccionHabitacion&id=$id');
    }else{
      url=await UrlLogin('guardarDireccionHabitacion');
    }
    Map res=await peticionPost(url,campo);
//print(res['data'][0]);
    saveData('addressHabitacion',res);
    resJson=res;
  }
  Future<Map> eliminarDireccion(id) async {

    String url=await UrlLogin('eliminarDireccion&id=$id');
    final response = await http.get(url,
        headers: {"Accept": "application/json"});
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var a=await getData('address');

      await delIdData('address',id);
      resJson= jsonDecode(response.body);
    } else {
      resJson= jsonDecode(response.body);
    }
  }


}