import 'dart:convert';
import 'package:Pide/pide_icons.dart';

import '/home/menuCategorias.dart';
import '/modelo.dart';
import '/widget/icono_carrito.dart';

import '../home/ordenes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../funciones_generales.dart';
import '../home/principal.dart';
import '../home/productos.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import 'drawer.dart';
//import 'package:flutter_typeahead/flutter_typeahead.dart';

class Home extends StatefulWidget {
  final int indexTab;
  //final int tipoVistaOrden;
  const Home({Key key, this.indexTab}) : super(key: key);
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home>{
int _selectedIndex = 0;
String categories_id = null;
  bool ventana_config=false;
String tituloProducto="Productos";
  var evento;
  Future _listarPublicidadTop;
  Future _listarProductosHome;
  bool _indexActualizado=false;
String textoBuscador;

  bool _aceptarTab=true;

  var evento_actual;
  @override
  void initState() {
    _listarPublicidadTop=ModeloTime().listarPublicidad('top');
    _listarProductosHome = ModeloTime().listarProductosNuevo('listarProductosConPromocion');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print("ACTUALIZADO HOME");

    final a = GlobalKey<FormState>();
    return Scaffold(
        endDrawer: Drawer(
        child:   AppDrawer(),
    ),
appBar: AppBar(
backgroundColor: Colors.white,
  leading: Padding(
    padding:EdgeInsets.only(left:7.00),
    child: InkWell(
     
      onTap: ()async{
     await delEvento();
    // Navigator.pushReplacementNamed(context, '/home');
      //Navigator.pushNamed(context, '/home');
      setState(() {
      _selectedIndex = 0;
    });
    },
      
     
      child: Image(
      image: AssetImage("assets/images/ico2.png")
      ),
    )
    
 
    ),
  automaticallyImplyLeading: false,
  elevation: 0,
  // Provide a standard title.
  title: Container(
    height: 45,

    child: new Card(


        margin: EdgeInsets.only(left:7.00) ,
        child: Container(
          padding: EdgeInsets.only(left: 7.00,right: 7.00),
          child:Row(
            children: <Widget>[

              Flexible(
                child:
                        buscador(),
              ),

      InkWell(child: Icon(Pide.search,color: Colors.black45,),onTap: () async {
        await setEvento('listarProductosPorBusqueda&texto='+textoBuscador,"Resultados de: "+textoBuscador);
        Navigator.pushNamed(context, '/home');
      },),
            ],
          ),
        )
    ),


  ),
  //pinned: true,
  titleSpacing: 0.00,

  actions: <Widget>[
    //GestureDetector( onTap: () {msj("sdfsd");}, child: Icon(Pide.volume_up) ),

    IconButton(
      icon: Icon(Pide.favorite,color: Color(colorRojo),),
      onPressed: () async {
        if(await validarSesion()){
            await setEvento('listarFavoritos',"Mis Favoritos");
            setState(() {
              _selectedIndex=1;
            });

        }        

      },
      padding: EdgeInsets.only(left:9.00),
    ),
    //
    
    IconoCarrito(),
    Builder(
      builder: (context) => IconButton(
        icon: Icon(Pide.menu),
        onPressed: () => Scaffold.of(context).openEndDrawer(),
        tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
      ),
    ),
  ],
),
body:Column(
  
  children: [
MenuCategorias(actualizarHome: _actualizarEvento),
Expanded(child:FutureBuilder(
  future: vista(),
  builder: (context, projectSnap) {
    if (projectSnap.connectionState == ConnectionState.done) {

      return WillPopScope(
        child:projectSnap.data,
        onWillPop: () async {

          //return !await msj("ddd");
          if(evento_actual!='listarProductos'){
           await setEvento('listarProductos',"Productos");
            setState(() {
              _selectedIndex=1;

            });
            return false;
          }
          if(_selectedIndex==1){
            await setEvento('listarProductos',"Productos");
            setState(() {
              _selectedIndex=0;

            });
          }else if(_selectedIndex==2){

            setState(() {
              _selectedIndex=0;
            });
          }else{

            //_modalSalir("¿Desea salir de la aplicación?");
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            //
          }
          return false;
        }

        ,);


    }else {
      return CircularProgressIndicator();
    }
  },
))


],) ,
backgroundColor: Colors.white,

    );

  }

Future<Widget> vista() async {
  if(widget.indexTab!=null && _aceptarTab){
    _selectedIndex=widget.indexTab;

    _aceptarTab=false;
  }
evento= await getEvento();
if(evento!=null){
  if(_indexActualizado==false) {
    _indexActualizado=true;
    setState(() {
      _selectedIndex = 1;
    });

  }
}
  evento_actual=await getEvento();
  switch(_selectedIndex) {
    case 0:
      return Principal(actualizarHome: _actualizarEvento,publicidad: _listarPublicidadTop,listadoProductos: _listarProductosHome,);
      break;
    case 1:
      return Productos(titulo: await getTitulo());
      break;
    case 2:
      return Ordenes();
      break;
    default:
      return Principal(actualizarHome: _actualizarEvento,publicidad: _listarPublicidadTop,listadoProductos: _listarProductosHome,);
  }
}

_modalSalir(String value) {

  return new AlertDialog(
    title: new Text('Confirmación'),
    content: new Text(value,
      style: new TextStyle(fontSize: 25.0),),
    actions: <Widget>[
      new FlatButton(onPressed: (){
        Navigator.pop(context);

      }, child: Text('No')),
      new FlatButton(onPressed: (){
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      }, child: Text('Si')),
    ],
  );

}

_actualizarEvento(String evento) {
  setState(() {
    _selectedIndex = 1;
  });
}
  Future<void> _onItemTapped(int index) async {
    if(index==2){
        if(!await validarSesion()){
          return false;
        }
      
    }
    if(index==1){
      await setEvento('listarProductos',"Productos");
    }
    if(index==0){
      await delEvento();
    }
    
    setState(() {
      _selectedIndex = index;
    });

}
buscador(){
    return TypeAheadField(
      hideOnEmpty: true,
      hideSuggestionsOnKeyboardHide: true,
      //debounceDuration: Duration(milliseconds: 30),
      noItemsFoundBuilder:(v){ return Text(
          'Sin resultados.'
      );},
      textFieldConfiguration: TextFieldConfiguration(

          onChanged: (a){
            textoBuscador=a;
          },
          autofocus: false,
          style: TextStyle(
            // fontStyle: FontStyle.italic,
              fontSize: 16,
              decoration: TextDecoration.none,
              color: Colors.black54
          ),

          decoration: InputDecoration(
            hintText: 'Buscar...',
            border: InputBorder.none,


          ),
          onSubmitted: (a) async {

            await setEvento('listarProductosPorBusqueda&texto='+a,"Resultados de: "+a);
            Navigator.pushNamed(context, '/home');
          }
      ),
      hideOnError: true,
      suggestionsCallback: (pattern) async {
        return await buscarProducto(pattern);
        // return await BackendService.getSuggestions(pattern);
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          // leading: Icon(Pide.shopping_cart),
          title: Text(suggestion['name']),
          // subtitle: Text('\$${suggestion['price']}'),
        );
      },
      onSuggestionSelected: (suggestion) async {
        await setEvento('listarProductosPorBusqueda&texto='+suggestion['name'],"Resultados de: "+suggestion['name']);
        Navigator.pushNamed(context, '/home');
      },

    );
}

  buscarProducto(texto) async {
    String url;
    Map res;
    String datos = 'buscarProducto&texto=$texto';
    List<String> data = List(); //esto es para que detecte una lista vacia y muestre el mensaje sin error de que no hay resultados



    if(texto==null) return res;
    if(texto.length>2) {

      url = await UrlLogin(datos);
      var uri = Uri.parse(url);
      final response = await http.get(
        uri, headers: {"Accept": "application/json"},);
      res = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(res['msj_general']);

        return res['data'];
      } else {
        print(res['msj_general']);
        return data;
      }
    }else{
      return data;
    }
  }



}






