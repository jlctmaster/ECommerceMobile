import '../auth/terminos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../blocks/auth_block.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../funciones_generales.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final UserCredential userCredential = UserCredential();
  final User user = User();
  int _radioValue1 = -1;
  int correctScore = 0;
  //bool checkBoxTerminos = false;
bool autovalidate_calendario=false;
  String confirmPassword;


  final f = new DateFormat('dd-MM-yyyy hh:mm');
  bool primeraVez=true;
  DateTime selectedDate = DateTime.now().subtract(new Duration(days: 3600));
  TextEditingController _controller;
  String fecha;

  bool checkedValue=false;


  Future<Null> _selectDate(BuildContext context) async {
    DatePicker.showDatePicker(
        context,
        minDateTime:DateTime(1920, 8),
        maxDateTime:DateTime(2010,12),
        initialDateTime: selectedDate,
        locale: DateTimePickerLocale.es,
      //pickerMode: DateTimePickerMode.date,
      dateFormat: 'dd-MMMM-yyyy',
      onConfirm:(dateTime, selectedIndex) {
        setState(() {
          primeraVez=false;
          selectedDate = dateTime;
          _actualizarFecha(selectedDate.toLocal().toString().split(' ')[0]);
        });

      }
    );
  }










  @override
  Widget build(BuildContext context) {
    fecha=f.format(selectedDate.toLocal()).split(' ')[0];
    _controller = new TextEditingController(text: primeraVez ? '' : fecha);
    return Container(
      //decoration: imagenFondo(),
      child:SafeArea(
        child: Column(
          children:[
            topCompletoLogin(context,"Registro de usuario"),
            Container(
              child:subTituloLogin("Ingresa los datos solicitados para crear tu cuenta de usuario."),
              margin: const EdgeInsets.only(bottom: 10.0,left:10.00,right: 10.00),
            ),
            SingleChildScrollView(
              child: Column(

                mainAxisAlignment: MainAxisAlignment.center,

                children: [

                  Form(
                    key: _formKey,

                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10),
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _campoSexo(),
                          //Text(_msjErrorRadio,style:TextStyle(color:Colors.red,fontSize: 12)),
                          _campoTexto('name','Nombre y apellido','Por favor ingrese su nombre y apellido','todo',true),
                          Row(children: <Widget>[
                            Expanded(child: _campoTextoConSelect('rif','Cedula o Rif','Por favor ingrese su Nro. de cedula o rif','tipoRif',<String>['V', 'J', 'G']),),
                            Expanded(child: _Calendario()),
                          ],),
Row(
  children: <Widget>[
    Expanded(child:_campoTexto('email','Correo electrónico','Por favor ingrese la dirección de correo','correo',true)),
    Expanded(child:_campoTexto('tlf','Nro. telefónico','Por favor ingrese su Nro. telefónico','numero',true)),
  ],
),

                          _campoClave(),
                          _campoClaveConf(),
                          _terminosDeUso(),
                          Center(child:_botonRegistro()),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),


          ],
        ),
      ),
    );
  }


  _terminosDeUso(){
    return CheckboxListTile(
      title: InkWell(
        child: Text("Aceptar términos y condiciones de uso", style: TextStyle(fontWeight: FontWeight.bold ,color: Colors.green)),
    onTap: () {

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Terminos()),
      );
    },
    ),
      value: checkedValue,
      onChanged: (newValue) {
        if(newValue){
          setState(() {
            checkedValue=true;
          });

        }else{
          setState(() {
            checkedValue=false;
          });
        }
      },
      controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
    );
  }
  _Calendario(){

    return Padding(
      padding: EdgeInsets.only(top:10),
      child:Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          //Text("Fecha de nacimiento:",style: TextStyle(color: Colors.black54,fontSize: 16),),
          //Text("${selectedDate.toLocal()}".split(' ')[0]),
          TextFormField(
            readOnly: true,
            onTap: () => _selectDate(context),
            validator: (value) {
              return validar('fecha',value,true);
            },
            autovalidate: autovalidate_calendario,
           // onChanged: (a) => setState((){autovalidate_calendario=true;}) ,
            controller: _controller,

            decoration: InputDecoration(
              //hintText: 'Ingrese su nombre y apellido',
              labelText: "Fecha de nacimiento",
            ),
          ),

        ],
      ),
    );
  }
  _campoTexto(String name,String txt_label,String msj_validar,tipo,obligatorio){
    TextInputType tipoKey;
    switch(tipo){
      case 'numero':
        tipoKey=TextInputType.number;
        break;
      case 'correo':
        tipoKey=TextInputType.emailAddress;
        break;
      case 'phone':
        tipoKey=TextInputType.phone;
        break;
      default:
        tipoKey=TextInputType.text;
    }
    //TextInputType emailAddress = TextInputType.emailAddress;
    return TextFormField(
      validator: (value) {
        return validar(tipo,value,obligatorio);
      },
      onSaved: (value) {
        setState(() {
          user.tipo[name]=value;
        });
      },
      keyboardType: tipoKey,
      decoration: InputDecoration(
        //hintText: 'Ingrese su nombre y apellido',
        labelText: txt_label,
      ),
    );

  }
  _campoTextoConSelect(String name,String txt_label,String msj_validar,nameSelect,tipoSelect){
    return Padding(
      padding: EdgeInsets.only(top:4),
      child:  TextFormField(
        validator: (value) {
          return validar('numero',value,true);
        },
        onSaved: (value) {
          setState(() {
            user.tipo[name] = value;
          });
        },
        decoration: InputDecoration(
          //hintText: 'Ingrese su nombre y apellido',
            labelText: txt_label,
            prefix: _select(tipoSelect,nameSelect)
        ),
      ),
    )
   ;

  }
  _select(datos,tipo){
    return
      DropdownButtonHideUnderline(
          child:DropdownButton<String>(

            value: user.tipo[tipo],
            isDense: true,
            iconSize: 22,
            elevation: 16,


            onChanged: (String newValue) {
              setState(() {
                user.tipo[tipo] = newValue;
              });
            },

            items: datos.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ));
  }



  void _handleRadioValueChange1(int value) {
    setState(() {
      _radioValue1 = value;

      if(_validarRadio()){
        user.tipo['sex']='m';
      }
    });
  }
  void _handleRadioValueChange2(int value) {
    setState(() {
      _radioValue1 = value;

      if(_validarRadio()){
        user.tipo['sex']='f';
      }
    });
  }
  bool _validarRadio(){

    //final form = _formKey.currentState;
    // if (form.validate()) {
    // Text forms has validated.
    // Let's validate radios and checkbox
    if (_radioValue1 > 0) {
     // setState(() => _msjErrorRadio='');
      return true;
    }else {
      // Every of the data in the form are valid at this point

      // None of the radio buttons was selected
     // setState(() => _msjErrorRadio='Debe seleccionar un sexo');
      msj('Debe seleccionar un sexo');
      // Fluttertoast.showToast(msg: ,toastLength: Toast.LENGTH_SHORT);
      return false;
    }
    // } else {
    //  setState(() => _autoValidate = true);
    // }

  }

  _campoSexo() {
    return
      Row(
          children: [                      new Text(
            'Sexo :',
            style: new TextStyle(

                fontSize: 17.0,
                color: Color(0xff777777)
            ),
          ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Radio(
                  value: 1,
                  groupValue: _radioValue1,
                  onChanged: _handleRadioValueChange1,
                  activeColor: Color(colorRojo),


                ),
                new Text(
                  'Masculino',
                  style: new TextStyle(fontSize: 16.0),

                ),
                new Radio(
                  value: 2,
                  groupValue: _radioValue1,
                  onChanged: _handleRadioValueChange2,
                  activeColor: Color(colorRojo),
                ),
                new Text(
                  'Femenino',
                  style: new TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),

          ]);

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
          hintText: 'Ingrese la contraseña',
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
  _actualizarFecha(value){
    user.tipo['birthdate']=value;
  }
  _setEmail(String data) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('email', data);
  }
  _setPassword(String data) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('password', data);
  }
  _botonRegistro() {

    return Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: SizedBox(
        width: 150,
        height: 40,
        child: Consumer<AuthBlock>(builder:
            (BuildContext context, AuthBlock auth, Widget child) {
          return checkedValue ? RaisedButton(

            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0),
            ),
            color: Color(colorRojo),
            textColor: Colors.white,
            child: auth.loading && auth.loadingType == 'register' ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ) : Text('Crear cuenta'),
            onPressed: () async {
              if (_validarRadio() && _formKey.currentState.validate() && !auth.loading) {
if(user.tipo['birthdate']==''){
  msj("Seleccione su fecha de nacimiento");
  return false;
}
                _formKey.currentState.save();
                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.
                await auth.register(user);
                if(auth.resJson['success']==true){
                 // setState((){
                    //_setEmail(user.tipo['email']);
                    //_setPassword(user.password);
                  //  Navigator.pushNamed(context, '/confirmar_registro');
                  //});
                  msj(auth.resJson['msj_general']);
                  userCredential.usernameOrEmail = user.tipo['email'];
                  userCredential.password = user.password;
                  bool res=await auth.login(userCredential);
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


/*
                  if(auth.isLoggedIn) {
                    setState(() {
                      Navigator.pushReplacementNamed(context, '/home');
                    });
                  }else{
                    msj(auth.resJson['msj_general']);
                  }
*/






                }else{
                  msj(auth.resJson['msj_general']);
                }

              }
            },
          ) : RaisedButton(            shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),

          ),
            child: Text("Crear cuenta"),

          onPressed: (){
            msj("Lea y acepte los términos y condiciones de uso.");

          },
          );
        }),
      ),
    );
  }

}