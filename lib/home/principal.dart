import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:biomercados/funciones_generales.dart';
import 'package:biomercados/home/rating.dart';
import 'package:biomercados/modelo/products.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
class Principal extends StatefulWidget {
  final ValueChanged<String> actualizarHome;

  const Principal({Key key, this.actualizarHome}) : super(key: key);
  @override
  _principalState createState() => _principalState();
}

class _principalState extends State<Principal> {

  @override
  Widget build(BuildContext context) {

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
                  _textoTituloCentrado('Categorias'),
                  Categorias(),// categorias en scroll lateral
                  _textoTituloCentrado('Seguro que te gusta'),
                  FutureBuilder(
                    future: listarProductos(),
                    builder: (context, projectSnap) {
                      if (projectSnap.connectionState == ConnectionState.done) {
                        if(projectSnap.data!=null) {
                          return Container(
                           // width: 350,
                              child: GridView.count(
physics: ClampingScrollPhysics(),
                                shrinkWrap: true,
                                crossAxisCount: 2,
                                childAspectRatio: 0.7,
                                padding: EdgeInsets.only(
                                    top: 8, left: 6, right: 6, bottom: 12),
                                children: cajaProductos(projectSnap.data),
                              ),
                            )


                          ;
                        }else{
                          return Padding(
                              padding: EdgeInsets.only(bottom: 50,left: 20,right: 20),
                              child:Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  //Icon(Icons.do_not_disturb,size: 50,),
                                  Center(child: Text("Ups, nos hemos encontrado productos que coincidan con tu búsqueda, intenta más tarde.", style: TextStyle(color:Color(colorRojo), fontSize: 22, fontWeight: FontWeight.bold),),),



                                  //Text("No hay productos, intente mas tarde.",style: TextStyle(fontSize: 30),)
                                ],)
                          );
                        }

                      }else {
                        return Center(child:CircularProgressIndicator());
                      }
                    },

                  ),


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
  Widget _cuadroCategoria(id,name,image){
    return Card(
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
        FutureBuilder<List<Post>>(
          future: fetchPosts(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container(child:Text("Cargando categorias..."));
            List<Post> posts = snapshot.data;
            return new ListView(
              scrollDirection: Axis.horizontal,
              children: posts.map((post) => _cuadroCategoria(post.id,post.name,post.image)).toList(),
            );
          },
        )

    );
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
  Future listarProductos() async {


    print("LISTO listarProductosIA");
    String url = await UrlLogin('listarProductosIA');
    final response = await http.get(
        url, headers: {"Accept": "application/json"});
    print(response.body);
    var res=jsonDecode(response.body);

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
