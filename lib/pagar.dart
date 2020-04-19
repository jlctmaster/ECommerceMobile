import 'dart:convert';

import 'package:biomercados/config.dart';
import 'package:biomercados/funciones_generales.dart';
import 'package:biomercados/reportar_pago.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class Pagar extends StatefulWidget {
  final int nroOrden;
  final int ordenStatus;
  final String textoStatus;

  const Pagar({Key key, this.nroOrden, this.ordenStatus, this.textoStatus}) : super(key: key);
  @override
  _pagar createState() => _pagar();
}

class _pagar extends State<Pagar>{
  int selectedRadio;
  int selectedRadioMetodoPago;
  @override
  Widget build(BuildContext context) {
    return new Container(child: Column(
                children: <Widget>[
    Padding(padding:EdgeInsets.all(15),child: subTituloLogin("Elije un metodo de pago"),),
                  body(),
                  Padding(padding: EdgeInsets.only(bottom:10),),
                  // _botonPagar(),

                ],
              ),);
  }
  body(){

    switch(widget.ordenStatus){

      case 1: return FutureBuilder(
        future: _listarMetodosDePago(),
        builder: (context, res) {
          if (res.connectionState == ConnectionState.done) {
            return _metodosDePago(res.data);
          }else {
            return Center(child: CircularProgressIndicator(),);
          }
        },
      );
      default:
        return Padding(padding:EdgeInsets.all(20),child: Column(children: <Widget>[
          Text("Disculpe, no hay metodos de pagos disponibles para su orden, debido a su estatus",textAlign: TextAlign.center,style: TextStyle(fontSize: 20),),
          Text(widget.textoStatus, style: TextStyle(fontSize: 20,color:colorStatus(widget.ordenStatus.toString()),),)

        ],),);
        break;
    }
  }

  _metodosDePago(data){
    if(data!=null) {
      return Flexible(
        child: ListView.builder(
          //physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int index) {

            return Card(
              child: _bloqueMetodosDePago(data[index]),
            );
          },
          padding:EdgeInsets.only(bottom: 20.0),
        ),
      );
    }else {
      return Text(
        "En este momento no hay metodos de pagos disponibles, intente mas tarde.",
        style: TextStyle(fontSize: 20,),
        textAlign: TextAlign.justify,
      );
    }
  }
  _bloqueMetodosDePago(metodo){
  //  String _imagen=BASE_URL_IMAGEN+metodo['image'] ?? BASE_URL_IMAGEN+"payment-methods/February2020/zOUo6uzCnFkmXPcnne7Z-small.png";
    return ListTile(
    //  leading: Container(child: Image.network(_imagen,height: 30,),width: 100,),
      title: Text(
        metodo['name'],
        style: TextStyle(fontWeight: FontWeight.bold),
      ),

      subtitle:Container(
          child: Text(metodo['description'])
      ),

      trailing: Icon(Icons.navigate_next),
      onTap: (){
        //msj(widget.nroOrden.toString());
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ReportarPago(payment_methods_id: int.parse(metodo['id']),nroOrden: widget.nroOrden,),
        ),);

      },
    );
  }
  setSelectedRadioMetodoPago(int val) {
    setOtroCarrito('metodoPago', val.toString());
    setState(() {

      selectedRadioMetodoPago = val;
    });
  }
  _listarMetodosDePago() async {
    String urlb=await UrlLogin('listarMetodosDePago');
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