import 'package:flutter/material.dart';
import 'package:biomercados/config.dart';
import 'package:biomercados/funciones_generales.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class Rating extends StatefulWidget {
  double rating;

  String nombre;
  String calificado_por_mi;
  int products_id;
  String otroId;

  Rating({Key key, this.rating,this.nombre,this.calificado_por_mi,this.products_id}) : super(key: key);
  @override
  _ratingState createState() => _ratingState();
}

class _ratingState extends State<Rating> {

  bool inicial=true;
  double rating=0.00;
  double ratingNuevo=0.00;
  double _miRating=0.00;
  String opinion;
  Map res;
  bool _cargando=false;
  bool _calificado=false; //para cambiar el calificado en tiempo real con setStatus sin consultar al servidor

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    if(_calificado==false) {
      _miRating = double.parse(widget.calificado_por_mi);
    }
    final String produ=widget.products_id.toString();
  return Column(crossAxisAlignment: CrossAxisAlignment.start,children: (double.parse(widget.calificado_por_mi)>0 || _calificado==true) ? [_estrellas()] : [_estrellas()],);
  }

  _misEstrellas(){
    return SmoothStarRating(
      allowHalfRating: false,

      starCount: 5,
      rating: _miRating,
      size: 12.0,
      color: Colors.amber,
      borderColor: Colors.amber,
      spacing:0.0,
    );
  }
  _estrellas(){
    return SmoothStarRating(
      allowHalfRating: false,
      onRatingChanged: (v) {
        rating = v;
        calificarProducto(context,widget.products_id);
        setState(() {
          _calificado=true;
          _miRating=v;
        });
      },
      starCount: 5,
      rating: widget.rating,
      size: 17.0,
      color: Colors.amber,
      borderColor: Colors.amber,
      spacing:0.0,
    );
  }
  estrellas(otro){

    return Row(children: <Widget>[SmoothStarRating(
        allowHalfRating: false,
        onRatingChanged: (v) {
          setState(() {
            _miRating=v;
          });
        },
        starCount: 5,
        rating: rating,
        size: 17.0,
        color: Colors.amber,
        borderColor: Colors.amber,
        spacing:0.0
    )],);
  }
  calificarProducto(context,products_id){
    //print("AQUI $products_id"+widget.products_id.toString());
    guardarCalificacion(products_id);
    showDialog(
        context: context,
        builder: (_) =>
        new AlertDialog(
          title:   Column(children: <Widget>[Text("Gracias por calificar a: "+widget.nombre),estrellas(rating)],),
          content: Form(
            key: _formKey,
            child: TextFormField(
              validator: (value) {
                return validar('todo',value,true);
              },
              onSaved: (value) {
                setState(() {
                  print("procesado: $value");
                  opinion= value;
                });
              },
              decoration: InputDecoration(
                //hintText: 'Dejanos tu comentario sobre este producto:',
               labelText: 'Comenta este producto:',
              ),
            ),
          ),
          actions: <Widget>[
            new FlatButton(onPressed: () {
              Navigator.pop(context);
            }, child: new Text('Cancelar')),
            new FlatButton(onPressed: () async {
              print("Calificado");
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                guardarOpinion();
                Navigator.pop(context);
              }



            }, child: _cargando ?  CircularProgressIndicator() : Text('Ok')),
          ],
        )
    );
  }
  Future guardarOpinion() async {
    String url;
    String datos='guardarOpinion&opinion=$opinion&products_id='+widget.products_id.toString();
    url=await UrlLogin(datos);
    final response = await http.get(url,headers: {"Accept": "application/json"},);
    if (response.statusCode == 200) {
      msj(res['msj_general']);
    }else{
      msj(res['msj_general']);
    }
  }
  Future<Map> guardarCalificacion(int products_id) async {
    print(products_id);
    String url;
    String datos='guardarCalificacion&products_id='+widget.products_id.toString()+'&rating='+rating.round().toString();
    url=await UrlLogin(datos);
    final response = await http.get(url,
        headers: {"Accept": "application/json"},);
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
     // setState(() {
        //widget.calificado_por_mi='1';
     // });
      res= jsonDecode(response.body);
      if(res['success']==true){
        //msj(res['msj_general']);
      }else{
        msj(res['msj_general']);
      }
    } else {
      res= jsonDecode(response.body);
    }
  }
}

