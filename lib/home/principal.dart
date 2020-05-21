import 'dart:convert';
import 'package:biomercados/home/listado_combos.dart';
import 'package:biomercados/home/listado_productos.dart';
import 'package:biomercados/modelo.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:biomercados/funciones_generales.dart';
import 'package:biomercados/home/rating.dart';
import 'package:biomercados/modelo/products.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import 'package:carousel_pro/carousel_pro.dart';
class Principal extends StatefulWidget {
  final ValueChanged<String> actualizarHome;

  const Principal({Key key, this.actualizarHome}) : super(key: key);
  @override
  _principalState createState() => _principalState();
}

class _principalState extends State<Principal> {

  @override
  Widget build(BuildContext context) {
    ModeloTime().verificarSesionN(context);
    return CustomScrollView(
      // Add the app bar and list of items as slivers in the next steps.
        slivers: <Widget>[


          SliverList(
            // Use a delegate to build items as they're scrolled on screen.
            delegate: SliverChildBuilderDelegate(
              // The builder function returns a ListTile with a title that
              // displays the index of the current item.
                  (context, index) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //_tituloConBoton('Categorias','Ver todas','/categorise'),//Titulo antes del scroll
                 // _textoTituloCentrado('Categorias'),
                  Categorias(),// categorias en scroll lateral


                  Padding(padding: EdgeInsets.only(top:5),),

                  _textoTituloCentrado('Mi compra fácil'),
                    ListadoCombos(),
                  listaPublicidad('top'),

                  _textoTituloCentrado('Seguro que te gusta'),
                  ListadoProductos(tipoListado: 'ia',),
                  listaPublicidad('footer'),
                  //_banner('assets/images/banner-2.png'),
                  //_textoTituloCentrado('Ofertas'),
                ],
              ),
              // Builds 1000 ListTiles
              childCount: 1,
            ),
          )
        ]);

  }
  List agregarImagenList(data){
    final List imgList=List();
    String imagen;
    for (var n in data['data']) {
     imagen=(n['image']).replaceAll('\\', '/');
      imgList.add(CachedNetworkImage(imageUrl: BASE_URL_IMAGEN+imagen,));
      print(BASE_URL_IMAGEN+imagen);
    }

    return imgList;
  }
  listaPublicidadFinal(){

    return  SizedBox(
        height: (MediaQuery.of(context).size.width / 2 - 5),
        width: double.infinity,

        child: new FutureBuilder(
          future: ModeloTime().listarPublicidad('footer'), // async work
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting: return Center(child:CircularProgressIndicator());
              default:
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                else{
                  if(snapshot.data['data']==null){
                    return Text("");
                  }else {
                    return Carousel(
                      boxFit: BoxFit.cover,
                      autoplay: true,
                      animationCurve: Curves.fastOutSlowIn,
                      //animationDuration: Duration(milliseconds: 4000),
                      autoplayDuration: Duration(milliseconds: 4000),
                      dotSize: 6.0,
                      dotIncreasedColor: Color(0xFFFF335C),
                      dotBgColor: Colors.transparent,
                      //dotPosition: DotPosition.topRight,
                      dotVerticalPadding: 10.0,
                      showIndicator: false,
                      indicatorBgPadding: 7.0,
                      images: agregarImagenList(snapshot.data),
                    );
                  }
                  // return snapshot.data['data'];
                }
                //return new Text(snapshot.data[0]['name']);
            }
          },
        )
    );
  }
  listaPublicidad(tipo){

    return  SizedBox(
        height: (MediaQuery.of(context).size.width* 0.3),
        width: double.infinity,
        //width: MediaQuery.of(context).size.width,
        child: new FutureBuilder(
          future: ModeloTime().listarPublicidad(tipo), // async work
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting: return Center(child:CircularProgressIndicator());
              default:
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                else{

                  return Carousel(
                    boxFit: BoxFit.cover,
                    autoplay: true,
                    animationCurve: Curves.fastOutSlowIn,
                    //animationDuration: Duration(milliseconds: 4000),
                    autoplayDuration: Duration(milliseconds: 10000),
                    dotSize: 6.0,
                    dotIncreasedColor: Color(0xFFFF335C),
                    dotBgColor: Colors.transparent,
                    dotPosition: DotPosition.bottomRight,
                    dotVerticalPadding: 10.0,
                  //  overlayShadowColors: Colors.white,
                    showIndicator: true,
                    indicatorBgPadding: 7.0,
                    images: agregarImagenList(snapshot.data),
                  );
                  // return snapshot.data['data'];
                }
            //return new Text(snapshot.data[0]['name']);
            }
          },
        )
    );
  }
  Widget _cuadroCategoria(id,name,image){
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () async {
          await setEvento("listarProductosPorCategoria&categories_id=$id",name);
          widget.actualizarHome('');

        },
        child:
        Stack(
            alignment: Alignment.bottomLeft,
            children:[
              SizedBox(
                height: 130,
                child: Hero(
                  tag: "$id",
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: "$BASE_URL/storage/$image",
                    // imageUrl: "https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80",
                    placeholder: (context, url) =>
                        Center(
                            child:
                            CircularProgressIndicator()),
                    errorWidget:
                        (context, url, error) =>
                    new Icon(Icons.error),
                  ),
                ),
              ),
              /* Container(
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                      color: Colors.white
                  ),
                  child:Text(name,style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(colorRojo),
                  ),
                  ),

                ),*/
            ]
        ),

      ),
    );

  }

  _banner(String rutaImagen){
    return Container(
      child: Padding(
        padding: EdgeInsets.only(
            top: 6.0, left: 8.0, right: 8.0, bottom: 10),
        child: Image(
          fit: BoxFit.cover,
          image: AssetImage(rutaImagen),
        ),
      ),
    );
  }
  _textoTitulo(String titulo){

    return Padding(
      padding: EdgeInsets.only(
          top: 4.0, left: 8.0, right: 8.0),
      child: Text(titulo,
          style: TextStyle(
              color: Color(colorRojo),
              fontSize: 18,
              fontWeight: FontWeight.w700)),
    );
  }
  _textoTituloCentrado(String titulo){
    return Center(
        child: _textoTitulo(titulo));
  }
  _tituloConBoton(String titulo,String textoBoton,String link){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _textoTitulo(titulo),
        Padding(
          padding: const EdgeInsets.only(
              right: 8.0, top: 4.0, left: 8.0),
          child: RaisedButton(
              color: Theme.of(context).primaryColor,
              child: Text(textoBoton,
                  style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.pushNamed(context, link);
              }),
        )
      ],
    );
  }

  Categorias() {
    return Container(
        height: 140.0,
        child:
        new FutureBuilder(
          future: listarCategorias(), // async work
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting: return Center(child:CircularProgressIndicator());
              default:
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                else{
                  return _bloqueCategorias(snapshot.data);
                }
                  return new Text(snapshot.data[0]['name']);
            }
          },
        ),
    );

  }
  _bloqueCategorias(data){
    return new ListView.builder
      (
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (BuildContext ctxt, int index) {
          var ca=data[index];
          return _cuadroCategoria(ca['id'],ca['name'],ca['image']);
        }
    );
  }
  listarCategorias() async{
    Map data=  jsonDecode(await getData('categories'));
    if(data['success']==true){
      return data['data'];
    }else{
      return false;
    }
  }
  Future<List<Post>> fetchPosts() async {
    http.Response response =
    await http.get('$BASE_URL/api_rapida.php?evento=listar_categorias_movil');

    List responseJson = json.decode(response.body);
    print("CATEGORIA");
    print(response.body);
    return responseJson.map((m) => new Post.fromJson(m)).toList();
   // return responseJson;
  }

  cajaProductos(products) {
    //final formatCurrency = new NumberFormat("#,##0.00", "en_US");
    return List.generate(products.length, (index) {
      String imagen="$BASE_URL/storage/"+products[index]['image'];
      String imagen_grande=products[index]['image_grande'];
      String name=products[index]['name'];
      String priceDolar=formatDolar.format(double.parse(products[index]['total_precio_dolar']));
      String price=formatBolivar.format(double.parse(products[index]['total_precio']));
      double rating=double.parse(products[index]['rating']);
      String description_short=products[index]['description_short'];
      int id=int.parse(products[index]['id']);
      double precioDolar=double.parse(products[index]['total_precio_dolar']);
      double precioBolivar=double.parse(products[index]['total_precio']);
      String otroId=products[index]['id']; //se creo porque al pasar el de arriba sin explicaion no funciona
      String calificado_por_mi=products[index]['calificado_por_mi'];
      int stock=int.parse(products[index]['qty_avaliable']);
      int pedidoMaximo=int.parse(products[index]['qty_max']);
      return Container(
        color: Colors.white,
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
          child: InkWell(

            onTap: () {
              Navigator.pushNamed(
                context,
                '/producto',
                arguments: Products(
                    image:imagen_grande,
                    image_previa: imagen,
                    name:name,
                    precio:priceDolar+"/"+price,
                    rating: rating,
                    description_short:description_short,
                    precioDolar:precioDolar,
                    precioBolivar:precioBolivar,
                    id:id,
                    calificado_por_mi: calificado_por_mi,
                  stock: stock,
                  pedidoMax: pedidoMaximo,

                  // message:'este argumento es extraido de producto.',
                ),
              );
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
                  padding: const EdgeInsets.only(top: 1.0),
                  child: ListTile(
                    title: Text(
                      name,
                      maxLines: 2,


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
                            new Rating(rating: rating,nombre: name,calificado_por_mi: calificado_por_mi,products_id: id),

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
class Post {
  final String id;
  final String name;
  final String image;

  Post({this.id, this.name, this.image});

  factory Post.fromJson(Map<String, dynamic> json) {
    return new Post(
      image: Uri.decodeFull(json['image'].toString()),
      name: json['name'].toString(),
      id: json['id'].toString(),
    );
  }
}