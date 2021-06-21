import 'dart:convert';
import 'dart:ui';

import '../config.dart';
import '../home/faq.dart';
import '../widget/cant_carrito.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../blocks/auth_block.dart';
import 'package:provider/provider.dart';
import '../funciones_generales.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:Pide/pide_icons.dart';
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
          leading: Icon(Pide.home, color: Color(colorVerdeb), size: 28,),
          title: Text("Inicio", style: TextStyle(color: Colors.black, fontSize: 17)),
          trailing: null,
          onTap: () async {
            Navigator.pop(context);
            await delEvento();
            Navigator.pushNamed(context, '/home');
          },
        ),

         FutureBuilder(
          future: validarSesion(mostrarMsj: false),
          builder: (context, projectSnap) {
            if (projectSnap.connectionState == ConnectionState.done) {
              return _botonesLogin(projectSnap.data,auth);

            }else {
              return CircularProgressIndicator();
            }
          },

        ),

     
     
      

      
    ],
  ),

                ),
              )



          ),




    );
  }
  _menuCerrarSesion(auth){
      return       ListTile(
            leading: Icon(Pide.exit_to_app, color: Color(colorVerdeb), size: 28,),
            title: Text('Cerrar sesión', style: TextStyle(color: Colors.black, fontSize: 17)),

            onTap: () async {
              await auth.logout();
              //Navigator.pushNamedAndRemoveUntil(context,'/', (Route<dynamic> route) => false);
              Fluttertoast.showToast(msg: 'Vuelva pronto.',toastLength: Toast.LENGTH_SHORT);
              cerrar_sesion(context);
            },
          );

  }
  _botonesLogin(isLogin,auth){
    if(isLogin){
      return Column(children: <Widget>[
      botonMenu("Mi perfil",Pide.account_circle,'/miPerfil'),
      botonMenu("Direcciones de entrega",Pide.edit,'/ListadoDirecciones'),
      botonMenu("Dirección de habitación",Pide.edit,'/direccion_habitacion'),
      botonMenu("Cambiar contraseña",Pide.vpn_key,'/cambiarClave'),
      botonMenu("Cambiar contraseña",Pide.local_shipping,'/ordenes'),
      botonMenuRoute("Preguntas frecuentes",Pide.help_outline,Faq()),
      _menuCerrarSesion(auth)
      ],);

    }else{
      return Column(children: <Widget>[
        botonMenu("Iniciar sesión",Pide.vpn_key,'/'),
        botonMenu("Registrarme",Pide.edit,'/registro')

      ],);

    }


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

              leading: Icon(Pide.shopping_basket,
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
    String url='$BASE_URL/api_rapida.php?evento=listar_categorias_movil';
     var uri = Uri.parse(url);
    http.Response response =
    await http.get(uri);
    List responseJson = json.decode(response.body);

    return responseJson;
  }
}
