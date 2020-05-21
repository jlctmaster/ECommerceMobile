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
      title: new Text('Condiciones para realizar el pago',style: TextStyle(color: Colors.green),),
      content: new Text("* Si vas a usar más de 1 método de pago incluyendo el efectivo deberás elegir 1ro el método de pago en efectivo.\n* Puede combinar un máximo de dos pagos ejemplo: (efectivo + transferencia bancaria).",
        style: new TextStyle(fontSize: 25.0),),
      actions: <Widget>[
        new FlatButton(onPressed: () async {
          Navigator.pop(context);
          widget.onChanged(widget.value);
        }, child: Text('Continuar',style: TextStyle(color: Colors.green))),

      ],
    );
  }
  }