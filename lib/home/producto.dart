import 'dart:convert';

import 'package:biomercados/widget/cant_carritob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:biomercados/config.dart';
import 'package:biomercados/funciones_generales.dart';
import 'package:biomercados/home/agregarProducto.dart';
import 'package:biomercados/home/galeria.dart';
import 'package:biomercados/home/rating.dart';
import 'package:biomercados/modelo/products.dart';

import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:biomercados/modelo/favorites.dart';
import 'package:http/http.dart' as http;
class Producto extends StatefulWidget {
  @override
  _productoState createState() => _productoState();
}
class _productoState extends State<Producto> {
  bool _status_favorite=false;
  Favorites objFavorites = Favorites();

  bool mayor=true;

  var msj_mayor;

  @override
  Widget build(BuildContext context) {
    final Products args = ModalRoute.of(context).settings.arguments;
    guardarVisitaProducto(args.id);
    if(_status_favorite==false) {
      consultarFavorito(args.id);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del producto'),

        actions: <Widget>[

          IconButton(
            icon:btnCarritob(),
            onPressed: (){
              Navigator.pushNamed(context, '/cart');
            },
        )
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
                child: Stack(
                    alignment: Alignment.bottomRight,
                    children: <Widget>[
                      Galeria(galleryItems:json.decode(args.image)),
                     /*
                      Center(
                        child:PhotoView(
                            backgroundDecoration: BoxDecoration(color: Colors.white),
                            imageProvider: CachedNetworkImageProvider(
                                    args.image,
                              ),
                            loadingBuilder: (context, _progress) => Center(
                                          child: Container(
                                            width: 20.0,
                                            height: 20.0,
                                            child: CircularProgressIndicator(
                                              value: _progress == null
                                                  ? null
                                                  : _progress.cumulativeBytesLoaded /
                                                      _progress.expectedTotalBytes,
                                            ),
                                          ),
                                        ),

                        )),*/
                      Padding(
                          padding: EdgeInsets.only(right: 40),
                          child: FloatingActionButton(
                                mini: true,

                                child: Icon(Icons.favorite,color: _status_favorite==false ? Colors.grey : Colors.red,) ,
                                backgroundColor: Colors.white,
                                onPressed: () {
                                  guardarFavorito(args.id);
                                },
                              )

                      ),
                    ]
                ),
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
                          Row(
                            children: <Widget>[
                              Rating(rating: args.rating,nombre: args.name,calificado_por_mi: args.calificado_por_mi,products_id: args.id,),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                    '',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    )
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    FutureBuilder(
                        future: mayorDeEdad(args.id),
                        builder: (context, projectSnap) {
                          return mayor ? AgregarProducto(precioBolivar: args.precioBolivar,precioDolar: args.precioDolar,id:args.id,stock: args.stock,pedidoMax:args.pedidoMax) : Text(msj_mayor,style: TextStyle(color:Colors.red),);

                    }),

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
                            alignment: Alignment(-1.0, -1.0),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Text(
                               args.description_short,
                                style: TextStyle(color: Colors.black54, fontSize: 17),
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
  void guardarFavorito(int products_id) async {

    objFavorites.products_id=products_id;
    objFavorites.guardar();
    setState(() {
      if(_status_favorite){
        _status_favorite = false;
      }else {
        msj("Agregado a favoritos.");
        _status_favorite = true;
      }
    });
    return;
  }
void consultarFavorito(int products_id) async {
    objFavorites.products_id=products_id;
    await objFavorites.consultar();
    if(objFavorites.res['success']==true){
      setState(() {
        _status_favorite=true;
      });
    }
    return;
  }
  guardarVisitaProducto(int products_id) async {
    String url;
    String datos='guardarVisitaProducto&products_id='+products_id.toString();
    url=await UrlLogin(datos);
    final response = await http.get(url,headers: {"Accept": "application/json"},);
    print(response.body);
    print(response.statusCode);
  }
  mayorDeEdad(int products_id) async {
    String url;
    Map res=Map();
    String datos='mayorDeEdad&products_id='+products_id.toString();
    url=await UrlLogin(datos);
    res= await peticionGet(url);


    if(res['success']==true){
      mayor= true;
    }else{
      mayor= false;
      msj_mayor=res['msj_general'];
    }

  }

}
