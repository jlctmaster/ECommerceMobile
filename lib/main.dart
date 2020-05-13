import 'package:biomercados/home/combo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:localstorage/localstorage.dart';
import 'auth/auth.dart';
import 'blocks/auth_block.dart';
import 'categorise.dart';
import 'home/home.dart';
import 'product_detail.dart';
import 'settings.dart';
import 'shop/shop.dart';
import 'shop/prueba.dart';
import 'shop/prueba3.dart';
import 'shop/buscador.dart';
import 'wishlist.dart';
import 'carrito.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'cambiarClave.dart';
import 'direcciones.dart';
import 'home/producto.dart';
import 'listadoDirecciones.dart';
import 'mi_perfil.dart';
final LocalStorage storage = new LocalStorage('todo_app');
void main() {

  WidgetsFlutterBinding.ensureInitialized();
  final Locale locale = Locale('eu','ES'); //estaba solo en: en

  runApp(Phoenix(child:
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthBlock()),
      //ChangeNotifierProvider<AuthBlock>.value(value: AuthBlock())
    ],
    child: MaterialApp(
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: [Locale('eu','ES')],
      locale: locale,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Color(0xff80bc00),
          accentColor: Colors.lightBlue[900],
          //fontFamily: locale.languageCode == 'ar' ? 'Dubai' : 'Lato'),
          fontFamily: 'Bree'),
      initialRoute: '/analizar',
      routes: <String, WidgetBuilder>{
        '/producto': (context) => Producto(),
        '/': (BuildContext context) => Auth(1),
        '/analizar': (BuildContext context) => Analizar(),
        '/home': (BuildContext context) => Home(),
        '/combo': (BuildContext context) => Combo(),
        '/prueba': (BuildContext context) => SearchList(),
        '/prueba2': (BuildContext context) => Buscador(),
        '/prueba3': (BuildContext context) => HomePage(),
        '/auth': (BuildContext context) => Auth(1),
        '/registro': (BuildContext context) => Auth(0),
        '/recuperar': (BuildContext context) => Auth(2),
        '/confirmar_registro': (BuildContext context) => Auth(3),
        '/confirmarCodRecuperacion': (BuildContext context) => Auth(4),
        '/cambiarClavePublico': (BuildContext context) => Auth(5),
        '/cambiarClave': (BuildContext context) => cambiarClave(),
        '/shop': (BuildContext context) => Shop(),
        '/categorise': (BuildContext context) => Categorise(),
        '/wishlist': (BuildContext context) => WishList(),
        '/cart': (BuildContext context) => Carrito(),
        '/settings': (BuildContext context) => Settings(),
        '/products': (BuildContext context) => Products(),
        '/miPerfil': (BuildContext context) => MiPerfil(),
        '/direcciones': (BuildContext context) => Direcciones(),
        '/ListadoDirecciones': (BuildContext context) => ListadoDirecciones()
      },
    ),
  )
    ,)
    ,
     );

}
Analizar(){
  String data=storage.getItem('user');
  if(data!=null) {
    return Home();
  }else{
    return Auth(1);
  }
}

class Prueba{

  String _variable="inicio";
  setVariable(value){
    _variable=value;
  }
  getVariable(){
    return _variable;
  }
}

