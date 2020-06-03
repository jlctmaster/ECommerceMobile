import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
class RatingOrder extends StatefulWidget {

  String nombre;
  String calificado_por_mi;
  final int orders_id;
  String otroId;
  final ValueChanged<double> onChanged;
  RatingOrder({Key key, this.orders_id, this.onChanged,}) : super(key: key);
  @override
  _ratingOrderState createState() => _ratingOrderState();
}

class _ratingOrderState extends State<RatingOrder> {

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
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _estrellas(),
        ]
        ,);
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
      onRated: (v) {
        rating = v;
        //calificarOrden(context,widget.orders_id);
        setState(() {
          _calificado=true;
          _miRating=v;
          widget.onChanged(v);
        });
      },
      starCount: 5,
      rating: rating,
      size: 35.0,
      color: Colors.amber,
      borderColor: Colors.amber,
      spacing:0.0,
    );
  }
  estrellas(otro){

    return Row(children: <Widget>[SmoothStarRating(
        allowHalfRating: false,
        onRated: (v) {
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



}