import 'dart:convert';

import 'package:biomercados/config.dart';
import 'package:biomercados/enviar_pago.dart';
import 'package:biomercados/funciones_generales.dart';
import 'package:biomercados/home/orden.dart';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
class ReportarPago extends StatefulWidget{
final int payment_methods_id;
final int nroOrden;

  const ReportarPago({Key key, this.payment_methods_id,this.nroOrden}) : super(key: key);
  @override
  _reportarPagoState createState() => _reportarPagoState();
}

class _reportarPagoState extends State<ReportarPago> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Realizar pago"),),
      body:  Container(child: Column(
        children: <Widget>[
          Padding(padding:EdgeInsets.all(15),child: subTituloLogin("Elije una opción"),),
          FutureBuilder(
            future: _listarMetodosDePago(),
            builder: (context, res) {
              if (res.connectionState == ConnectionState.done) {
                return _metodosDePago(res.data);
              }else {
                return Center(child: CircularProgressIndicator(),);
              }
            },
          ),
          Padding(padding: EdgeInsets.only(bottom:10),),
          // _botonPagar(),

        ],
      ),),
    );

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
    }else if(widget.payment_methods_id==0){
      return Padding(padding:EdgeInsets.all(20), child: Text(
        "Efectivo.",
        style: TextStyle(fontSize: 20,),
        textAlign: TextAlign.justify,
      ),);

    }else{
      return Padding(padding:EdgeInsets.all(20), child: Text(
        "Disculpe en este momento no tenemos cuentas disponibles en este metodo de pago, lo invitamos a seleccionar otro.",
        style: TextStyle(fontSize: 20,),
        textAlign: TextAlign.justify,
      ),);
    }
  }
  _bloqueMetodosDePago(cuenta){
    //  String _imagen=BASE_URL_IMAGEN+metodo['image'] ?? BASE_URL_IMAGEN+"payment-methods/February2020/zOUo6uzCnFkmXPcnne7Z-small.png";
    return ListTile(
      //  leading: Container(child: Image.network(_imagen,height: 30,),width: 100,),
      title: Text(
        cuenta['b_name'],
        style: TextStyle(fontWeight: FontWeight.bold),
      ),

      subtitle:Container(
          child: Text(cuenta['c_name'])
      ),

      trailing: Icon(Icons.navigate_next),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => EnviarPago(payment_methods_id:widget.payment_methods_id,id: int.parse(cuenta['id']),titular: cuenta['titular'],description: cuenta['description'],moneda: cuenta['c_name'],nombreBanco: cuenta['b_name'],coins_id: cuenta['coins_id'],nroOrden: widget.nroOrden,rate: double.parse(cuenta['rate']),),
        ),);

      },
    );
  }
  _listarMetodosDePago() async {
    int payment_methods_id=widget.payment_methods_id;
    String urlb=await UrlLogin('listarBancosdelMetododePago&payment_methods_id=$payment_methods_id');
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
