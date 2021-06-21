import 'dart:convert';
import '../modelo.dart';
import '../modelo/combos.dart';
import 'package:flutter/material.dart';
import '../funciones_generales.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../config.dart';
import 'package:Pide/pide_icons.dart';
class ListadoCombos extends StatefulWidget {
  const ListadoCombos({Key key}) : super(key: key);
  @override
  _CombosState createState() => _CombosState();
}
class _CombosState extends State<ListadoCombos> {

  Future _getTaskAsync;
  @override
  void initState() {
    _getTaskAsync =  ModeloTime().listarCombos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                          children: cajaCombos(projectSnap.data['data']),
                        ),
                    );
                  } else {
                    return Padding(
                        padding: EdgeInsets.only(bottom: 50, left: 20, right: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            //Icon(Pide.do_not_disturb,size: 50,),

                            //"Ups, nos hemos encontrado Combos que coincidan con tu búsqueda, intenta más tarde."
                            Center(child: Text(projectSnap.data['msj_general'],
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Color(colorRojo),
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),),),


                            //Text("No hay Combos, intente mas tarde.",style: TextStyle(fontSize: 30),)
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




  terminarListarCombos(){

  }

  cajaCombos(combos) {

    //final formatCurrency = new NumberFormat("#,##0.00", "en_US");
 return List.generate(combos.length, (index) {
    List json=List();
   String imagen="$BASE_URL_IMAGEN"+combos[index]['image'].replaceAll('\\', '/');
   String imagen_grande='["'+combos[index]['image_grande'].replaceAll('\\', '/')+'"]';
   String name=combos[index]['name'];

   int id=int.parse(combos[index]['id']);

   double precioDolar=double.parse(combos[index]['total_precio_dolar']);

   double precioBolivar=double.parse(combos[index]['total_precio']);

   String precioDolarF=formatDolar.format(precioDolar);
   String precioBolivarF=formatBolivar.format(precioBolivar);
   String todoPrecio=precioDolarF+"/"+precioBolivarF;

  json =jsonDecode(combos[index]['json']);
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
                 '/combo',
                 arguments: Combos(
                     image:imagen_grande,
                   imagenPrevia:imagen,
                     name:name,
                     precio:todoPrecio,
                     precioDolar:precioDolar,
                     precioBolivar:precioBolivar,
                     json:json,
                     id:id,

                   // message:'este argumento es extraido de Combos.',
                 ),
               );
             },
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: <Widget>[
                 SizedBox(
                   height: (MediaQuery.of(context).size.width / 2 - 5)-10,
                   //height: 180,
                   width: double.infinity,

                   child: CachedNetworkImage(
                   //  color: Colors.white,
                     fit: BoxFit.scaleDown,
                     imageUrl: imagen,
                     placeholder: (context, url) => Center(
                         child: CircularProgressIndicator()
                     ),
                     errorWidget: (context, url, error) => new Icon(Pide.error),
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
                           child: Text(todoPrecio, style: TextStyle(
                               color: Color(colorVerde),
                               fontWeight: FontWeight.w700,
                               fontSize: 13
                           )),
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