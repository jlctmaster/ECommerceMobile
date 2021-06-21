import '../modelo.dart';
import '../widget/recordar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../blocks/auth_block.dart';
import '../funciones_generales.dart';
import '../models/user.dart';
import 'package:provider/provider.dart';
import 'package:Pide/pide_icons.dart';
class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();

}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final UserCredential userCredential = UserCredential();
  var passwordVisible = true;
  int _colorVerde=0xff28b67a;
  bool cargado=false;
bool checkedValue=false;
bool primeraVez=true;
  Future _getTaskAsync;
  @override
  void initState() {
    _getTaskAsync = _valorInicial();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
     // decoration: imagenFondo(),
      child: Column(
       // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: const EdgeInsets.only(bottom: 20.0),
            
            child:btnAtras(context)
            ),
            
         
            Column(
      children: <Widget>[

        logoBio(),
        Padding(padding: const EdgeInsets.only(bottom: 30.0),),
        Center(child: 
      Text("Automercado Online", style: TextStyle(color:Color(colorRojo), fontSize: 22, fontWeight: FontWeight.bold),),
      

        ),
        Center(child: 
      Text("(Acarigua-Araure)", style: TextStyle(color:Color(colorRojo), fontSize: 17, fontWeight: FontWeight.bold),),
      

        ),
        Padding(padding: const EdgeInsets.only(bottom:20.0),),
      ],
    ),
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
                          child: futureCorreo()
                        ),
                        futureClave(),
                        Padding(padding: EdgeInsets.only(top:5.0)),
                        Align(
                          alignment: Alignment.centerRight,
                          child:_a("¿Olvidaste la contraseña?",'/recuperar'),
                        ),
                        futureRecordar(),
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
                                  color: Color(colorRojo),
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
                                      bool res=await auth.login(userCredential);
                                      if(checkedValue==true){
                                        print("RECORDADO");
                                        await setRecordarClave(userCredential.usernameOrEmail, userCredential.password);
                                      }else{
                                        await ModeloTime().borrarRecordarClave();
                                      }
                                      if(res){
                                          msj("Bienvenido.");
                                         // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Home()));
                                         // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Home()));
                                          Navigator.pushReplacementNamed(context, '/home');
                                        //  Navigator.pushNamedAndRemoveUntil(context,'/home', (Route<dynamic> route) => true);
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
                        ),
            Divider(),
            Text("No tienes una cuenta?"),
            RaisedButton(
              child: Text("Registrese aquí"),
              onPressed: (){
              Navigator.pushNamed(context, '/registro');
            })
                      ],
                    ),
                  ),
                ),
              ),
            ),

           
          ]
      ),
    );
  }
  futureCorreo(){
    return FutureBuilder(
      future: _getTaskAsync,
      builder: (context, res) {
        if (res.connectionState == ConnectionState.done) {
          if(res.data==null){
            return campoTextoCorreo('');
          }
          if(res.data['correo']==null){
            return campoTextoCorreo('');
          }else {
            return campoTextoCorreo(res.data['correo']);
          }
        }else {
          return CircularProgressIndicator();
        }
      },
    );
  }
  futureClave(){
    return FutureBuilder(
      future: _getTaskAsync,
      builder: (context, res) {
        if (res.connectionState == ConnectionState.done) {
          if(res.data==null){
            return campoTextoClave('');
          }
            if(res.data['clave']==null){
              return campoTextoClave('');
            }else{
              return campoTextoClave(res.data['clave'] ?? '');
            }

        }else {
          return CircularProgressIndicator();
        }
      },
    );
  }
  campoTextoClave(valorInicial){
    return TextFormField(
initialValue: valorInicial ?? '',
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
                  ? Pide.visibility
                  : Pide.visibility_off,
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

    );
  }
  campoTextoCorreo(valorInicial){
    return TextFormField(
      initialValue: valorInicial,
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

    );
  }
_valorInicial() async {
      Map res=await getRecordarClave();
      return res;
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

  _actualizar(a) {
    checkedValue=a;
  }

  futureRecordar() {
    return FutureBuilder(
      future: _getTaskAsync,
      builder: (context, res) {
        if (res.connectionState == ConnectionState.done) {
          bool tipo=false;
          if(res.data!=null) {
            if (res.data['correo'] != null) {
              tipo = true;
              if (primeraVez) {
                checkedValue = true;
                primeraVez = false;
              }
            }
          }
            return Recordar(onChanged: _actualizar,tipo:tipo);
        }else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}