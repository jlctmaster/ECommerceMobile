import 'dart:convert';

import 'config.dart';
import 'funciones_generales.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class Tracking extends StatefulWidget {
  final int nroOrden;

  const Tracking({Key key, this.nroOrden}) : super(key: key);
  @override
  _tracking createState() => _tracking();
}

class _tracking extends State<Tracking>{
  int selectedRadio;
  int selectedRadioMetodoPago;
  @override
  Widget build(BuildContext context) {
    return new Container(child: Column(
      children: <Widget>[
        Padding(padding:EdgeInsets.all(15),child: subTituloLogin("Tracking"),),
        FutureBuilder(
          future: _listarTracking(),
          builder: (context, res) {
            if (res.connectionState == ConnectionState.done) {
              return _lista(res.data);
            }else {
              return Center(child: CircularProgressIndicator(),);
            }
          },
        ),
        Padding(padding: EdgeInsets.only(bottom:10),),
        // _botonPagar(),

      ],
    ),);
  }
  _lista(data){
    if(data!=null) {
      return Flexible(
        child: ListView.builder(
          //physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int index) {

            return Card(
              child: ListTile(
                title: Text(data[index]['name']),
                subtitle:  Row(children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: Text(data[index]['fecha'] ?? ""),)
                  ,
                  Flexible(child: Text(data[index]['description'] ?? ""),)
                ],),

              ),
            );
          },
          padding:EdgeInsets.only(bottom: 20.0),
        ),
      );
    }else {
      return Text(
        "En este momento no el tracking no esta disponible, intente mas tarde.",
        style: TextStyle(fontSize: 20,),
        textAlign: TextAlign.justify,
      );
    }
  }


  _listarTracking() async {
    String urlb=await UrlLogin('listarTracking&orders_id='+widget.nroOrden.toString());
    final response = await http.get(urlb,headers: {"Accept": "application/json"},);
    print(response.body);
    Map res= jsonDecode(response.body);

    if (response.statusCode == 200) {
      return res['data'];
    }else{
      msj(res['msj_general']);
    }
  }
}