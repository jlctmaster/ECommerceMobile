import 'dart:convert';

import 'package:Pide/home/ordenes.dart';

import 'modelo.dart';

import 'biowallet.dart';
import 'blocks/nuevo_proveedor.dart';
import 'config.dart';
import 'direccion_habitacion.dart';
import 'funciones_generales.dart';
import 'home/combo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
import 'carrito.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'cambiarClave.dart';
import 'direcciones.dart';
import 'home/producto.dart';
import 'listadoDirecciones.dart';
import 'mi_perfil.dart';
import 'package:responsive_framework/responsive_framework.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Locale locale = Locale('eu', 'ES'); //estaba solo en: en

//final bool vistaPrincipal=await Analizar();
  runApp(
    Phoenix(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthBlock()),
        ],
        child: MaterialApp(
          builder: (context, widget) => ResponsiveWrapper.builder(BouncingScrollWrapper.builder(context, widget),
              maxWidth: 1200,
              minWidth: 450,
              defaultScale: true,
              breakpoints: [
                ResponsiveBreakpoint.resize(450, name: MOBILE),
                ResponsiveBreakpoint.autoScale(800, name: TABLET),
                ResponsiveBreakpoint.autoScale(1000, name: TABLET),
                ResponsiveBreakpoint.resize(1200, name: DESKTOP),
                ResponsiveBreakpoint.autoScale(2460, name: "4K"),
              ],
              background: Container(color: Color(0xFFF5F5F5))),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [Locale('es', 'ES')],
          locale: locale,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Color(0xff80bc00),
            accentColor: Colors.lightBlue[900],

            //fontFamily: locale.languageCode == 'ar' ? 'Dubai' : 'Lato'),
          ),
          initialRoute: '/analizar',
          routes: <String, WidgetBuilder>{
            '/producto': (context) => Producto(),
            '/': (BuildContext context) => Auth(1),
            '/analizar': (BuildContext context) => AnalizarTodo(context),
            //'/analizar': (BuildContext context) => (vistaPrincipal==true ? Home() : Auth(1)),
            '/biowallet': (BuildContext context) => Biowallet(),
            '/home': (BuildContext context) => Home(),
            '/combo': (BuildContext context) => Combo(),
            '/direccion_habitacion': (BuildContext context) => DireccionHabitacion(),
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
            '/cart': (BuildContext context) => Carrito(),
            '/settings': (BuildContext context) => Settings(),
            '/ordenes': (BuildContext context) => Ordenes(),
            '/products': (BuildContext context) => Products(),
            '/miPerfil': (BuildContext context) => MiPerfil(),
            '/direcciones': (BuildContext context) => Direcciones(),
            '/ListadoDirecciones': (BuildContext context) => ListadoDirecciones()
          },
        ),
      ),
    ),
  );
}

AnalizarTodo(context) {
  return FutureBuilder(
    future: Analizar(),
    builder: (context, res) {
      if (res.connectionState == ConnectionState.done) {
        if (res.data) {
          return Home();
        } else {
          return _cargandoInicio(false, context);
        }
      } else {
        return _cargandoInicio(true, context);
      }
    },
  );
}

_cargandoInicio(tipo, context) {
  return Scaffold(
    body: Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 100, bottom: 50),
          child: Center(
            child: Image(image: AssetImage("assets/images/logo_peque.png")),
          ),
        ),
        Center(
          child: tipo
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/analizar');
                  },
                  child: Text("Reintentar"),
                ),
        ),
        Padding(padding: EdgeInsets.only(top: 50)),
        Center(
          child: Text(
            "Automercado Online \n Acarigua - Araure.",
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}

Analizar() async {
  var res = await ModeloTime().listarPrecios();
  saveData('listarPrecios', res);
  String data = await getData('user');
  // print("USUARIO: "+data);
  if (data != null) {
    var evento = 'verificarSesion';
    var url = await UrlLogin(evento);
    var res = await peticionGet(url);

    print("CALOR");
    if (res['success'] != null) {
      // si es true es porque no esta iniciada la sesion
      print("CHINA");
      if (res['success']) {
        print("PARIS");
        var datab = await getData('recuerdo');
        if (datab != null) {
          Map resData = jsonDecode(datab);
          // print(datab);
          if (resData['si'] == true) {
            // print(datab);
            String url = UrlNoLogin('&evento=theBest&email=' + resData['correo'] + '&password=' + resData['clave']);
            print("CACHICAMO");
            Map resh = await peticionGetZlib(url);

            if (resh['success'] == true) {
              await saveDataNoJson('noLogin', 'false');

              await saveData('user', resh['data']['usuario']['data']);
              await setData(resh['data']);

              return true;
            } else {
              await saveDataNoJson('noLogin', 'true');
              return true;
            }
          } else {
            await saveDataNoJson('noLogin', 'true');
            return true;
          }
        }

        await saveDataNoJson('noLogin', 'true');
        return true;
      } else {
        await saveDataNoJson('noLogin', 'false');
        return true;
      }
    }
  } else {
    print("TORPEDO");
    bool res = await loginNoUser();
    if (res) {
      print("TRINO");
      await saveDataNoJson('noLogin', 'true');
      await iniciarCarrito();
      return true;
    } else {
      return false;
    }
  }
}

Future<bool> loginNoUser() async {
  //var status = await Permission.storage.status;

  Map res = Map();
  String url = '$BASE_URL/api_rapida.php?evento=loginNoUser';
  print(url);
  res = await peticionGetZlib(url);
  print(res);
  if (res['success'] == true) {
    await setData(res['data']);
    return true;
  } else {
    msj(res['msj_general']);
    return false;
  }
}

setData(Map value) async {
  value.forEach(await actualizarTodo);
}

void actualizarTodo(key, value) async {
  await saveData(key, value);
}

class Prueba {
  String _variable = "inicio";
  setVariable(value) {
    _variable = value;
  }

  getVariable() {
    return _variable;
  }
}
