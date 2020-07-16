import 'package:biomercados/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'funciones_generales.dart';

class Biowallet extends StatefulWidget {
  @override
  _BiowalletState createState() => _BiowalletState();
}

class _BiowalletState extends State<Biowallet> {
  final _formKey = GlobalKey<FormState>();
  var _data;
  bool loading=false;

    Future getSaldo() async {
    var url=await UrlLogin('saldo');
    Map datos = await peticionGet(url);
    print(datos);
    if(datos['success']==true){
      return datos['data'][0]['saldo'];
    }else{
      return '0.00';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarBio(context, 'bio wallet'),

        body: SafeArea(
          child: 
              Padding(
                padding: const EdgeInsets.only(left: 20.0,right: 20.00,bottom: 100),
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
               Center(child: Container(
  
        child:Text("Saldo disponible",textAlign: TextAlign.center,style: TextStyle(color: Color(0xff28b67a), fontSize: 25.00))
    ),),
                   Padding(padding: EdgeInsets.only(bottom: 15),),
                  FutureBuilder(
                  future: getSaldo(),
                  builder: (context, res) {
                    if (res.connectionState == ConnectionState.done) {
                      
                      return Text(formatDolar.format(double.parse(res.data)),style: TextStyle(fontSize: 60),);
                      
                    }else {
                      return Center(child: CircularProgressIndicator(),);
                    }
                  },
                ),

                    
                   
                  ],
                ),
              )



            
         
        )
    );
  }
 
}