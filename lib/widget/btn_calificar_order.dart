import 'dart:async';
import '../widget/rating_order.dart';
import '../config.dart';
import 'package:flutter/material.dart';

import '../funciones_generales.dart';

class BtnCalificarOrdern extends StatefulWidget {
  final int id;
  final ValueChanged<String> onChanged;
//COLOCAR EL REQUIRED AVERIGUAR EL MOTIVO
  const BtnCalificarOrdern({Key key, this.onChanged, this.id}) : super(key: key);
  @override
  _BtnCalificarOrdernState createState() => _BtnCalificarOrdernState();
}

class _BtnCalificarOrdernState extends State<BtnCalificarOrdern> {
  bool _cargando = false;
  bool _cargandoB = false;
  String opinion;
  bool _calificado = false;
  double v_puntos = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RatingOrder(
          orders_id: widget.id,
          onChanged: _puntos,
        ),
        Padding(
          padding: EdgeInsets.only(top: 15),
        ),
        Text(
          "Elije una estrella y escríbenos tu experiencia.",
          style: TextStyle(color: Color(colorVerde), fontSize: 17),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Card(
              color: Colors.white70,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    opinion = value;
                  },
                  autofocus: true,
                  maxLines: 8,
                  decoration: InputDecoration.collapsed(hintText: "Ingresa tu opinión aquí"),
                ),
              )),
        ),
        Center(
          child: Container(
              width: 270,
              child: Row(
                children: <Widget>[
                  ElevatedButton(
                    child: _cargandoB ? CircularProgressIndicator() : Text("Solicitar devolución"),
                    onPressed: () async {
                      setState(() {
                        _cargandoB = true;
                      });

                      if (await devolucion()) {
                        _calificado = true;
                      }
                      setState(() {
                        _cargandoB = false;
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(7),
                  ),
                  ElevatedButton(
                    child: _cargando ? CircularProgressIndicator() : Text("Guardar"),
                    onPressed: () async {
                      if (v_puntos == 0) {
                        msj("Debe elegir una estrella");
                      } else if (opinion == null) {
                        msj("Escríbenos tu experiencia.");
                      } else {
                        setState(() {
                          _cargando = true;
                        });

                        if (await guardarOpinion()) {
                          _calificado = true;
                        }
                        setState(() {
                          _cargando = false;
                        });
                      }
                    },
                  )
                ],
              )),
        )
      ],
    );
  }

  Future devolucion() async {
    String url;
    String datos = 'devolucion&orders_id=' + widget.id.toString();
    url = await UrlLogin(datos);
    Map res = await peticionGet(url);
    if (res['success'] == true) {
      msj(res['msj_general']);
      Navigator.pop(context);
      return true;
    } else {
      msj(res['msj_general']);
    }
  }

  Future guardarOpinion() async {
    String url;
    String datos = 'guardarOpinionOrden&user_rating=' + v_puntos.toString() + '&opinion=' + opinion + '&orders_id=' + widget.id.toString();
    print(datos);
    url = await UrlLogin(datos);
    Map res = await peticionGet(url);
    if (res['success'] == true) {
      msj(res['msj_general']);
      Navigator.pop(context);
      return true;
    } else {
      msj(res['msj_general']);
    }
  }

  _puntos(v) {
    v_puntos = v;
  }
}
