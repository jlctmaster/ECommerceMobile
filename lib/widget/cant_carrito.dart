import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:biomercados/config.dart';
import 'package:flutter/material.dart';

import '../funciones_generales.dart';
class CantCarrito extends StatefulWidget {
  final String campo;
  final ValueChanged<String> onChanged;
  final bool actualizar;
//COLOCAR EL REQUIRED AVERIGUAR EL MOTIVO
  const CantCarrito({Key key, this.campo, @required this.onChanged, this.actualizar}) : super(key: key);
  @override
  _cantCarritoState createState() => _cantCarritoState();
}

class _cantCarritoState extends State<CantCarrito> {
  Timer timer;
  int valorInicial=0;


  String _now;
  Timer _everySecond;



  @override
  void initState() {
    super.initState();

    if (widget.actualizar == true) {
      _now = DateTime
          .now()
          .second
          .toString();

      // defines a timer
      _everySecond = Timer.periodic(Duration(seconds: 3), (Timer t) {
        setState(() {
          _now = DateTime
              .now()
              .second
              .toString();
        });
      });
    }

  }



  @override
  Widget build(BuildContext context) {

    return FutureBuilder(

      future: _cant(),
      builder: (context, projectSnap) {
       // if (projectSnap.connectionState == ConnectionState.done) {
        //  print(projectSnap.data);
         // return Text(projectSnap.data.toString(),style: TextStyle(color: Colors.white, fontSize: 14.0));
          if(projectSnap.data==0){
            return Text('');
          }else {
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
                child: Center(child: Text(projectSnap.data.toString(),
                    style: TextStyle(color: Colors.white,
                        fontSize: 14.0)),) // You can add a Icon instead of text also, like below.
              //child: new Icon(Icons.arrow_forward, size: 50.0, color: Colors.black38)),
            );
          }
       // }else {
       //   return Text("",style: TextStyle(color: Colors.white, fontSize: 14.0));
       // }
      },

    );

  }
_cant() async{
  Map carrito=await getCarrito();
  Map productos;
  int cant=0;
  if(carrito['productos']!=null){

    productos=carrito['productos'];
    productos.forEach((key, value) {
      if(value>0){
        cant++;
      }
    });

    return cant;
  }else{
    return "0";
  }
}

}