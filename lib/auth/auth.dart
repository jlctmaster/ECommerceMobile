import 'package:flutter/material.dart';
import '../auth/cambiarClavePublico.dart';
import '../auth/confirmarCodRecuperacion.dart';
import '../auth/confirmar_registro.dart';
import 'signin.dart';
import 'signup.dart';
import 'recuperar.dart';

class Auth extends StatelessWidget {
  var vista;
  String correo;
  final List<Widget> tabs = [
    SignUp(),
    SignIn(),
    Recuperar(),
    confirmar_registro(),
    confirmarCodRecuperacion(),
    cambiarClavePublico()

  ];
  Auth(int a){
    vista=a;
  }
  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: false,
     // resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: bottom),
        reverse: true,
        child: tabs[vista])

    );
  }


}