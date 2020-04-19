import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:biomercados/funciones_generales.dart';
import 'package:biomercados/home/producto.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:biomercados/home/rating.dart';
import 'package:biomercados/modelo/products.dart';
import 'package:biomercados/shop/search.dart';
import 'package:intl/intl.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import '../config.dart';
import 'home.dart';
import 'package:http/http.dart' as http;
class Productos extends StatefulWidget {
final String titulo;

  const Productos({Key key, this.titulo}) : super(key: key);
  @override
  _productosState createState() => _productosState();
}
class _productosState extends State<Productos> {
  var evento;
  String titulo;
  bool _cargado=false;
bool _botonBusqueda=false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  _capturarRetroceso()async{//para actualizar la pagina esta despues que retrocedan de la pagina productos
    setState(() {

    });
  print("capturado retroceso");
  }
  @override
  Widget build(BuildContext context) {


    final Products args = ModalRoute.of(context).settings.arguments;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        primary: false,
        key: scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          primary: false,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.remove_red_eye,color: Color(colorVerde),),
              onPressed: () {
                if(_botonBusqueda){
                  _botonBusqueda=false;
                  Navigator.pop(context);
                }else{
                 // Navigator.pop(context);
                  _botonBusqueda=true;
                  scaffoldKey.currentState
                      .showBottomSheet((context) => ShopSearch(),);
                }


              },
            )
          ],
          title: Text(titulo ?? widget.titulo, style: TextStyle(color: Color(colorVerde)),),
        ),
        body: FutureBuilder(
          future: listarProductos(),
          builder: (context, projectSnap) {
            if (projectSnap.connectionState == ConnectionState.done) {
try {
  if (projectSnap.data['success'] == true) {
    return DefaultTabController(
      length: 2,
      child: Container(
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          padding: EdgeInsets.only(
              top: 8, left: 6, right: 6, bottom: 12),
          children: cajaProductos(projectSnap.data['data']),
        ),
      ),


    );
  } else {
    return Padding(
        padding: EdgeInsets.only(bottom: 50, left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Icon(Icons.do_not_disturb,size: 50,),

            //"Ups, nos hemos encontrado productos que coincidan con tu búsqueda, intenta más tarde."
            Center(child: Text(projectSnap.data['msj_general'],
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(colorRojo),
                  fontSize: 22,
                  fontWeight: FontWeight.bold),),),


            //Text("No hay productos, intente mas tarde.",style: TextStyle(fontSize: 30),)
          ],)
    );
  }
}catch(_){
  return noInternet();
}
            }else {
              return Center(child:CircularProgressIndicator());
            }
          },

        )

      ),
    );
  }

  Future listarProductos() async {
    titulo= await getTitulo();
    if(!_cargado){
      _cargado=true;
      setState(() {

      });
    }
    evento= await getEvento();

    print("LISTO $evento $titulo");
    String url = await UrlLogin(evento);
    final response = await http.get(
        url, headers: {"Accept": "application/json"});
    print(response.body);
    var res=jsonDecode(response.body);
return res;
    if(res['success']==true) {
      return res['data'];
    }else{
      return null;
    }
  }

  cajaProductos(products) {

    //final formatCurrency = new NumberFormat("#,##0.00", "en_US");
 return List.generate(products.length, (index) {
   String imagen="$BASE_URL/storage/"+products[index]['image'];
   String imagen_grande=products[index]['image_grande'];
   String name=products[index]['name'];
   String priceDolar=formatDolar.format(double.parse(products[index]['total_precio_dolar']));
   double precioDolar=double.parse(products[index]['total_precio_dolar']);
   double precioBolivar=double.parse(products[index]['total_precio']);

   String price=formatBolivar.format(double.parse(products[index]['total_precio']));
   double rating=double.parse(products[index]['rating']);
   String description_short=products[index]['description_short'];
   int id=int.parse(products[index]['id']);
   String otroId=products[index]['id'];
   String calificado_por_mi=products[index]['calificado_por_mi'];
   int stock=int.parse(products[index]['qty_avaliable']);
   int pedidoMaximo=int.parse(products[index]['qty_max']);

   return Container(
     child: Card(


       clipBehavior: Clip.antiAlias,
       child: InkWell(
         onTap: () {
           Navigator.pushNamed(
             context,
             '/producto',
             arguments: Products(
               image:imagen_grande,
               name:name,
               precio:priceDolar+"/"+price,
                 precioDolar:precioDolar,
                 precioBolivar:precioBolivar,
                 rating: rating,
                 description_short:description_short,
                 id:id,
               calificado_por_mi:calificado_por_mi,
               stock: stock,
               pedidoMax: pedidoMaximo,
               evento: evento

               // message:'este argumento es extraido de producto.',
             ),
           ).then((val)=>{_capturarRetroceso()});
         },
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: <Widget>[
             SizedBox(
               height: (MediaQuery.of(context).size.width / 2 - 5),
               //height: 180,
               width: double.infinity,

               child: CachedNetworkImage(
                 fit: BoxFit.cover,
                 imageUrl: imagen,
                 placeholder: (context, url) => Center(
                     child: CircularProgressIndicator()
                 ),
                 errorWidget: (context, url, error) => new Icon(Icons.error),
               ),
             ),
             Padding(
               padding: const EdgeInsets.only(top: 5.0),
               child: ListTile(
                 title: Text(
                   name,
                   overflow: TextOverflow.ellipsis,


                   style: TextStyle(
                       //fontWeight: FontWeight.bold,
                       fontSize: 14
                   ),
                 ),
                 subtitle: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: <Widget>[

                         Padding(
                           padding: const EdgeInsets.only(top: 2.0, bottom: 1),
                           child: Text('$priceDolar/$price', style: TextStyle(
                             color: Color(colorVerde),
                             fontWeight: FontWeight.w700,
                               fontSize: 13
                           )),
                         ),


                     Row(
                       children: <Widget>[
                         Rating(rating: rating,nombre: name,calificado_por_mi: calificado_por_mi,products_id: id),

                        // IconButton(icon:Icon(Icons.favorite))

                       ],
                     ),

                   ],
                 ),
               ),
             )
           ],
         ),
       ),
     ),
   );
 });

  }

}