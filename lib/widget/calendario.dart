import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
 
class Calendario extends StatefulWidget {
  final ValueChanged<String> actualizarFecha;
  Calendario({Key key, this.actualizarFecha}) : super(key: key);
  @override
  _calendarioState createState() => _calendarioState();
}

class _calendarioState extends State<Calendario> {
  final f = new DateFormat('dd-MM-yyyy hh:mm');
  bool primeraVez=true;
 DateTime selectedDate = DateTime.now().subtract(new Duration(days: 3600));
  TextEditingController _controller;
  String fecha;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      locale: Locale('es'),
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1960, 8),
        lastDate: DateTime.now().subtract(new Duration(days: 3590)));
    if (picked != null && picked != selectedDate)
      setState(() {
        primeraVez=false;
        selectedDate = picked;
        widget.actualizarFecha(selectedDate.toLocal().toString().split(' ')[0]);
      });
  }




  @override
  Widget build(BuildContext context) {
   fecha=f.format(selectedDate.toLocal()).split(' ')[0];
   _controller = new TextEditingController(text: primeraVez ? '' : fecha);
    return _campoFecha();
  }
  _campoFecha(){
    Padding(
      padding: EdgeInsets.only(top:10),
      child:Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          //Text("Fecha de nacimiento:",style: TextStyle(color: Colors.black54,fontSize: 16),),
          //Text("${selectedDate.toLocal()}".split(' ')[0]),
          TextField(
            readOnly: true,
            onTap: () => _selectDate(context),

            controller: _controller,

            decoration: InputDecoration(
              //hintText: 'Ingrese su nombre y apellido',
              labelText: "Fecha de nacimiento",
            ),
          ),

        ],
      ),
    );
  }
}
