import '../home/listado_productos.dart';
import '../modelo.dart';
import 'package:flutter/material.dart';
import '../funciones_generales.dart';
import '../modelo/products.dart';
import '../shop/search.dart';
import 'package:Pide/pide_icons.dart';
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
  _capturarRetroceso(){//para actualizar la pagina esta despues que retrocedan de la pagina productos
    setState(() {

    });
  print("capturadoY retroceso");
  }

  Future _getTaskAsync;
  @override
  void initState() {
    _getTaskAsync = ModeloTime().listarProductos();
    super.initState();
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
          elevation: 0,
          iconTheme: IconThemeData(
            color:Color(colorVerde), //change your color here

          ),
          
         //leading: btnAtrasProductos(),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          primary: false,
          actions: <Widget>[
            
            IconButton(
              icon: Icon(Pide.tune,color: Color(colorVerde),),

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
          title: Text(ModeloTime().titulo ?? widget.titulo, style: TextStyle(color: Color(colorVerde)),),
        ),
        body:  ListadoProductos(tipoListado: 'otros',),

      ),

    );
  }
  Widget btnAtrasProductos(){
    //return null;
    return IconButton(
      icon: Icon(Pide.arrow_back),
    onPressed: () => Navigator.pushNamed(context,"/home"),
    );
  }
}