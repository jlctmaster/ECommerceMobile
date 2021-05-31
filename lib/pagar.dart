import 'funciones_generales.dart';
import 'modelo.dart';
import 'reportar_pago.dart';
import 'widget/modal_pagos.dart';
import 'package:flutter/material.dart';
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
        future: ModeloTime().listarMetodosDePago(),
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
          Text("Disculpe, no hay metodos de pagos disponibles para su orden, su estatus actual es:\n",textAlign: TextAlign.center,style: TextStyle(fontSize: 20),),
          Text(widget.textoStatus, style: TextStyle(fontSize: 20,color:colorStatus(widget.ordenStatus.toString()),),)

        ],),);
        break;
    }
  }

  _metodosDePago(data){
    print(data);
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
        /*showDialog(
          context: context,
          builder: (_) =>ModalPagos(value:metodo['id'],context: context,onChanged: ir,),

        );*/
        ir(metodo['id']);
      //  return ModalPagos();


      },
    );
  }
  ir(id){
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => ReportarPago(payment_methods_id: int.parse(id),nroOrden: widget.nroOrden,),
    ),);
  }
  setSelectedRadioMetodoPago(int val) {
    setOtroCarrito('metodoPago', val.toString());
    setState(() {

      selectedRadioMetodoPago = val;
    });
  }

}