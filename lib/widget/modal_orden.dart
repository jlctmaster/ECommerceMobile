import 'dart:async';
import 'dart:convert';
import 'package:biomercados/home/home.dart';
import 'package:biomercados/home/orden.dart';
import 'package:http/http.dart' as http;
import 'package:biomercados/config.dart';
import 'package:flutter/material.dart';

import '../funciones_generales.dart';
class Modal extends StatefulWidget {
  final String value;
  final int nroOrden;
  final context;
  final ValueChanged<String> onChanged;
//COLOCAR EL REQUIRED AVERIGUAR EL MOTIVO
  const Modal({Key key, this.onChanged, this.value, this.nroOrden, this.context}) : super(key: key);
  @override
  _modalState createState() => _modalState();
}

class _modalState extends State<Modal> {
  bool _cargando=false;

  @override
  Widget build(BuildContext context) {

    return _showAlert(widget.value);

  }
  _showAlert(String value) {
    return new AlertDialog(
      title: new Text('Confirmación'),
      content: new Text(value,
        style: new TextStyle(fontSize: 25.0),),
      actions: <Widget>[
        new FlatButton(onPressed: () async {
          Navigator.pop(context);

        }, child: Text('Cancelar')),
        new FlatButton(onPressed: () async {
          setState(() {
            _cargando = true;
          });
          int resOrden=await _crearOrden();
          if(resOrden>0) {

            Navigator.push(context, MaterialPageRoute(
              builder: (context) => Home(indexTab: 2,),
            ),);
            Navigator.push(context, MaterialPageRoute(
              builder: (context) =>  Orden(id:resOrden.toString(),ordenStatus: 1,textoStatus: "",),
              // builder: (context) => Pagar(ordenStatus: 1,textoStatus: "",nroOrden: resOrden,),
            ),);

          }else{
            msj("Intente mas tarde.");
            // msj("Disculpe se han agotado algunos productos, verifique su carrito e intente de nuevo.");
          }



        }, child:  _cargando ? CircularProgressIndicator() : Text('Si, deseo continuar.')),
      ],
    );

  }
  _crearOrden() async {
    Map carrito=await getCarrito();
    String json=jsonEncode(carrito);
    String url=await UrlLogin('crearOrden&json=$json');
    final response = await http.get(url,headers: {"Accept": "application/json"},);
    print("Respuesta serve: "+response.body);
    Map res= jsonDecode(response.body);
    msj(res['msj_general']);
    if (response.statusCode == 200) {
      await delCarrito();
      await iniciarCarrito();
      return int.parse(res['data'][0]['id']);
    }else{
      return 0;
    }
  }
}