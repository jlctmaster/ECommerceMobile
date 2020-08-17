import 'package:flutter/material.dart';
import '../funciones_generales.dart';
import '../models/user.dart';
import '../blocks/auth_block.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class cambiarClavePublico extends StatefulWidget {

  @override
  _RecuperarState createState() => _RecuperarState();
}

class _RecuperarState extends State<cambiarClavePublico> {
  final _formKey = GlobalKey<FormState>();
  final User user = User();
  final UserCredential userCredential = UserCredential();
  String confirmPassword;
  @override
  Widget build(BuildContext context) {
    return Container(
      //decoration: imagenFondo(),
      child: Column(
        children: <Widget>[
          espaciadoTop(),
          Row(
            children: <Widget>[
              btnAtras(context)
            ],

          ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0,right: 20.00),
          child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                topLoginB("Cambiar contraseña"),
                subTituloLogin("Ingrese y repita su nueva contraseña."),
                Form(
                  key: _formKey,
                  child: SingleChildScrollView(

                        child: Column(
                      children: <Widget>[
                        _campoClave(),
                        _campoClaveConf(),
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0),
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
                                child: auth.loading && auth.loadingType == 'cambiar_clave_publico' ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ) : Text('Guardar'),
                                onPressed: () async {
                                  if (_formKey.currentState.validate() && !auth.loading) {
                                    _formKey.currentState.save();
                                    // If the form is valid, display a snackbar. In the real world,
                                    // you'd often call a server or save the information in a database.
                                    //final prefs = await SharedPreferences.getInstance();
                                    user.tipo['email']=await _getEmail();
                                    user.tipo['codigoCorreo']=await _getCodigoRecuperacion();

                                    await auth.cambiarClavePublico(user);
                                    if(auth.resJson['success']==true){
                                      msj(auth.resJson['msj_general']);
                                      userCredential.usernameOrEmail = user.tipo['email'];
                                      userCredential.password = user.password;
                                      await auth.login(userCredential);
                                      if(auth.isLoggedIn) {
                                        setState(() {
                                          Navigator.pushNamed(context, '/home');
                                        });
                                      }else{
                                        setState(() {
                                          Navigator.pushNamed(context, '/');
                                        });
                                      }

                                    }else{
                                      msj(auth.resJson['msj_general']);
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
      )
    );
  }
  Future <String> _getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString('email');
    return stringValue;
  }
  Future <String> _getCodigoRecuperacion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('codigoRecuperacion');
  }
  _campoClave() {
    return TextFormField(
        validator: (value) {
          return validar('passb',value,true);
        },
        onSaved: (value) {
          setState(() {
            user.password = value;
          });
        },
        onChanged: (text) {
          user.password = text;
        },
        decoration: InputDecoration(
          ///hintText: 'Ingrese la contraseña',
          labelText: 'Contraseña',
        ),
        obscureText: true);

  }

  _campoClaveConf() {
    return
      TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'Por favor confirme la contraseña';
          } else if (user.password != confirmPassword) {
            return 'Las contraseñas no coinciden';
          }
          return null;
        },
        onChanged: (text) {
          confirmPassword = text;
        },
        decoration: InputDecoration(
          //   hintText: 'Repita la contraseña',
          labelText: 'Confirme la contraseña',
        ),
        obscureText: true,
      );
  }
}
