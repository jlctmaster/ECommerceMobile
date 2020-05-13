import 'package:biomercados/config.dart';
import 'package:biomercados/funciones_generales.dart';
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
    res=await getData('favoritos');
    print("EL CONSULTADO");
    //print(res['data']['1210']);
   // String url=await UrlLogin('consultarFavorito&products_id=$products_id');

    //res['success']= res['data'][products_id];

  }

}