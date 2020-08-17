import '../funciones_generales.dart';
import 'package:flutter/material.dart';
class Recordar extends StatefulWidget {
  final ValueChanged<bool> onChanged;
  final bool tipo;
//COLOCAR EL REQUIRED AVERIGUAR EL MOTIVO
  const Recordar({Key key,@required this.onChanged, this.tipo}) : super(key: key);
  @override
  _RecordarState createState() => _RecordarState();
}

class _RecordarState extends State<Recordar> {
  bool primeraVez=true;
  bool checkedValue=false;


  @override
  Widget build(BuildContext context) {
    if(primeraVez){
      checkedValue=widget.tipo;
      primeraVez=false;

      //widget.onChanged(widget.tipo);
    }

 return Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: <Widget>[

    Checkbox(

      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      activeColor: Colors.green,
      value: checkedValue,
      onChanged: (newValue){

        if(newValue){
          widget.onChanged(true);
          setState(() {
            checkedValue=true;

          });

        }else{
          widget.onChanged(false);
          setState(() {
            checkedValue=false;

          });
        }
      },),
    Text("Recordar contraseña",textAlign: TextAlign.right, style: TextStyle(fontSize:14,fontWeight: FontWeight.bold ,color: Color(colorVerde))),
  ],
);

  }
}