import 'dart:convert';
import 'package:biomercados/home/ordenes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:biomercados/funciones_generales.dart';
import 'package:biomercados/home/principal.dart';
import 'package:biomercados/home/productos.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import 'drawer.dart';
//import 'package:flutter_typeahead/flutter_typeahead.dart';

class Home extends StatefulWidget {
  final int indexTab;

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

  bool _indexActualizado=false;
String textoBuscador;

  bool _aceptarTab=true;

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
  leading: Padding(padding:EdgeInsets.only(left:7.00),child:Image(image: AssetImage("assets/images/ico2.png"))),
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

      InkWell(child: Icon(Icons.search,color: Colors.black45,),onTap: () async {
        await setEvento('listarProductosPorBusqueda&texto='+textoBuscador,"Búsqueda personalizada: "+textoBuscador);
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
    //GestureDetector( onTap: () {msj("sdfsd");}, child: Icon(Icons.volume_up) ),

    IconButton(
      icon: Icon(Icons.favorite,color: Color(colorRojo),),
      onPressed: () {
        setEvento('listarFavoritos',"Mis Favoritos");
         setState(() {
           _selectedIndex=1;
         });
      },
      padding: EdgeInsets.only(left:9.00),
    ),
    //
    iconoCarrito(context,false),
    Builder(
      builder: (context) => IconButton(
        icon: Icon(Icons.menu),
        onPressed: () => Scaffold.of(context).openEndDrawer(),
        tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
      ),
    ),
  ],
),
body: FutureBuilder(
  future: vista(),
  builder: (context, projectSnap) {
    if (projectSnap.connectionState == ConnectionState.done) {
      return WillPopScope(
        child:projectSnap.data,
        onWillPop: () {

          //return !await msj("ddd");
          if(_selectedIndex==1){

            setState(() {
              _selectedIndex=0;
              setEvento('listarProductos',"Productos");
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
          //return false;
        }

        ,);


    }else {
      return CircularProgressIndicator();
    }
  },
),
backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Inicio'),


          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket),
            title: Text('Productos'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            title: Text('Ordenes'),
          ),

        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xff6A9D00),
        selectedFontSize: 15,

        onTap: _onItemTapped,
      ),
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

  switch(_selectedIndex) {
    case 0:
      return Principal(actualizarHome: _actualizarEvento,);
      break;
    case 1:
      return Productos(titulo: await getTitulo());
      break;
    case 2:
      return Ordenes();
      break;
    default:
      return Principal();
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

            await setEvento('listarProductosPorBusqueda&texto='+a,"Resultado de la busqueda: "+a);
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
          // leading: Icon(Icons.shopping_cart),
          title: Text(suggestion['name']),
          // subtitle: Text('\$${suggestion['price']}'),
        );
      },
      onSuggestionSelected: (suggestion) async {
        await setEvento('listarProductosPorBusqueda&texto='+suggestion['name'],"Resultado de la busqueda: "+suggestion['name']);
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
      final response = await http.get(
        url, headers: {"Accept": "application/json"},);
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






