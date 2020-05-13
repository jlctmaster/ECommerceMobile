import 'dart:convert';
import 'package:biomercados/blocks/auth_block.dart';
import 'package:biomercados/modelo/combos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:biomercados/config.dart';
import 'package:biomercados/funciones_generales.dart';
import 'package:biomercados/home/galeria.dart';
import 'package:provider/provider.dart';
class Combo extends StatefulWidget {
  @override
  _ComboState createState() => _ComboState();
}
class _ComboState extends State<Combo>{
  bool mayor=true;
  var msj_mayor;

  @override
  Widget build(BuildContext context) {
    final proveedor = Provider.of<AuthBlock>(context);
    final Combos args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: titleBio('Detalles del producto'),
        leading: leadingBio(context),
        backgroundColor: colorAppBarBio(),
        actions: <Widget>[

          iconoCarrito(context,true),
        ],
      ),
      body: SafeArea(
        top: false,
        left: false,
        right: false,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                height: 260,
                child:
                     Galeria(galleryItems:json.decode(args.image),imagenPrevia: args.imagenPrevia,),



              ),



              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment(-1.0, -1.0),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        child: Text(
                          args.name,
                          style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Text(
                                  args.precio,
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),

                            ],
                          ),



                                      FlatButton(
                                          child: Row(
                  children: <Widget>[

                    Text(
                      'Agregar ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),

                    ), Icon(Icons.add_circle)
                ],
              ),
                            onPressed: () async {
                              await agregarAlCarrito(args.json,proveedor);
                            }
                                      ),


                        ],
                      ),
                    ),
                    Divider(),
                    Column(
                      children: <Widget>[
                        Container(
                            alignment: Alignment(-1.0, -1.0),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                'Descripción',
                                style: TextStyle(color: Colors.black, fontSize: 20,  fontWeight: FontWeight.w600),
                              ),
                            )
                        ),

                        Container(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),

                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  // Let the ListView know how many items it needs to build.
                                  itemCount: args.json.length,
                                  // Provide a builder function. This is where the magic happens.
                                  // Convert each item into a widget based on the type of item it is.
                                  itemBuilder: (context, index) {
                                    final item = args.json[index];
return Row(
  children: <Widget>[
    Text(item['cant'].toString(),style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 16),),
    Text(" x "+item['name'],style: TextStyle(fontSize: 16 ),)
  ],
);


                                      //subtitle: item.buildSubtitle(context),

                                  },
                                ),










                            )
                        ),Container(
                            alignment: Alignment(-1.0, -1.0),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Text(
                               '',
                                style: TextStyle(color: Colors.black54, fontSize: 16),
                              ),
                            )
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),

      ),
    );
  }

  agregarAlCarrito(List pro,proveedor) async{
    Map carrito= Map();
    carrito= await jsonDecode(await storage.getItem('carrito'));


    pro.forEach((e) async {
      int idProducto=e['products_id'];
      int cant=e['cant'];
      if(carrito['productos']==null){
        Map productos= Map();
        productos["$idProducto"]=cant;
        carrito['productos']=productos;
      }else{
        Map productos =carrito['productos'];
        productos["$idProducto"]=cant;
        carrito['productos']=productos;
      }
    });
    await storage.setItem('carrito',jsonEncode(carrito));
    proveedor.actualizar();
    msj("Agregado al carrito.");

  }

  mayorDeEdad(int products_id) async {
    Map res=Map();
    res=await getData('Combos_mayor');

   // String datos='mayorDeEdad&products_id='+products_id.toString();
   // url=await UrlLogin(datos);
    //res= await peticionGet(url);
      print("MAYOR");
      print(res);
    if(res['data'][products_id.toString()]==true){
      mayor= false;
      msj_mayor=res['msj_general'];

    }else{
      mayor= true;
    }

  }


}
