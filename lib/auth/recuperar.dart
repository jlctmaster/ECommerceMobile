import 'package:flutter/material.dart';
import 'package:biomercados/funciones_generales.dart';
import 'package:biomercados/models/user.dart';
import 'package:biomercados/blocks/auth_block.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Recuperar extends StatefulWidget {
  const Recuperar({ Key key }) : super(key: key);

  @override
  _RecuperarState createState() => _RecuperarState();
}

class _RecuperarState extends State<Recuperar> {
  final _formKey = GlobalKey<FormState>();
  final User user = User();
  @override
  Widget build(BuildContext context) {
    return Container(
     // decoration: imagenFondo(),
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
                topLoginB("Recupera tu contraseña"),
                subTituloLogin("Ingresa el correo electrónico con el que te registraste, te enviaremos un código de verificación."),
                Form(
                  key: _formKey,
                  child: SingleChildScrollView(

                        child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: TextFormField(
                            validator: (value) {
                              return validar('correo',value,true);
                            },
                            onSaved: (value) {
                              setState(() {
                                user.email = value;
                              });
                            },
                            decoration: InputDecoration(
                              //hintText: 'Ingrese su correo electrónico',
                              labelText: 'Correo electrónico',
                            ),
                          ),
                        ),
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
                                child: auth.loading && auth.loadingType == 'recuperar' ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ) : Text('Enviar'),
                                onPressed: () async {
                                  if (_formKey.currentState.validate() && !auth.loading) {
                                    _formKey.currentState.save();

                                    await auth.recuperar(user);
                                    if(auth.resJson['success']==true){
                                      setState((){
                                        _setEmail(user.email);
                                        Navigator.pushNamed(context, '/confirmarCodRecuperacion');
                                      });
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
  _setEmail(String data) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('email', data);
  }
}
