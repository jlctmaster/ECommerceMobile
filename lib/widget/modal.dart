import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import 'package:flutter/material.dart';

import '../funciones_generales.dart';
class Modal extends StatefulWidget {
  final String value;
  final int nroOrden;
  final context;
  final ValueChanged<String> onChanged;
//COLOCAR EL REQUIRED AVERIGUAR EL MOTIVO
  const Modal({Key key, @required this.onChanged, this.value, this.nroOrden, this.context}) : super(key: key);
  @override
  _modalState createState() => _modalState();
}

class _modalState extends State<Modal> {
 bool _cargando=false;

  @override
  Widget build(BuildContext context) {

    return _showAlert(widget.value,widget.nroOrden);

  }
  _showAlert(String value,int nroOrden) {
    return AlertDialog(
        title: new Text('Confirmación'),
        content: new Text(value,
          style: new TextStyle(fontSize: 25.0),),
        actions: <Widget>[
          new FlatButton(onPressed: () {
            Navigator.pop(context);
          }, child: new Text('NO')),
          new FlatButton(onPressed: () async {
            setState(() {
              _cargando = true;
            });
            await _cancelarOrden(nroOrden);

            Navigator.pop(context);
            widget.onChanged("sssssss");
          }, child: _cargando ? CircularProgressIndicator() : Text('SI')),
        ],
      );

  }
 _cancelarOrden(id) async{
   String url=await UrlLogin('cancelarOrden&orders_id=$id');
   var urlb = Uri.parse(url);
   final response = await http.get(urlb,headers: {"Accept": "application/json"},);

   print(response.body);
   msj(jsonDecode(response.body)['msj_general']);

 }
}