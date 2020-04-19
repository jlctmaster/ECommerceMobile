import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/rendering.dart';
import 'funciones_generales.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'blocks/auth_block.dart';
import 'package:provider/provider.dart';

import 'blocks/modelo.dart';
import 'models/user.dart';
class cambiarClave extends StatefulWidget {
  @override
  _cambiarClaveState createState() => _cambiarClaveState();
}

class _cambiarClaveState extends State<cambiarClave> {
  final _formKey = GlobalKey<FormState>();
  final Modelo modelo = Modelo();
  final UserCredential userCredential = UserCredential();
  String confirmPassword;
  String passwordActual;
  String password;
  bool loading=false;
  @override
  Widget build(BuildContext context) {
    AuthBlock auth = Provider.of<AuthBlock>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Cambiar contraseña'),
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20.0,right: 20.00),
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                   topFormularios("Ingrese su contraseña actual, su nueva contraseña y repita su nueva contraseña."),
                    Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                _campoClaveActual(),
                                _campoClave(),
                                _campoClaveConf(),
                                Container(
                                  padding: EdgeInsets.only(top: 25.0),
                                  child: SizedBox(
                                    width: 150,
                                    height: 40,
                                    child: Consumer<AuthBlock>(builder:
                                        (BuildContext context, AuthBlock auth, Widget child) {
                                      return RaisedButton(
                                        shape: new RoundedRectangleBorder(
                                          borderRadius: new BorderRadius.circular(18.0),
                                        ),
                                        color: Color(0xFFe1251b),
                                        textColor: Colors.white,
                                        child: loading ? CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ) : Text('Cambiar'),
                                        onPressed: () async {
                                          if (_formKey.currentState.validate() && !loading) {
                                            _formKey.currentState.save();
                                            await cambiarClaveProcesar();
                                            if(modelo.resJson['success']==true){
                                              msj(modelo.resJson['msj_general']);
                                              Navigator.of(context).pop();
                                            }else{
                                              msj(modelo.resJson['msj_general']);
                                            }
                                          }
                                        },
                                      );
                                    }),
                                  ),
                                )
                              ],
                            )

                        )
                    ),

                  ],
                ),
              )



            ],
          ),
        )
    );
  }
  _campoClave() {
    return TextFormField(
        validator: (value) {
          return validar('passb',value,true);
        },
        onSaved: (value) {
          setState(() {
            password = value;
          });
        },
        onChanged: (text) {
          password = text;
        },
        decoration: InputDecoration(
         // hintText: 'Ingrese la contraseña',
          labelText: 'Contraseña nueva',
        ),
        obscureText: true);

  }
  _campoClaveActual() {
    return TextFormField(
        validator: (value) {
          return validar('passb',value,true);
        },
        onSaved: (value) {
          setState(() {
            passwordActual = value;
          });
        },
        onChanged: (text) {
          passwordActual = text;
        },
        decoration: InputDecoration(
         // hintText: 'Ingrese la contraseña',
          labelText: 'Contraseña actual',
        ),
        obscureText: true);

  }

  _campoClaveConf() {
    return
      TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'Por favor confirme la contraseña';
          } else if (password != confirmPassword) {
            return 'Las contraseñas no coinciden';
          }
          return null;
        },
        onChanged: (text) {
          confirmPassword = text;
        },
        decoration: InputDecoration(
          //   hintText: 'Repita la contraseña',
          labelText: 'Confirme la contraseña nueva',
        ),
        obscureText: true,
      );
  }


  cambiarClaveProcesar() async {
    loading = true;
    await modelo.cambiarClave(password,passwordActual);

    setState(() {
      loading = false;
    });

  }
}