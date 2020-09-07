import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:villaspark/funciones_generales.dart';
import 'package:villaspark/modelo.dart';

class MenuCategorias extends StatefulWidget {
  final ValueChanged<String> actualizarHome;
  MenuCategorias({Key key, this.actualizarHome}) : super(key: key);

  @override
  _MenuCategoriasState createState() => _MenuCategoriasState();
}

class _MenuCategoriasState extends State<MenuCategorias> {
  Future _listarCategorias;
  @override
  void initState() {
  _listarCategorias=listarCategorias();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Categorias(),
    );
  }
    Categorias() {
    return Container(
      alignment: Alignment.center,
        height: 40.0,
        child:
        new FutureBuilder(
          future: _listarCategorias, // async work
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
          return _cuadroCategoriaNuevo(ca['id'],ca['name'],ca['image']);
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

      Widget _cuadroCategoriaNuevo(id,name,image){
    return InkWell(
      
      
        onTap: () async {
          await setEvento("listarProductosPorCategoria&categories_id=$id",name);
          widget.actualizarHome('');

        },
        child: Padding(child:_botonCategoria(name,id),padding: EdgeInsets.all(2)),
                
              
          
      );
    

  }
  _botonCategoria(name,id){
    return DecoratedBox(
      
      decoration:
          ShapeDecoration(shape: 
          RoundedRectangleBorder(
            
            side: BorderSide(
            color: Color(colorVerde),
            width: 1,
            style: BorderStyle.solid
          ), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))
          )
          
          , color: Color(colorVerde)),
      child: Padding(child:Text(name,style:TextStyle(color:Colors.white),),padding: EdgeInsets.all(9),),
    );
  }
}