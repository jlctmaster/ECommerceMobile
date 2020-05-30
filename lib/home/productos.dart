import 'package:biomercados/home/listado_productos.dart';
import 'package:biomercados/modelo.dart';
import 'package:flutter/material.dart';
import 'package:biomercados/funciones_generales.dart';
import 'package:biomercados/modelo/products.dart';
import 'package:biomercados/shop/search.dart';
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
  print("capturado retroceso");
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
          automaticallyImplyLeading: true,
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
          title: Text(ModeloTime().titulo ?? widget.titulo, style: TextStyle(color: Color(colorVerde)),),
        ),
        body:  ListadoProductos(tipoListado: 'otros',),

      ),

    );
  }
}