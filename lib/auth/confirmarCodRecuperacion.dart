import 'package:flutter/material.dart';
import '../funciones_generales.dart';
import '../models/user.dart';
import '../blocks/auth_block.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

//import 'countDownTimer2.dart';
class confirmarCodRecuperacion extends StatefulWidget {
  @override
  _RecuperarState createState() => _RecuperarState();
}

class _RecuperarState extends State<confirmarCodRecuperacion> {
  final _formKey = GlobalKey<FormState>();
  final User user = User();
  final UserCredential userCredential = UserCredential();
  int tiempoRestante = 180;
  int statusReenvio = 0;
  bool btnCargando = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        //decoration: imagenFondo(),
        child: Column(
      children: <Widget>[
        espaciadoTop(),
        Row(
          children: <Widget>[btnAtras(context)],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.00),
          child: Column(
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
                            keyboardType: TextInputType.number),
                      ),
                      msjCorreoReenviado(),
                      cuentaRegresiva(),
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: SizedBox(
                          width: 150,
                          height: 40,
                          child: Consumer<AuthBlock>(builder: (BuildContext context, AuthBlock auth, Widget child) {
                            return ElevatedButton(
                              child: auth.loading && auth.loadingType == 'confirmarCodRecuperacion'
                                  ? CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    )
                                  : Text('Verificar'),
                              onPressed: () async {
                                if (_formKey.currentState.validate() && !auth.loading) {
                                  _formKey.currentState.save();
                                  // If the form is valid, display a snackbar. In the real world,
                                  // you'd often call a server or save the information in a database.
                                  //final prefs = await SharedPreferences.getInstance();
                                  user.tipo['email'] = await _getEmail();

                                  await auth.confirmarCodRecuperacion(user);
                                  if (auth.resJson['success'] == true) {
                                    _setCodigoRecuperacion(user.tipo['codigoCorreo']);
                                    setState(() {
                                      Navigator.pushNamed(context, '/cambiarClavePublico');
                                    });
                                  } else {
                                    msj(auth.resJson['msj_general']);
                                  }
                                }
                              },
                            );
                          }),
                        ),
                      ),
                    ],
                  ))),
            ],
          ),
        )
      ],
    ));
  }

  Future<String> _getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString('email');
    return stringValue;
  }

  _setCodigoRecuperacion(String data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('codigoRecuperacion', data);
  }

  Widget cuentaRegresiva() {
    if (statusReenvio == 0) {
      int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * tiempoRestante;

      return CountdownTimer(
        endTime: endTime,
        onEnd: onEnd,
      );
    } else {
      return Text("");
    }
  }

  void onEnd() {
    setState(() {
      statusReenvio = 1;
    });
  }

  Widget msjCorreoReenviado() {
    switch (statusReenvio) {
      case 1:
        return Consumer<AuthBlock>(builder: (BuildContext context, AuthBlock auth, Widget child) {
          return ElevatedButton(
            child: btnCargando
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : Text("Reenviar código"),
            onPressed: () async {
              setState(() {
                btnCargando = true;
              });
              user.email = await _getEmail();
              await auth.recuperar(user);
              if (auth.resJson['success'] == true) {
                setState(() {
                  statusReenvio = 2;
                });
              } else {
                setState(() {
                  btnCargando = false;
                });
                msj(auth.resJson['msj_general']);
              }
            },
          );
        });
      case 2:
        return Text("EL código ha sido reenviado, recuerde revisar su bandeja Spam o correo no deseado.");
      default:
        return Text("Puede reenviar el código a su correo en: ");
    }
  }
}
