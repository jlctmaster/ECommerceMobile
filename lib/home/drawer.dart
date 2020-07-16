import 'dart:convert';
import 'dart:ui';

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
      color: Colors.white,
        child:
       // if(auth.isLoggedIn)
           Container(
              color: Colors.white,

              child:
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(top: 5),
child: ListView(
    shrinkWrap: true,
    children: <Widget>[
      Image(image: AssetImage('assets/images/logo_peque.png'), height: 130,),
      Padding(padding: EdgeInsets.all(10),),
      ListTile(
          leading: Icon(Icons.home, color: Color(colorVerdeb), size: 28,),
          title: Text("Inicio", style: TextStyle(color: Colors.black, fontSize: 17)),
          trailing: null,
          onTap: () async {
            Navigator.pop(context);
            await delEvento();
            Navigator.pushNamed(context, '/home');
          },
        ),
      botonMenu("Mi perfil",Icons.account_circle,'/miPerfil'),
      botonMenu("bio wallet",Icons.monetization_on,'/biowallet'),
      botonMenu("Direcciones de entrega",Icons.edit,'/ListadoDirecciones'),
      botonMenu("Dirección de habitación",Icons.edit,'/direccion_habitacion'),
      botonMenu("Cambiar contraseña",Icons.vpn_key,'/cambiarClave'),
      botonMenuCarrito("Carrito de compra",Icons.shopping_cart,'/cart'),
      botonMenuRoute("Preguntas frecuentes",Icons.help_outline,Faq()),
      ListTile(
            leading: Icon(Icons.exit_to_app, color: Color(colorVerdeb), size: 28,),
            title: Text('Cerrar sesión', style: TextStyle(color: Colors.black, fontSize: 17)),

            onTap: () async {
              await auth.logout();
              //Navigator.pushNamedAndRemoveUntil(context,'/', (Route<dynamic> route) => false);
              Fluttertoast.showToast(msg: 'Vuelva pronto.',toastLength: Toast.LENGTH_SHORT);
              cerrar_sesion(context);
            },
          )
      ,
    ],
  ),

                ),
              )



          ),




    );
  }
  _Titulo(){
    return Center(child: Text("Categorias",style: TextStyle(fontWeight: FontWeight.bold,color: Color(colorRojo)),));
  }
  _textoSubTitle(String texto){
    return Text(texto,style: TextStyle(color: Colors.white),);
  }
  Widget botonMenu(String nombre,IconData icono,String vista){
    return ListTile(
          leading: Icon(icono, color: Color(colorVerdeb), size: 28,),
          title: Text(nombre, style: TextStyle(color: Colors.black, fontSize: 17)),
          trailing: null,
          onTap: (){
            Navigator.pop(context);
            Navigator.pushNamed(context, vista);
          },
        );
  }
  Widget botonMenuCarrito(String nombre,IconData icono,String vista){
    return ListTile(
          leading: Icon(icono, color: Color(colorVerdeb), size: 28,),
          title: Text(nombre, style: TextStyle(color: Colors.black, fontSize: 17)),
          trailing: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: new BoxDecoration(
              shape: BoxShape.circle,

            ),
            child: CantCarrito(actualizar: false),
          ),
          onTap: (){
            Navigator.pop(context);
            Navigator.pushNamed(context, vista);
          },
        )
    ;
  }

  Widget botonMenuRoute(String nombre,IconData icono,Widget vista){
    return ListTile(
          leading: Icon(icono, color: Color(colorVerdeb), size: 28,),
          title: Text(nombre, style: TextStyle(color: Colors.black, fontSize: 17)),
          onTap: (){
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => vista),
            );
          },
        )
    ;
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
        /*
        int i=0;
        while(res.data[i]!=null){
          return Text(res.data[i]['name']);
          i++;
        }

*/





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
