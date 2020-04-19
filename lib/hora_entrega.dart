import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:biomercados/config.dart';
import 'package:flutter/material.dart';

import 'funciones_generales.dart';
class HoraEntrega extends StatefulWidget {
  @override
  _hora_entregaState createState() => _hora_entregaState();
}


class _hora_entregaState extends State<HoraEntrega> {
  String _mySelection;
  List data = List();
  bool _valorInicial=false;
  var _valueSelect;
  Map datos=Map();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _horasDisponiblesEntrega(),
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.done) {
          print(projectSnap.data);

          List horas=projectSnap.data;
          return DropdownButton(

            items: horas?.map((item) {
              datos[item['id']]=item['time'];
              if(!_valorInicial){
                _valueSelect=item['id'];
                setOtroCarrito('hora_entrega', datos[_valueSelect].toString());
                _valorInicial=true;
              }
              return DropdownMenuItem(
                child: Text(item['name']),
                value: item['id'],
              );
            })?.toList() ?? [],
            hint: Text("Hora de entrega",),
            onChanged: (newVal) {
              setState(() {
                setOtroCarrito('hora_entrega', datos[newVal].toString());
                _valueSelect=newVal;
              });
            },
            isExpanded: true,
            value: _valueSelect,
          );

        }else {
          return Container(child: Center(child: CircularProgressIndicator(),),);
        }
      },

    );

  }
  _horasDisponiblesEntrega() async {
    String url=await UrlLogin('horasDisponiblesEntrega');
    final response = await http.get(url,headers: {"Accept": "application/json"},);
    print(response.body);
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    }else{
      return false;
    }
  }
}