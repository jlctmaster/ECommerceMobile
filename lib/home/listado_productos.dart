import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '/widget/add_carrito.dart';

import '../modelo.dart';
import 'package:flutter/material.dart';
import '../funciones_generales.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../home/rating.dart';
import '../modelo/products.dart';
import '../config.dart';
class ListadoProductos extends StatefulWidget {
final String tipoListado;
final Future listadoProductos;
  const ListadoProductos({Key key, this.tipoListado, this.listadoProductos}) : super(key: key);
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
    if(widget.listadoProductos!=null){
      print("ENTRO A LISTADO");
      _getTaskAsync =widget.listadoProductos;
    }else{
      _getTaskAsync = ModeloTime().listarProductosNuevo(widget.tipoListado);
    }
    
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
                    print("entro caja de productos nuevar");
                    return cajaProductosNueva(projectSnap.data['data']);

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




  
  cajaProductosNueva(products) {
    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - kToolbarHeight ) / 3;
  //  final double itemWidth = size.width / 2;
    double width=MediaQuery.of(context).size.width;
    print("MEDIA QUERY");
    print(width);
int widthCard= 180;    

int countRow=width~/widthCard;
return GridView.count(
 
  //childAspectRatio: (itemWidth / 220),
  childAspectRatio: (widthCard / 220),
  shrinkWrap: true,
  physics: ClampingScrollPhysics(),
  // Create a grid with 2 columns. If you change the scrollDirection to
  // horizontal, this produces 2 rows.
  crossAxisCount: countRow,
  // Generate 100 widgets that display their index in the List.
  children: List.generate(products.length, (index) {

    return Center(
      child: _productoDeLista(products,index)
      
    );
  }),
);

  }
  cajaProductosNuevaFlexible(products) {
    return new StaggeredGridView.countBuilder(
      padding: EdgeInsets.only(top:10),
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      crossAxisCount: 4,
      itemCount: products.length,
      itemBuilder: (BuildContext context, int index) => _productoDeLista(products,index),
      staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
      
      mainAxisSpacing:33.0,
      crossAxisSpacing: 0.0,
    );
    //final formatCurrency = new NumberFormat("#,##0.00", "en_US");

  }

_productoDeLista(products,index){
      String imagen='';
    if(products[index]['image_web']!=null) {
      imagen = "$BASE_URL/storage/" + products[index]['image_web'];
    }else{
      imagen ="$BASE_URL/storage/" + products[index]['image'];
    }
      //print("ENTRO");
      String imagen_grande=products[index]['image_grande'];

      String name=products[index]['name'];

      String priceDolar=formatDolar.format(double.parse(products[index]['total_precio_dolar']));
      String price=formatBolivar.format(double.parse(products[index]['total_precio'])); 

      String precioDolarSinDescuento=formatDolar.format(double.parse(products[index]['dolar_sin_descuento']));
      String precioBolivarSinDescuento=formatBolivar.format(double.parse(products[index]['bs_sin_descuento']));

      double precioDolar=double.parse(products[index]['total_precio_dolar']);
      double precioBolivar=double.parse(products[index]['total_precio']);



      double rating=double.parse(products[index]['rating']);
      String description_short=products[index]['description_short'];
      int id=int.parse(products[index]['id']);

      String otroId=products[index]['id'];
      String calificado_por_mi=products[index]['calificado_por_mi'];
      int stock=int.parse(products[index]['qty_avaliable']);
      int pedidoMaximo=int.parse(products[index]['qty_max']);
      
      int promocion=int.parse(products[index]['promote'] ?? '0');
     // int descuento=int.parse(products[index]['discount'] ?? '0');

      return Card(

margin: EdgeInsets.zero,
elevation: 0,

        semanticContainer: false,

        child: InkWell(
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
                     
                      child: Stack(     
                        children: <Widget>[
                          Center(child:CachedNetworkImage(
                            width: 140,
                        fit: BoxFit.cover,
                        imageUrl: imagen,
                        placeholder: (context, url) => Center(
                            child: CircularProgressIndicator()
                        ),
                        errorWidget: (context, url, error) => new Icon(Icons.error),
                      )),
                      Container(
                        
                        alignment: Alignment.bottomRight,
                    
                      
                      child: AddCarrito(id: id,stock:stock,pedidoMaximo:pedidoMaximo,priceB: precioBolivar,priceD: precioDolar)
                      ),
                    Padding(padding: EdgeInsets.only(top:130),
                    child: 
                    Container(alignment: Alignment.center,
                    
                    child: promocion==1 ? new Container(
                      width: 70,
                      height: 20,
                      decoration: new BoxDecoration(

                        color: Color(0xffF4901E),
                        borderRadius: new BorderRadius.all(
                          Radius.circular(40.0),
                         
                        )
                      ),
                      child: Center(child: Text('Oferta',style: TextStyle(color: Colors.white),)),
                    ) : Text(''),
                    
                    
                    
                    
                    
                    )
                    
                    
                    ),
                      
                        ],
                      )

                    ),
                    Center(child:Text(name,maxLines: 2,style: TextStyle(fontSize: 13),textAlign: TextAlign.center,)),
                   promocion==1 ? _precioOferta('$precioDolarSinDescuento/$precioBolivarSinDescuento','$priceDolar/$price') :  SizedBox(),
                    _precioNormal('$priceDolar/$price'),
                  
                   
                  ],
                ),

              )

);
              
    
    

    }

    _precioNormal(precio){
      return Center(child:Text(precio, style: TextStyle(color: Color(colorVerde),fontWeight: FontWeight.w700,fontSize: 13)));
    }
    _precioOferta(precio,precioCompararDiferencia){
      if(precio==precioCompararDiferencia){
        return SizedBox();
      }else{
        return  Center(child:
                            Text(precio, style: TextStyle(
                              fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.grey,
                                            decoration: TextDecoration.lineThrough
                                        )),
                            );

            }
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