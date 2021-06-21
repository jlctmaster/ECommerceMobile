import 'dart:convert';

import '../config.dart';
import '../funciones_generales.dart';
import '../pagar.dart';
import '../tracking.dart';
import '../widget/btn_calificar_order.dart';
import '../widget/rating_order.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:Pide/pide_icons.dart';
class Orden extends StatefulWidget{
  final String id;
  final int ordenStatus;
  final String textoStatus;
  final int vistaInicial;

  const Orden({Key key, this.id, this.ordenStatus, this.textoStatus,this.vistaInicial}) : super(key: key);

  @override
  _OrdenState createState() => _OrdenState();
}

class _OrdenState extends State<Orden> {
  String _totalDolaresConFormato='0.00';
  String _totalBolivaresConFormato='0.00';
  Map _totalProductoD = Map();
  Map _totalProductoB = Map();
  Map _totalProductoDConFormato = Map();
  Map _totalProductoBConFormato = Map();
bool _cargando=false;
  String exentoB="";
  String biB="";
  String sub_total_productosB="";
  String total_transportsB="";
  String subTotalB="";
  String totalTaxB="";
String opinion="";
  String exentoD="";
  String biD="";
  String sub_total_productosD="";
  String total_transportsD="";
  String subTotalD="";
  String totalTaxD="";
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: widget.vistaInicial ?? 0,
        length: 3,
        child:  Scaffold(
        appBar: AppBarBio(context,"Orden Nro."+widget.id),
        body:TabBarView(
          children: [
            new Container(child: Column(children: <Widget>[

              
             // Divider(),
              Flexible(
                child: FutureBuilder(
                  future: _getOrden(widget.id),
                  builder: (context, res) {
                    if (res.connectionState == ConnectionState.done) {
                      if(res.data==1){
                        return SingleChildScrollView(child:
                        Column(
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(top: 15),),
                            Text("Felicidades su orden ha sido entregada",style: TextStyle(color: Color(colorVerde),fontSize: 20),),
                          //  Icon(Pide.check_circle,size: 50,color: Color(colorVerdeb),),
                            Padding(padding: EdgeInsets.only(top: 15),),




                            BtnCalificarOrdern(id: int.parse(widget.id),),

                          ],
                        )
                          ,);
                      }else {
                        return _orden(res.data);
                      }
                    }else {
                      return Center(child: CircularProgressIndicator(),);
                    }
                  },
                ),
              )

            ],),),//Metodos de pago
            new Pagar(nroOrden: int.parse(widget.id),ordenStatus: widget.ordenStatus,textoStatus: widget.textoStatus,),
            new Tracking(nroOrden: int.parse(widget.id),)
          ],
        ),
        //backgroundColor: Colors.red,
        bottomNavigationBar:  Container(padding: EdgeInsets.only(top:8),color: Color(colorVerde),child: TabBar(
labelStyle: TextStyle(fontSize: 14),
          indicatorColor: Color(colorAmarillo),
          labelColor: Colors.white,

          tabs: [
            Tab(child: Column(children: <Widget>[Icon(Pide.shopping_cart),Text("Orden",)],),),
            Tab(child: Column(children: <Widget>[Icon(Pide.payment),Text("Pagar",)],),),
            Tab(child: Column(children: <Widget>[Icon(Pide.call_split),Text("Tracking",)],),),
           // Tab(icon: Icon(Pide.),child: Text("Pagar",),),
           // Tab(icon: Icon(Pide.call_split),child: Text("Tracking",),),
          ],
        ),),
    ),);
  }

  _getOrden(id) async {
    List res;
    double totalD=0.00;
    double totalB=0.00;
    double _rate=1.00;
    String url=await UrlLogin('consultarOrden&id=$id');

    Map resa= await peticionGet(url);
    Map resb= resa['data'][0];

    if (resa['success']==true) {
     // msj(resb['opinion']);
      if(widget.ordenStatus==8 && (resb['opinion']==null || resb['opinion']=='')){
        return 1;
      }else {
        res = jsonDecode(resb['productos']);
        List rate = jsonDecode(resb['rate_json']);
        for (int i = 0; i < rate.length; i++) {
          //msj(rate[i]['id']);
          int id_rate = int.parse(rate[i]['id']);
          _rate = double.parse(rate[i]['rate']);
          if (id_rate == 2) break;
        }

        for (var i = 0; i < res.length; i++) {
          print(res[i]['price']);
          _totalProductoD[i] =(res[i]['price'] * res[i]['cant']);
          _totalProductoDConFormato[i] = formatDolar.format(_totalProductoD[i]);
          totalD += _totalProductoD[i];


          _totalProductoB[i] =  _totalProductoD[i]* _rate;
          _totalProductoBConFormato[i] = formatBolivar.format(_totalProductoB[i]);
          totalB += _totalProductoB[i];



        }
        _totalDolaresConFormato =
            formatDolar.format(double.parse(resb['total_pay']));
        _totalBolivaresConFormato =
            formatBolivar.format(double.parse(resb['total_pay'])*_rate);

        exentoB = formatBolivar.format(double.parse(resb['exento']) * _rate);
        biB = formatBolivar.format(double.parse(resb['bi'])*_rate);
        sub_total_productosB =
            formatBolivar.format(double.parse(resb['sub_total'])*_rate);
        total_transportsB =
            formatBolivar.format(double.parse(resb['total_transport'])* _rate);
        subTotalB = formatBolivar.format((double.parse(resb['sub_total']) +
            double.parse(resb['total_transport']))* _rate);
        totalTaxB = formatBolivar.format(double.parse(resb['total_tax'])*_rate);

        exentoD = formatDolar.format(double.parse(resb['exento']));
        biD = formatDolar.format(double.parse(resb['bi']));
        sub_total_productosD =
            formatDolar.format(double.parse(resb['sub_total']) );
        total_transportsD =
            formatDolar.format(double.parse(resb['total_transport']));
        subTotalD = formatDolar.format((double.parse(resb['sub_total']) +
            double.parse(resb['total_transport'])) );
        totalTaxD = formatDolar.format(double.parse(resb['total_tax']));
        return resb;
      }
    }else{
      msj(resa['msj_general']);
    }
  }
  _orden(data){
      String os_id = data['orders_status_id'];
      List products = jsonDecode(data['productos']);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 15, bottom: 5),
                  child: subTituloLogin("Datos de su orden"),),
                Text("A nombre de: " + data['nombre_usuario']),
                Text("Fecha de solicitud: " + data['fecha']),
                Text("Fecha estimada de entrega: " + data['fecha_entrega']),
                Row(
                  children: <Widget>[
                    Text("Estatus: "),
                    Text(data['status_tracking'],
                      style: TextStyle(color: colorStatus(os_id)),),
                  ],
                ),
                Text("Dirección de entrega: " +
                    (data['address'] ?? "Retirar en tienda PIDE")),
              ],
            ),
          )
          ,


          Flexible(
              child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.blue
                            ),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: _mostrarImagen(
                                  products[index]['image']),
                              // placeholder: (context, url) => Center(
                              //    child: CircularProgressIndicator()
                              // ),
                              errorWidget: (context, url, error) =>
                              new Icon(Pide.error),
                            ),
                          ),
                        ),
                        title: Text(
                          products[index]['name'],
                          style: TextStyle(
                              fontSize: 14
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 2.0, bottom: 1),
                                  child: Text(
                                      'X ' + products[index]['cant'].toString(),
                                      style: TextStyle(
                                        color: Color(colorRojo),
                                        fontWeight: FontWeight.w700,
                                      )),
                                )
                              ],
                            )
                          ],
                        ),
                        trailing: Text(_totalProductoDConFormato[index] + "/" +
                            _totalProductoBConFormato[index]),
                      ),
                      //child: _bloqueDireccion(data[index],data,index),
                    );
                  }
              )
          ),

          Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Column(
                  children: <Widget>[
                    totales("Productos:",
                        "$sub_total_productosD / $sub_total_productosB"),
                    totales(
                        "Envio:", "$total_transportsD / $total_transportsB"),
                    totales("Sub total:", "$subTotalD / $subTotalB"),
                    totales("Exento:", "$exentoD / $exentoB"),
                    totales("BI:", "$biD / $biB"),
                    totales("Impuestos:", "$totalTaxD / $totalTaxB"),


                    Divider(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0, top: 0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: Text("Total a pagar: ", style: TextStyle(
                                fontSize: 16,),)
                          ),
                          Text(
                              "$_totalDolaresConFormato / $_totalBolivaresConFormato",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),


                  ],
                ),
              )
          ),


        ],
      );

  }
totales(name,value){
  return Row(
    children: <Widget>[
      Expanded(
          child: Text(name, style: TextStyle(fontSize: 14,),)
      ),
      Text(value,  style: TextStyle(fontSize: 17)),
    ],
  );
}
  void _repetirPedido() {
    msj("repetido");
  }

  _mostrarImagen(product) {
    if (product != null) {
      return BASE_URL_IMAGEN+rUrl(jsonDecode(product)[0]);
    }else{
      return BASE_URL_IMAGEN+"/products/imagenNoDisponible.png";
    }
  }
}