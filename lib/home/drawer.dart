import 'dart:convert';

import 'package:biomercados/config.dart';
import 'package:biomercados/home/faq.dart';
import 'package:biomercados/widget/cant_carrito.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:biomercados/blocks/auth_block.dart';
import 'package:provider/provider.dart';
import 'package:biomercados/funciones_generales.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
class AppDrawer extends StatefulWidget {
  final List categorias;

  const AppDrawer({Key key, this.categorias}) : super(key: key);
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    AuthBlock auth = Provider.of<AuthBlock>(context);
    return Container(
      color: Color(colorVerdeb),
        child: Column(


      children: <Widget>[
       // if(auth.isLoggedIn)
           Container(
              color: Colors.white,

              child:
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(20.00),
                  child:Column(
                    children: <Widget>[
                      Image(image: AssetImage('assets/images/logo-bio-en-linea.png')),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            //Divider(),
                           // Text(auth.user['email']),
                            //Text(auth.user['name']),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )



          ),


        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.home,
                    color: Colors.white),
                title: _textoSubTitle("Inicio"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/home');
                },
              ),
              ListTile(
                leading: Icon(Icons.shopping_cart,
                    color: Colors.white),
                title:  _textoSubTitle("Carrito de compra"),
                trailing: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: CantCarrito(actualizar: false,),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/cart');
                },
              ),
              ListTile(
                leading:
                Icon(Icons.settings, color: Colors.white),
                title: _textoSubTitle("Configuración"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/settings');
                },
              ),
              ListTile(
                leading:
                Icon(Icons.help_outline, color: Colors.white),
                title: _textoSubTitle("Preguntas frecuentes"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Faq()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app,
                    color: Colors.white),
                title:  _textoSubTitle('Cerrar sesión'),
                onTap: () async {
                  await auth.logout();
                  Navigator.pushNamedAndRemoveUntil(context,'/', (Route<dynamic> route) => false);
                  Fluttertoast.showToast(msg: 'Vuelve pronto.',toastLength: Toast.LENGTH_SHORT);
                },
              ),
             // _categorias(),
/*
              ListTile(
                leading: Icon(Icons.monetization_on,
                    color: Colors.white),
                title: _textoSubTitle("Bio Wallet"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              ListTile(
                leading:
                    Icon(Icons.fastfood, color: Colors.white),
                title: _textoSubTitle('Categorias'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/categorise');
                },
              ),

              ListTile(
                leading:
                    Icon(Icons.shopping_basket, color: Colors.white),
                title: _textoSubTitle('Combos'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/wishlist');
                },
              ),
              */


              /*ListTile(
                leading: Icon(Icons.favorite,
                    color: Colors.white),
                title:  _textoSubTitle("Conoce a Bio (en construcción)"),
                onTap: () {

                },
              ),
              Divider(),*/


            ],
          ),
        )
      ],
    ),
    );
  }
  _Titulo(){
    return Center(child: Text("Categorias",style: TextStyle(fontWeight: FontWeight.bold,color: Color(colorRojo)),));
  }
  _textoSubTitle(String texto){
    return Text(texto,style: TextStyle(color: Colors.white),);
  }
_categorias(){
  return FutureBuilder(
    future: _cargarCategorias(),
    builder: (context, res) {

      if (res.connectionState == ConnectionState.done) {


        return ListView.builder(
          physics: ClampingScrollPhysics(),
      shrinkWrap: true,
          itemCount: res.data.length,
          itemBuilder: (context, index) {
            final item = res.data[index];
            return ListTile(

              leading: Icon(Icons.shopping_basket,
                  color: Colors.white),
              title: _textoSubTitle(item['name']),
              onTap: () {
                Navigator.pop(context);
              },
            );
             // return Text();
          },
        );
        int i=0;
        while(res.data[i]!=null){
          return Text(res.data[i]['name']);
          i++;
        }







        //return  Text("dd");


      }else {
        return Center(child: CircularProgressIndicator(),);
      }
    },
  );
}
  _cargarCategorias() async {
    http.Response response =
    await http.get('$BASE_URL/api_rapida.php?evento=listar_categorias_movil');
    List responseJson = json.decode(response.body);

    return responseJson;
  }
}
