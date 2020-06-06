import 'package:flutter/material.dart';
class ModalPagos extends StatefulWidget {
  final String value;
  final int nroOrden;
  final context;
  final ValueChanged<String> onChanged;
//COLOCAR EL REQUIRED AVERIGUAR EL MOTIVO
  const ModalPagos({Key key, this.onChanged, this.value, this.nroOrden, this.context}) : super(key: key);
  @override
  _modalState createState() => _modalState();
}

class _modalState extends State<ModalPagos> {
  bool nuevoText=false;
  String info="";
  Map res=Map();
  @override
  Widget build(BuildContext context) {

    return new AlertDialog(
      title: new Text('Condiciones para realizar pagos',style: TextStyle(color: Colors.green),),
      content: new Text("*Para realizar pagos combinados de efectivo con otros métodos de pago, debe seleccionar primero el método de pago efectivo.\n*Los pagos en efectivo deben realizarse con montos exactos y para el monto diferencial debe seleccionar otro método de pago.\n*Puede combinar un máximo de dos pagos.\n*Los pagos por tarjeta de crédito, deben ser procesadas por una sola tarjeta de crédito.",
        style: new TextStyle(fontSize: 16.0),textAlign: TextAlign.justify,),
      actions: <Widget>[
        new FlatButton(onPressed: () async {
          Navigator.pop(context);
          widget.onChanged(widget.value);
        }, child: Text('Continuar',style: TextStyle(color: Colors.green))),

      ],
    );
  }
  }
