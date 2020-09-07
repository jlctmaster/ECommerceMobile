import 'dart:convert';

import '../config.dart';
import '../funciones_generales.dart';
class Favorites{

  int id;
  int users_id;
  int products_id;
  var res;
  Favorites({this.id,this.users_id,this.products_id});


  Future<Map> guardar() async {
    String url=await UrlLogin('guardarFavorito&products_id=$products_id');
    res=await peticionGet(url);
    await saveData('favoritos', res);
    print("EL GUARDADO");
    print(res);
  }
  Future<Map> consultar() async {
    Map no;
    String dataFavorito=await getData('favoritos');

    if(dataFavorito!=null){
      res=jsonDecode(dataFavorito);
      print("SI ES FAVORITO");
    }else{
      res['success']=false;
    }
    //print(res['data']['1210']);
   // String url=await UrlLogin('consultarFavorito&products_id=$products_id');
    //res['success']= res['data'][products_id];

  }

}