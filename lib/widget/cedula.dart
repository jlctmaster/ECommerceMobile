import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:biomercados/config.dart';
import 'package:flutter/material.dart';

import 'package:biomercados/funciones_generales.dart';
class Cedula extends StatefulWidget {
  final Map row;
  final ValueChanged<Map> onChanged;
//COLOCAR EL REQUIRED AVERIGUAR EL MOTIVO
  const Cedula({Key key, this.row, @required this.onChanged}) : super(key: key);
  @override
  _cedulaState createState() => _cedulaState();
}

class _cedulaState extends State<Cedula> {
  Map row = {
  'nroCedula':'',
  'nacionalidad': ''
  };
  bool _actualizar=true;
  @override
  Widget build(BuildContext context) {
    return _campoTextoConSelect('nroCedula','Cedula o Rif','Por favor ingrese su Nro. de cedula o rif','nacionalidad',<String>['V', 'J', 'G']);

  }
  _campoTextoConSelect(String name,String txt_label,String msj_validar,nameSelect,tipoSelect){
    return TextFormField(
      initialValue: widget.row[name],
      validator: (value) {
        return validar('numero',value,true);
      },
      onChanged: (value){
       // nroCedula=value;
        row[name] = value;
        if(row[nameSelect]==''){
          row[nameSelect]=widget.row[nameSelect];
        }
        widget.onChanged(row);
      },


      decoration: InputDecoration(
        //hintText: 'Ingrese su nombre y apellido',
          labelText: txt_label,
          prefix: _select(tipoSelect,nameSelect,name)
      ),
    );

  }
  _select(datos,nameSelect,name){
    return
      DropdownButtonHideUnderline(
          child:DropdownButton<String>(

            value: _actualizar ? widget.row[nameSelect] : row[nameSelect],
            isDense: true,
            iconSize: 22,
            elevation: 16,

            onChanged: (String newValue) {
              print(newValue);

              setState(() {
                row[nameSelect] = newValue;
                if(row[name]==''){
                  row[name]=widget.row[name];
                }
                widget.onChanged(row);
                _actualizar=false;
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

}