import 'dart:convert';

import 'package:biomercados/widget/cedula.dart';
import 'package:biomercados/widget/sexo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'config.dart';
import 'funciones_generales.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'blocks/auth_block.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
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
        appBar: AppBar(
          title: Text('Mi perfil'),
        ),
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
                  setState(() {
                    _cargando = true;
                  });
                  await _guardarPerfil(campo);
                  // Navigator.pop(context);
                  setState(() {
                    _cargando = false;
                  });
                },
              );
            }),
          ),
        )
    );
  }

  _getUsuario() async {
    String url = await UrlLogin('getPerfil');
    final response = await http.post(
        url, headers: {"Accept": "application/json"});
    print(response.body);
    Map res = jsonDecode(response.body)['data'][0];
    print(res['nacionalidad']);
    return res;
  }

  _guardarPerfil(campo) async {
    String rif = campo['tipoRif'] + "-" + campo['rif'];
    String sex = campo['sex'];
    String name = campo['name'];
    String birthdate = campo['birthdate'];


    String url = await UrlLogin('actualizarPerfil');
    final response = await http.post(
        url, headers: {"Accept": "application/json"},
        body: {
          "rif": rif,
          "sex": sex,
          "name": name,
          "birthdate":birthdate
        }
    );
    print("Respuesta de actualizar perfil: " + response.body);
    Map res = jsonDecode(response.body);
    if (response.statusCode == 200) {
      //setState(() {
      msj("Su perfil ha sido actualizado");
      //_cargando=true;
      //});
    }
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
    final DateTime picked = await showDatePicker(
        locale: Locale('es'),
        context: context,
        initialDate: DateTime.parse(campo['birthdate']),
        firstDate: DateTime(1960, 8),
        lastDate: DateTime.now().subtract(new Duration(days: 3590)));
    if (picked != null && picked != selectedDate)
      setState(() {
        primeraVez = false;
        selectedDate = picked;
        _actualizarFecha(selectedDate.toLocal().toString().split(' ')[0]);
      });
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