import 'package:villaspark/widget/add_carrito.dart';

import '../modelo.dart';
import 'package:flutter/material.dart';
import '../funciones_generales.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../home/rating.dart';
import '../modelo/products.dart';
import '../config.dart';
class ListadoProductos extends StatefulWidget {
final String tipoListado;

  const ListadoProductos({Key key, this.tipoListado}) : super(key: key);
  @override
  _productosState createState() => _productosState();
}
class _productosState extends State<ListadoProductos> {
  var evento;
  bool _cargado=false;
bool _botonBusqueda=false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  _capturarRetroceso(){//para actualizar la pagina esta despues que retrocedan de la pagina productos
    //setState(() {

    //});
  print("capturado retroceso");
  }

  Future _getTaskAsync;
  @override
  void initState() {
    _getTaskAsync = ModeloTime().listarProductosNuevo(widget.tipoListado);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    final Products args = ModalRoute.of(context).settings.arguments;
        return FutureBuilder(
          future: _getTaskAsync,
          builder: (context, projectSnap) {
            if (projectSnap.connectionState == ConnectionState.done) {
                try {
                  if (projectSnap.data['success'] == true) {

                      return Container(

                        color: Colors.white,
                        child: GridView.count(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          padding: EdgeInsets.only(
                              top: 8, left: 6, right: 6, bottom: 12),
                          children:  cajaProductos(projectSnap.data['data']),
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

        );


  }




  terminarListarProductos(){

  }

  cajaProductos(products) {

    //final formatCurrency = new NumberFormat("#,##0.00", "en_US");
 return List.generate(products.length, (index) {
   String imagen='';
if(products[index]['image_web']!=null) {
  imagen = "$BASE_URL/storage/" + products[index]['image_web'];
}else{
  imagen ="$BASE_URL/storage/" + products[index]['image'];
}
   print("ENTRO");
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
   
   int promocion=int.parse(products[index]['promocion']);

   return Container(
     color: Colors.white,
     child: Card(
      margin: EdgeInsets.zero,
      elevation: 0,
       clipBehavior: Clip.antiAlias,
color: Colors.white,
       //clipBehavior: Clip.antiAlias,
       child:
           InkWell(
             onTap: () {
               Navigator.pushNamed(
                 context,
                 '/producto',
                 arguments: Products(
                     image:imagen_grande,
                     image_previa:imagen,
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
                     promocion:promocion,
                     evento: ModeloTime().evento

                   // message:'este argumento es extraido de producto.',
                 ),
               ).then((val)=>{_capturarRetroceso()});
             },
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: <Widget>[
                 SizedBox(
                   height: (MediaQuery.of(context).size.width / 2 - 5)-10,
                   //height: 180,
                   width: double.infinity,

                   child: Stack(
                     
                     children: <Widget>[
                      
                       Center(child:CachedNetworkImage(
                   //  color: Colors.white,
                     fit: BoxFit.cover,
                     imageUrl: imagen,
                     placeholder: (context, url) => Center(
                         child: CircularProgressIndicator()
                     ),
                     errorWidget: (context, url, error) => new Icon(Icons.error),
                   )),

/* //BIO INSUPERABLE
                    Padding(padding: EdgeInsets.only(top:100),
                    child: 
                    Container(alignment: Alignment.center,
                    
                    child: promocion==1 ? new Container(
                      width: 120,
                      height: 20,
                      decoration: new BoxDecoration(

                        color: Color(0xffF4901E),
                        borderRadius: new BorderRadius.all(
                          Radius.circular(40.0),
                         
                        )
                      ),
                      child: Center(child: Text('Promoción',style: TextStyle(color: Colors.white),)),
                    ) : Text(''),
                    
                    
                    
                    
                    
                    )
                    
                    
                    ),

*/

Padding(padding: EdgeInsets.only(top:90,right: 0),
                    child: 
                    AddCarrito(id: id,stock:stock,pedidoMaximo:pedidoMaximo)
),



                    
                     ],
                   )

                 ),
                 Padding(
                   padding: const EdgeInsets.only(top: 1.0),
                   child: ListTile(

                     title: Text(
                       name,
                       maxLines: 2,

                       //overflow:  TextOverflow.ellipsis,


                       style: TextStyle(
                         //fontWeight: FontWeight.bold,
                           fontSize: 13
                       ),
                     ),
                     subtitle: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: <Widget>[

                         Padding(
                           padding: const EdgeInsets.only(top: 2.0, bottom: 0),
                           child: Text('$priceDolar/$price', style: TextStyle(
                               color: Color(colorVerde),
                               fontWeight: FontWeight.w700,
                               fontSize: 13
                           )),
                         ),


                         Row(
                           children: <Widget>[
                             Rating(rating: rating,nombre: name,calificado_por_mi: calificado_por_mi,products_id: id),
                            // Expanded(child:
                            // stock<1 ? Text("Agotado",style: TextStyle(color: Colors.red),textAlign: TextAlign.right,) : Text('')
                             //  ,)
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

class CircleButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final IconData iconData;

  const CircleButton({Key key, this.onTap, this.iconData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = 50.0;

    return new InkResponse(
      onTap: onTap,
      child: new Container(
        width: size,
        height: size,
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: new Icon(
          iconData,
          color: Colors.black,
        ),
      ),
    );
  }
}