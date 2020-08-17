import '../config.dart';
import '../funciones_generales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
class Faq extends StatelessWidget {
  final ValueChanged<Map> onChanged;
  const Faq({ Key key, this.onChanged }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: btnAtras3(context),
        title: Text("Preguntas frecuentes",style:TextStyle(color: Color(colorRojo),fontSize: 20,fontWeight: FontWeight.bold))
        ,
    ),

    body:WebviewScaffold(
      url: "$BASE_URL/api_rapida.php?evento=getPage&page_id=2",

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