import 'package:biomercados/widget/cedula.dart';
import 'package:biomercados/widget/sexo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/intl.dart';
import 'config.dart';
import 'funciones_generales.dart';
import 'blocks/auth_block.dart';
import 'package:provider/provider.dart';
class MiPerfil extends StatefulWidget {
  @override
  _MiPerfilState createState() => _MiPerfilState();
}

class _MiPerfilState extends State<MiPerfil> {
  final _formKey = GlobalKey<FormState>();
  int _radioValue1 = -1;
  int correctScore = 0;
  bool radioCargado = false;
  bool _cargando = false;
  String _msjErrorRadio = "";
  var campo = {
    'rif': '',
    'tipoRif': '',
    'sex': '',
    'name': '',
    'birthdate':''
  };


  final f = new DateFormat('dd-MM-yyyy hh:mm');
  bool primeraVez = false;
  DateTime selectedDate = DateTime.now().subtract(new Duration(days: 3600));
  TextEditingController _controller;
  String fecha;


  @override
  Widget build(BuildContext context) {

    AuthBlock auth = Provider.of<AuthBlock>(context);
    return Scaffold(
        appBar: AppBarBio(context, 'Mi perfil'),
        body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  // Form(
                  // key: _formKey,

                  FutureBuilder(

                    future: _getUsuario(),
                    builder: (context, projectSnap) {
                      if (projectSnap.connectionState == ConnectionState.done) {
                        Map row = projectSnap.data;
                        if (radioCargado == false) {
                          campo = {
                            'rif': row['nro_rif'],
                            'tipoRif': row['nacionalidad'],
                            'sex': row['sex'],
                            'name': row['name'],
                            'birthdate': row['birthdate']
                          };

                          fecha = f.format(DateTime.parse(row['birthdate'])).split(' ')[0];
                        }else{
                          fecha = f.format(selectedDate.toLocal()).split(' ')[0];
                      }

                        _controller = new TextEditingController(text: primeraVez ? '' : fecha);
                        Map rowSelect = {
                          'nroCedula': row['nro_rif'],
                          'nacionalidad': row['nacionalidad']
                        };

                        radioCargado = true;
                        return Padding(
                            padding: EdgeInsets.only(right: 30, left: 30),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Center(child: Icon(
                                    Icons.account_circle, size: 140,
                                    color: Color(colorVerde),),),
                                  Center(child: Text(row['email'],
                                    style: TextStyle(fontSize: 20),),),
                                  _campoTexto('name', 'Nombre y apellido',
                                      'todo', true, row['name']),
                                  Cedula(row: rowSelect,
                                    onChanged: _actualizarCedula,),

                                  _Calendario(),

                                  Sexo(campo: row['sex'],
                                    onChanged: _actualizarSexo,),

                                  _botonRojo()
                                ]
                            )
                        );
                      } else {
                        //print(" add   $projectSnap.data");
                        return Center(child: CircularProgressIndicator(),);
                      }
                    },

                  ),
                  // ),
                ],
              ),
            )
        )
    );
  }

  void _actualizarSexo(value) {
    print("Sexo actualizado " + value);
    campo['sex'] = value;
  }

  void _actualizarCedula(row) {
    print("Cedula actualizada " + row['nacionalidad'] + " " + row['nroCedula']);
    campo['rif'] = row['nroCedula'];
    campo['tipoRif'] = row['nacionalidad'];
  }

  _botonRojo() {
    return Padding(
        padding: const EdgeInsets.only(top: 25.0),
        child: Center(
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
                child: _cargando ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ) : Text('Guardar'),
                onPressed: () async {
                  await _guardarPerfil(campo);
                },
              );
            }),
          ),
        )
    );
  }

  _getUsuario() async {
   // String url = await UrlLogin('getPerfil');
   // Map res=await peticionGet(url);
    Map res= await getData('perfil');
    return res['data'][0];
  }

  _guardarPerfil(campo) async {
    String rif = campo['tipoRif'] + "-" + campo['rif'];
    String sex = campo['sex'];
    String name = campo['name'];
    String birthdate = campo['birthdate'];
    String url = await UrlLogin('actualizarPerfil');
    Map res= await peticionPost(url,{
      'rif':     rif,
      'sex':  sex,
      'name':      name,
      'birthdate':       birthdate,
    });
    await saveData('perfil',res);
    msj(res['msj_general']);
  }

  _campoTexto(String name, String txt_label, tipo, obligatorio, val) {
    TextInputType tipoKey;
    switch (tipo) {
      case 'correo':
        tipoKey = TextInputType.emailAddress;
        break;
      case 'numero':
        tipoKey = TextInputType.number;
        break;
      default:
        tipoKey = TextInputType.text;
    }
    //TextInputType emailAddress = TextInputType.emailAddress;
    return TextFormField(
      initialValue: val,
      validator: (value) {
        return validar(tipo, value, obligatorio);
      },
      onChanged: (value) {
        campo[name] = value;
      },
      keyboardType: tipoKey,
      decoration: InputDecoration(
        //hintText: 'Ingrese su nombre y apellido',
        labelText: txt_label,
      ),
      // focusNode: _focus,
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    DatePicker.showDatePicker(
        context,
        minDateTime:DateTime(1960, 8),
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
  _actualizarFecha(value){
    campo['birthdate']=value;
  }
  _Calendario() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          //Text("Fecha de nacimiento:",style: TextStyle(color: Colors.black54,fontSize: 16),),
          //Text("${selectedDate.toLocal()}".split(' ')[0]),
          TextFormField(
            readOnly: true,
            onTap: () => _selectDate(context),
            validator: (value) {
              return validar('fecha', value, true);
            },
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

}