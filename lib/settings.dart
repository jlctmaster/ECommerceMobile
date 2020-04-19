import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/rendering.dart';
import 'funciones_generales.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'blocks/auth_block.dart';
import 'package:provider/provider.dart';
class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  @override
  Widget build(BuildContext context) {
    AuthBlock auth = Provider.of<AuthBlock>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Configuración'),
        ),
        body: SafeArea(
              child: Column(
                children: <Widget>[


                  Expanded(
                    child:  ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        botonMenu("Mi perfil",Icons.account_circle,'/miPerfil'),
                        botonMenu("Direcciones",Icons.edit,'/ListadoDirecciones'),
                        botonMenu("Cambiar contraseña",Icons.vpn_key,'/cambiarClave'),

                      ],
                    ),
                  ),

                ],
              ),
        )
    );
  }
  Widget botonMenu(String nombre,IconData icono,String vista){
    return Card(
        child:ListTile(
      leading: Icon(icono, color: Color(colorVerdeb), size: 28,),
      title: Text(nombre, style: TextStyle(color: Colors.black, fontSize: 17)),
      trailing: Icon(Icons.keyboard_arrow_right, color: Color(colorVerdeb)),
          onTap: (){
            //Navigator.pop(context);
            Navigator.pushNamed(context, vista);
          },
    )
    );
  }
}
