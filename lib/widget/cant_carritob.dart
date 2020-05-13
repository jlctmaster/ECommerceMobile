import 'dart:async';
import 'package:flutter/material.dart';

import '../funciones_generales.dart';
class CantCarritob extends StatefulWidget {
  final String campo;
  final ValueChanged<String> onChanged;
  final bool actualizar;
//COLOCAR EL REQUIRED AVERIGUAR EL MOTIVO
  const CantCarritob({Key key, this.campo, this.onChanged, this.actualizar}) : super(key: key);
  @override
  _cantCarritobState createState() => _cantCarritobState();
}

class _cantCarritobState extends State<CantCarritob> {
  Timer timer;
  int valorInicial=0;


  String _now;
  Timer _everySecond;
  int _count = 0;



  @override
  Widget build(BuildContext context) {


    return StreamBuilder<int>(
          stream: _stopwatch(),
          initialData: 0,
          builder: (context, snapshot) {

              return Container(
                  width: 15.0,
                  height: 15.0,
                  // padding: const EdgeInsets.all(3.0),//I used some padding without fixed width and height
                  decoration: new BoxDecoration(

                    shape: BoxShape.circle,
                    // You can use like this way or like the below line
                    //borderRadius: new BorderRadius.circular(30.0),
                    color: Color(colorAmarillo),
                  ),
                  child: Center(child: Text(snapshot.data.toString(),
                      style: TextStyle(color: Colors.white,
                          fontSize: 14.0)),) // You can add a Icon instead of text also, like below.
                //child: new Icon(Icons.arrow_forward, size: 50.0, color: Colors.black38)),
              );



          },
        );
  }
  Stream<int> _stopwatch() async* {
    yield _count=await _cant();
    while (true) {

      await Future.delayed(Duration(seconds: 1));
      yield _count=await _cant();
    }

  }
_cant() async{
  Map carrito=await getCarrito();
  Map productos;
  int cant=0;
  if(carrito['productos']!=null){

    productos=carrito['productos'];
    productos.forEach((key, value) {
      if(value>0){
        cant+=value;
      }
    });

    return cant;
  }else{
    return 0;
  }
}

}