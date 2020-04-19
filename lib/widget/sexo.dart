import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:biomercados/config.dart';
import 'package:flutter/material.dart';

import '../funciones_generales.dart';
class Sexo extends StatefulWidget {
  final String campo;
  final ValueChanged<String> onChanged;
//COLOCAR EL REQUIRED AVERIGUAR EL MOTIVO
  const Sexo({Key key, this.campo, @required this.onChanged}) : super(key: key);
  @override
  _sexoState createState() => _sexoState();
}

class _sexoState extends State<Sexo> {
  String sexoNuevo=null;
  bool _actualizar=true;
  @override
  Widget build(BuildContext context) {
    return Row(
        children: [  new Text(
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
                value: 'm',
                groupValue: _actualizar ? widget.campo : sexoNuevo,
                onChanged: _handleRadioValueChange1,
                activeColor: Color(colorRojo),


              ),
              new Text(
                'Masculino',
                style: new TextStyle(fontSize: 16.0),

              ),
              new Radio(
                value: 'f',
                groupValue: _actualizar ? widget.campo : sexoNuevo,
                onChanged: _handleRadioValueChange1,
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
  void _handleRadioValueChange1(value) {
    widget.onChanged(value);
    setState(() {
      _actualizar=false;

      sexoNuevo=value;

    });
  }

}