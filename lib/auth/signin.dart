import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:biomercados/auth/auth.dart';
import 'package:biomercados/auth/signup.dart';
import 'package:biomercados/blocks/auth_block.dart';
import 'package:biomercados/funciones_generales.dart';
import 'package:biomercados/models/user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();

}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final UserCredential userCredential = UserCredential();
  var passwordVisible = true;
  int _colorVerde=0xff28b67a;

  @override
  Widget build(BuildContext context) {
    return Container(
     // decoration: imagenFondo(),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(padding: const EdgeInsets.only(bottom: 50.0),),
            topLoginB("Ingresa a tu cuenta"),
            Center(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: TextFormField(

                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              return validar('correo',value,true);
                            },
                            onSaved: (value) {
                              setState(() {
                                userCredential.usernameOrEmail = value.trim();
                              });
                            },
                            decoration: InputDecoration(

                              // hintText: 'Ingrese el correo electrónico',
                                labelText: 'Correo'

                            ),

                          ),
                        ),
                        TextFormField(

                          validator: (value) {
                            return validar('todo',value,true);
                          },
                          onSaved: (value) {
                            setState(() {
                              userCredential.password = value;
                            });
                          },
                          decoration: InputDecoration(
                            // hintText: 'Ingrese la contraseña',
                              labelText: 'Contraseña',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Color(0xffcccccc),
                                ),
                                onPressed: () {
                                  // Update the state i.e. toogle the state of passwordVisible variable
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                              )
                          ),
                          obscureText: passwordVisible,

                        ),
                        Padding(padding: EdgeInsets.only(top:5.0)),
                        Align(
                          alignment: Alignment.centerRight,
                          child:_a("¿Olvidaste la contraseña?",'/recuperar'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: SizedBox(
                            width: 100,
                            height: 40,
                            child: Consumer<AuthBlock>(
                              builder:
                                  (BuildContext context, AuthBlock auth, Widget child) {
                                return RaisedButton(

                                  shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(18.0),
                                  ),
                                  color: Color(0xFFe1251b),
                                  //color: Colors.red,
                                  textColor: Colors.white,
                                  child: auth.loading && auth.loadingType == 'login' ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ) : Text('Ingresar'),
                                  onPressed: () async {
                                    // Validate form
                                    if (_formKey.currentState.validate() && !auth.loading) {
                                      // Update values
                                      _formKey.currentState.save();
                                      // Hit Api
                                      await auth.login(userCredential);
                                      if(auth.isLoggedIn){
                                        setState((){
                                          msj("Bienvenido.");
                                          //Navigator.pushReplacementNamed(context, '/home');
                                          Navigator.pushNamedAndRemoveUntil(context,'/home', (Route<dynamic> route) => false);
                                        });
                                      }else{
                                        //msj("Credenciales invalidas.");
                                        setState((){
                                        });
                                      }

                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Divider(),
            Text("No tienes una cuenta?"),
            _a("Registrate aquí",'/registro'),
          ]
      ),
    );
  }
  InkWell _a(String texto,String link){
    return InkWell(
      child: Text(texto, style: TextStyle(fontWeight: FontWeight.bold ,color: Color(_colorVerde))),
      onTap: () {
        setState((){
          Navigator.pushNamed(context, link);
        });

      },
    );
  }
}