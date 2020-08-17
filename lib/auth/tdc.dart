import '../config.dart';
import '../funciones_generales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
class Tdc extends StatelessWidget {
  final int nroOrden;
  final String monto;
  final ValueChanged<Map> onChanged;
  const Tdc({ Key key, this.onChanged, this.nroOrden, this.monto }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: btnAtras3(context),
        title: Text("Realizar pago en TDC",style:TextStyle(color: Color(colorRojo),fontSize: 20,fontWeight: FontWeight.bold))
        ,
    ),

    body: weba(),
    );


  }
  weba(){
    Map cabezera = Map();
    cabezera['orden']=nroOrden.toString();
    String a=double.parse(monto).toStringAsFixed(2);
    return WebviewScaffold(
      url: "$BASE_URL/mega/PreRegistro.php?nro_orden="+nroOrden.toString()+"&total=$a",
withJavascript: true,
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
      ignoreSSLErrors: false,
debuggingEnabled: true,
      initialChild: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.all(20),),
            Text("Esta pagina puede tardar algunos minutos en cargar..."),
            Padding(padding: EdgeInsets.all(50),),
            const Center(
              child: CircularProgressIndicator(),
            ),
          ],
        )
      ),
    );
  }
}