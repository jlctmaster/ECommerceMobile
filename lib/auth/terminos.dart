import 'package:biomercados/config.dart';
import 'package:biomercados/funciones_generales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
class Terminos extends StatelessWidget {
  final ValueChanged<Map> onChanged;
  const Terminos({ Key key, this.onChanged }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: btnAtras3(context),
        title: Text("Terminos y condiciones de uso",style:TextStyle(color: Color(colorRojo),fontSize: 20,fontWeight: FontWeight.bold))
        ,
    ),

    body:WebviewScaffold(
      url: "$BASE_URL/api_rapida.php?evento=getPage&page_id=1",

      withZoom: true,
      withLocalStorage: true,
      hidden: true,
      initialChild: Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    ),

    );


  }
}