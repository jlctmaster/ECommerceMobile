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
  bool nuevoText = false;
  String info = "";
  Map res = Map();
  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: new Text(
        'Condiciones para realizar pagos',
        style: TextStyle(color: Colors.green),
      ),
      content: new Text(
        "Puede combinar 2 metodos de pago.\nLos pagos en 'dólares en efectivo' deben realizarse solo por nuestra tienda PIDE.",
        style: new TextStyle(fontSize: 16.0),
        textAlign: TextAlign.justify,
      ),
      actions: <Widget>[
        new TextButton(
            onPressed: () async {
              Navigator.pop(context);
              widget.onChanged(widget.value);
            },
            child: Text('Continuar', style: TextStyle(color: Colors.green))),
      ],
    );
  }
}
