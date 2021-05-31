import 'package:flutter/material.dart';
import '../funciones_generales.dart';
import '../models/user.dart';
import '../blocks/auth_block.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'countDownTimer.dart';
class confirmar_registro extends StatefulWidget {

  @override
  _RecuperarState createState() => _RecuperarState();
}

class _RecuperarState extends State<confirmar_registro> {
  final _formKey = GlobalKey<FormState>();
  final User user = User();
  final UserCredential userCredential = UserCredential();
  int tiempoRestante=180;
  int statusReenvio=0;
  bool btnCargando=false;
  @override
  Widget build(BuildContext context) {
    return Container(
      //  decoration: imagenFondo(),
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
                  topLoginB("Consulte su correo electrónico"),
                  subTituloLogin("Ingresa el código enviado a su correo electrónico."),
                  Form(
                      key: _formKey,
                      child: SingleChildScrollView(

                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Por favor ingrese el código';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      setState(() {
                                        user.tipo['codigoCorreo'] = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Ingrese el código',
                                      // labelText: 'Correo electrónico',
                                    ),
                                    keyboardType: TextInputType.number
                                ),
                              ),
                              msjCorreoReenviado(),
                              cuentaRegresiva(),
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
                                      child: auth.loading && auth.loadingType == 'confirmar_correo' ? CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ) : Text('Verificar'),
                                      onPressed: () async {
                                        if (_formKey.currentState.validate() && !auth.loading) {
                                          _formKey.currentState.save();
                                          // If the form is valid, display a snackbar. In the real world,
                                          // you'd often call a server or save the information in a database.
                                          //final prefs = await SharedPreferences.getInstance();
                                          user.tipo['email']=await _getEmail();
                                          user.tipo['password']=await _getPassword();
                                          await auth.confirmarCorreo(user);
                                          if(auth.resJson['success']==true){
                                            msj("Bienvenido a PIDE.");

                                            userCredential.usernameOrEmail = user.tipo['email'];
                                            userCredential.password = user.tipo['password'];
                                            await auth.login(userCredential);
                                            if(auth.isLoggedIn) {
                                              setState(() {
                                                Navigator.pushReplacementNamed(context, '/home');
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
  Future <String> _getPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString('password');
    return stringValue;
  }
  Widget msjCorreoReenviado(){
    switch(statusReenvio){
      case 1: return Consumer<AuthBlock>(builder:

          (BuildContext context, AuthBlock auth, Widget child) {
        return RaisedButton(
          child: btnCargando ? CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ) : Text("Reenviar código"),
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
          ),
          color: Color(colorVerde),
          textColor: Colors.white,
          onPressed: () async {
            setState(() {
              btnCargando = true;
            });
            user.email=await _getEmail();
            await auth.recuperar(user);
            if(auth.resJson['success']==true){
              setState((){
                statusReenvio=2;
              });
            }else{
              msj(auth.resJson['msj_general']);
            }

          },
        );
      });
      case 2: return Text("EL código ha sido reenviado, recuerde revisar su bandeja Spam o correo no deseado.");
      default: return Text("Puede reenviar el código a su correo en: ");
    }
  }
  Widget cuentaRegresiva(){
    if(statusReenvio==0) {
      return CountDownTimer(
        secondsRemaining: tiempoRestante,
        whenTimeExpires: () {
          setState(() {
            //tiempoRestante=180;
            statusReenvio = 1;
          });
        },

      );
    }else{
      return Text("");
    }
  }
}