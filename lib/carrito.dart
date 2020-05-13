import 'dart:convert';
import 'package:biomercados/modelo.dart';
import 'package:biomercados/blocks/auth_block.dart';
import 'package:biomercados/blocks/modelo.dart';
import 'package:biomercados/direcciones.dart';
import 'package:biomercados/funciones_generales.dart';
import 'package:biomercados/hora_entrega.dart';
import 'package:biomercados/widget/modal_orden.dart';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'config.dart';
import 'modelo/products.dart';

class Carrito extends StatefulWidget {
  @override
  _CartListState createState() => _CartListState();
}

class _CartListState extends State<Carrito> with TickerProviderStateMixin{

  double _totalDolares=0.00;
  double _totalBolivares=0.00;
  double _totalPeso=0.00;
  String _totalDolaresConFormato='0.00';
  String _totalBolivaresConFormato='0.00';
  Map _totalProductoD = Map();
  Map _totalProductoB = Map();
  Map _totalProductoDConFormato = Map();
  Map _totalProductoBConFormato = Map();
  final Modelo modelo = Modelo();
  int selectedRadio;
  int selectedRadioMetodoPago;
  TabController _tabController;
  int _tabIndex = 0;
  bool _recargo=false;
  String _varprecioEnvio="0.00";
  String _varprecioEnvioD="0.00";
bool actualizar_pagina_anterior=false;
bool cargadoArgumento=false;
  @override
  void initState() {

    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    selectedRadio = 0;
  }
  setSelectedRadio(int val) {
    setOtroCarrito('direccion', val.toString());
    setState(() {

      selectedRadio = val;
    });
  }
  setSelectedRadioMetodoPago(int val) {
    setOtroCarrito('metodoPago', val.toString());
    setState(() {

      selectedRadioMetodoPago = val;
    });
  }

  void _toggleTab() {
    _tabIndex = _tabController.index + 1;
    _tabController.animateTo(_tabIndex);
  }

  _capturarRetroceso()async{//para actualizar la pagina esta despues que retrocedan de la pagina productos
    setState(() {

    });
    print("capturado retroceso");
  }

  @override
  Widget build(BuildContext context) {

    if(cargadoArgumento==false) {
      cargadoArgumento=true;
      actualizar_pagina_anterior = ModalRoute
          .of(context)
          .settings
          .arguments;

    }


    final proveedor = Provider.of<AuthBlock>(context);
    return DefaultTabController(
        length: 2,
        child: new Scaffold(
          appBar: AppBar(
            leading: leadingBio(context),
            title: titleBio('Carrito de compras'),
            backgroundColor: colorAppBarBio(),
            actions: <Widget>[
              Padding(padding:EdgeInsets.all(10.00),child:Image(image: AssetImage("assets/images/ico2.png"),height: 5.00,))
            ],
            bottom: TabBar(
                controller: _tabController,
                indicatorColor: Color(colorRojo),
                tabs:
                [
                  Tab(icon: Icon(Icons.shopping_cart),),
                  Tab(icon: Icon(Icons.local_shipping),),
                  //Tab(icon: Icon(Icons.payment),),



                ]

            ),
          ),
          body: TabBarView(
              controller: _tabController,
              children:
              [
//             any widget can work very well here <3

                new Container(
                  //color: Colors.redAccent,
                  child:
            FutureBuilder<Map>(
            future: _listarProductosCarrito(), // async work
            builder: (BuildContext context, AsyncSnapshot<Map> projectSnap) {
              switch (projectSnap.connectionState) {
                case ConnectionState.waiting: return new Center(child: CircularProgressIndicator(),);
                default:
                  if (projectSnap.hasError)
                    return new Text('Error: ${projectSnap.error}');
                  else
                    return cargarCarrito(projectSnap.data);
              }
            },
          )





   ,
                ),//Carrito
                new Container(
                  //color: Colors.greenAccent,
                  child: _listadoDeDirecciones(),

                ),//Direcciones


              ]),
        ));

  }


  Widget cargarCarrito(data){
  if(data['vacio']) {
    msj("Su carrito se encuentra vacío");
//Navigator.canPop(context);
//Navigator.pushReplacementNamed(context, '/home');
   // msj("Carrito vaciado.");
//Future.delayed(Duration(seconds: 3));
  //  Navigator.pushReplacementNamed(context, '/home');


    //if(actualizar_pagina_anterior){
    //  Navigator.pop(context);
    //  Navigator.pop(context);
    //}else{
    //  Navigator.pop(context);
    //}
   return Text("");

  }else{
    List products = data['productos'];
    return Column(
      children: <Widget>[
        //Padding(
        // padding: const EdgeInsets.only(
        //     top: 12.0, bottom: 12.0),
        //  child: Container(
        //    child: textoTop2(
        //       "Verifique su carrito de compras"), //Text(products.length.toString() + " Productos en tu carrito", textDirection: TextDirection.ltr, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
        //  ),
        // ),
        Flexible(
          child: ListView.builder(
            //shrinkWrap: true,
              itemCount: products.length,
              itemBuilder: (context, index) {
                final item = products[index];
                // _totalDolares+=(double.parse(item['total_precio_dolar'])*item['cant']);

                return Dismissible(
                  // Each Dismissible must contain a Key. Keys allow Flutter to
                  // uniquely identify widgets.
                  key: Key(UniqueKey().toString()),
                  // Provide a function that tells the app
                  // what to do after an item has been swiped away.
                  onDismissed: (direction) async {
                    await setCarrito(
                        int.parse(item['id']), 0);
                    Scaffold.of(context)
                        .showSnackBar(SnackBar(
                        content: Text(item['name'] +
                            " Eliminado del carrito"),
                        duration: Duration(seconds: 1)));

                    products.removeAt(index);
                    if(products.length==0){
                      msj("Carrito vaciado.");
                      Navigator.pushReplacementNamed(context, '/home');
                    }else {
                      setState(() {

                      });
                    }
                  },
                  // Show a red background as the item is swiped away.
                  background: Container(
                    decoration: BoxDecoration(
                        color: Colors.red),
                    padding: EdgeInsets.all(5.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0),
                          child: Icon(Icons.delete,
                              color: Colors.white),
                        ),

                      ],
                    ),
                  ),
                  secondaryBackground: Container(
                    decoration: BoxDecoration(
                        color: Colors.red),
                    padding: EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 20.0),
                          child: Icon(Icons.delete,
                              color: Colors.white),
                        ),

                      ],
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      String imagen_grande = item['image_grande'];
                      String imagen = item['image'];
                      String name = item['name'];
                      String priceDolar = formatDolar
                          .format(double.parse(
                          item['total_precio_dolar']));
                      double precioDolar = double.parse(
                          item['total_precio_dolar']);
                      double precioBolivar = double.parse(
                          item['total_precio']);

                      String price = formatBolivar.format(
                          double.parse(
                              item['total_precio']));
                      double rating = double.parse(
                          item['rating']);
                      String description_short = item['description_short'];
                      int id = int.parse(item['id']);
                      String calificado_por_mi = item['calificado_por_mi'];
                      int stock = int.parse(item['qty_avaliable']);
                      int pedidoMaximo = int.parse(item['qty_max']);
                      Navigator.pushNamed(
                        context,
                        '/producto',
                        arguments: Products(
                          image: imagen_grande,
                          image_previa: imagen,
                          name: name,
                          precio: priceDolar + "/" +
                              price,
                          precioDolar: precioDolar,
                          precioBolivar: precioBolivar,
                          rating: rating,
                          description_short: description_short,
                          id: id,
                          stock: stock,
                          pedidoMax: pedidoMaximo,
                          calificado_por_mi: calificado_por_mi,

                          // message:'este argumento es extraido de producto.',
                        ),
                      ).then((val) =>
                      {
                        _capturarRetroceso()
                      });
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .start,
                      children: <Widget>[
                        Divider(
                          height: 0,
                        ),
                        ListTile(
                          trailing: Text(
                              _totalProductoDConFormato[index] +
                                  " / " +
                                  _totalProductoBConFormato[index]),
                          leading: ClipRRect(
                            borderRadius: BorderRadius
                                .circular(5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.blue
                              ),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: BASE_URL_IMAGEN +
                                    item['image'],
                                // placeholder: (context, url) => Center(
                                //    child: CircularProgressIndicator()
                                // ),
                                errorWidget: (context,
                                    url, error) =>
                                new Icon(Icons.error),
                              ),
                            ),
                          ),
                          title: Text(
                            item['name'],
                            style: TextStyle(
                                fontSize: 14
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets
                                        .only(top: 2.0,
                                        bottom: 1),
                                    child: Text('X ' +
                                        item['cant']
                                            .toString(),
                                        style: TextStyle(
                                          color: Color(
                                              colorRojo),
                                          fontWeight: FontWeight
                                              .w700,
                                        )),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                );
              }),
        ),
        Container(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 0.0, top: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Text("TOTAL: ",
                              style: TextStyle(
                                fontSize: 16,),)
                        ),
                        Text(
                            "$_totalDolaresConFormato / $_totalBolivaresConFormato",
                            style: TextStyle(fontSize: 23,
                                fontWeight: FontWeight
                                    .bold)
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 0.0, top: 10),
                    child: Row(
                      children: <Widget>[
                        InkWell(
                          child: Text("Vaciar carrito",
                            style: TextStyle(fontSize: 16,
                                color: Colors.blue),
                            textAlign: TextAlign.left,),
                          onTap: () async {
                            msj("Carrito vaciado.");
                            await delCarrito();
                            await iniciarCarrito();
                            Navigator.pushReplacementNamed(context, '/home');
                           //setState((){
                            //Navigator.pop(context);
                            //Navigator.pop(context);
                        //  });

                          },
                        ),

                        Expanded(
                          child: Text(
                            "(Impuestos incluidos)",
                            style: TextStyle(fontSize: 16,
                                color: Colors.red),
                            textAlign: TextAlign.right,),
                        ),
                        // Text("\$41.24",  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            )
        ),
        _botonContinuar()
      ],
    );
  }
}
void _showAlert(String value ){
    showDialog(
        context: context,
        builder: (_) =>
        Modal(value: value,)
    );
  }
  reVerificarProductos(int v){

}
  Future<Map> _listarProductosCarrito() async {
      Map res=Map();
      res['vacio']=true;
      Map carrito = await getCarrito();
      List productos;
      double totalD = 0.00;
      double totalB = 0.00;
      print("listando productos carrito");
      if (carrito['productos']!=null) {

        carrito['productos'].forEach((index, value){
          if(value>0){
            res['vacio']=false;
          }
        });
      if(res['vacio']==true){
        return res;
      }

          productos = await _generarListaCarrito(jsonEncode(carrito['productos']));

          _totalPeso = 0.00;
          if (productos!=null) {
            for (var i = 0; i < productos.length; i++) {
              _totalProductoD[i] =
                  double.parse(productos[i]['total_precio_dolar']) *
                      productos[i]['cant'];
              _totalProductoDConFormato[i] =
              formatDolar.format(_totalProductoD[i]);
              totalD += _totalProductoD[i];

              _totalProductoB[i] =
                  double.parse(productos[i]['total_precio']) *
                      productos[i]['cant'];
              _totalProductoBConFormato[i] =
              formatBolivar.format(_totalProductoB[i]);
              totalB += _totalProductoB[i];


              _totalPeso+=(double.parse(productos[i]['peso']) * productos[i]['cant']);
              print(productos[i]['id']+"->Producto"+productos[i]['name']+" "+productos[i]['peso']+" "+productos[i]['cant'].toString()+" "+_totalPeso.toString());
            }
            _totalDolaresConFormato = formatDolar.format(totalD);
            _totalBolivaresConFormato = formatBolivar.format(totalB);
            res['productos']=productos;
            return res;
          } else {
            res['vacio']=true;
            return res;
          }

        } else {
         return res;
        }


  }
  _generarListaCarrito(productos) async {
    _precioEnvio();
    String url=await UrlLogin('listarProductosCarrito&json=$productos');
    print(url);
    Map res=await peticionGetZlib(url);

    if (res['success']==true) {
      return res['data'];
    }else{
     // msj(res['msj_general']);
      return null;
    }
  }
  _listadoDeDirecciones(){
    DateTime today = new DateTime.now();
    DateTime fiftyDaysAgo = today.add(new Duration(hours: 3));
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 12.0, bottom: 5.0),
          child:
          textoTop2("¿Donde desea recibir su pedido?"),//Text(products.length.toString() + " Productos en tu carrito", textDirection: TextDirection.ltr, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))

        ),Divider(),
        Padding(padding: EdgeInsets.only(top:5),),
        Padding( padding: EdgeInsets.only(left:4,right: 4),
          child: ListTile(

            title: Text("Retirar en zona pick up",style: TextStyle(fontWeight: FontWeight.bold),),

            subtitle:Container(
                child: Text("Biomercados Mañongo, vía de servicio paralela a la autopista, Entre dito park y tienda daka, Carabobo, Venezuela.")
          ),

            trailing:
            Radio(
              value: 0,
              groupValue: selectedRadio,
              activeColor: Color(colorRojo),
              onChanged: (val) {
                print("Radio Retirar en tienda $val");
                _recargo=false;
                setSelectedRadio(val);
              },
            )
            ,
            onTap: (){


            },
          ),),
        FutureBuilder(
          future: modelo.getAdreess(),
          builder: (context, projectSnap) {
            if (projectSnap.connectionState == ConnectionState.done) {
              return _listarDirecciones(projectSnap.data);

            }else {
              return CircularProgressIndicator();
            }
          },

        ),
       // Text("Especifique la hora de entrega:"),
        Padding(
          padding: EdgeInsets.only(left:20,right: 20),

              child: Column(children: <Widget>[

                Center(child: a(context,"Agregar nueva dirección","/direcciones"),),
                Row(children: <Widget>[Text("Hora aprox. de entrega: ",style: TextStyle(fontSize: 16),),Expanded(child: HoraEntrega())],),
    ],)

        ),


        _recargoEnvio(),




        Padding(padding: EdgeInsets.only(bottom:10),),
        _botonPagar()
        //_botonContinuar()

      ],);
  }

  InkWell a(context,String texto,String link){
    return InkWell(
      child: Text(texto, style: TextStyle(fontSize:18,fontWeight: FontWeight.bold ,color: Color(colorVerde))),
      onTap: () {
        //setState((){
        Navigator.pushNamed(context, link);
        //});

      },
    );
  }
  _listarDirecciones(data){

    if(data!=null) {
      return Flexible(
        child: ListView.builder(
          //physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int index) {

            return Card(
              child: _bloqueDireccion(data[index],data,index),
            );
          },
          padding:EdgeInsets.only(bottom: 20.0),
        ),
      );
    }else {
      return Padding(padding: EdgeInsets.all(20),child: Text(
        "No tienes direcciones registradas, agregue una para recibir despachos.",
        style: TextStyle(fontSize: 20,),
        textAlign: TextAlign.justify,
      ),);
    }
  }
  _bloqueDireccion(data,datab,index){
    String id=data['id'];
    String address=data['address'];
    String reference_point = data['reference_point'] ?? '';
    String nro_home = data['nro_home'] ?? '';
    String sector = data['sector'] ?? '';
    String urb = data['urb']?? '';
    String zip_code = data['zip_code']?? '';
    String cities_id = data['cities_id']?? '';
    String states_id = data['states_id']?? '';
    String regions_id = data['regions_id']?? '';
    return ListTile(
      title: Text(
        address,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),

      subtitle:Container(
          child: Text("Estado "+data['st_name']+", municipio "+data['re_name']+", parroquia "+data['ci_name']+",Urb: "+urb+", Sector: "+sector+", Nro. "+nro_home+", Punto de referencia: "+reference_point,
          )),

      trailing:
      Radio(
        value: int.parse(id),
        groupValue: selectedRadio,
        activeColor: Color(colorRojo),
        onChanged: (val) {
          print("Radioss $val");
          _recargo=true;
          setSelectedRadio(val);
        },
      )
      ,
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Direcciones(id: id,address: address,urb:urb,nro_home: nro_home,reference_point: reference_point,sector: sector,zip_code: zip_code,cities_id:cities_id,states_id: states_id,regions_id: regions_id,),
          ),
        ).then((val)=>{_capturarRetroceso()});
      },
    );
  }
  _botonPagar(){
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10),
      child: ButtonTheme(
        buttonColor: Theme.of(context).primaryColor,
        minWidth: double.infinity,
        height: 40.0,
        child: RaisedButton(
          onPressed:() async {
            _showAlert("A partir de este momento no podrá modificar su carrito, ¿está seguro de continuar?");
          },
          child: Text(
            "Procesar orden y pagar",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
  _botonContinuar(){
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10),
      child: ButtonTheme(
        buttonColor: Theme.of(context).primaryColor,
        minWidth: double.infinity,
        height: 40.0,
        child: RaisedButton(
          onPressed:
          //print(_tabController);
          // PageController.jumpToPage(1);
          //_tabController.animateTo(1);
          _toggleTab

          ,
          child: Text(
            "Siguiente",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }


_precioEnvio() async{

  Map res=await ModeloTime().envio();


  if (res['success']) {
    double peso_max=double.parse(res['data'][0]['peso_max']);

    double peso_cargado=peso_max;
    int multiplo_peso=1;
    print("PESO"+_totalPeso.toString());
    while(_totalPeso>peso_cargado) {
      multiplo_peso++;
      //if (_totalPeso > peso_max) {
        peso_cargado+=(peso_max+peso_cargado);
     // }
    }

      _varprecioEnvio=formatBolivar.format(double.parse(res['data'][0]['precio_b'])*multiplo_peso);
      _varprecioEnvioD=formatDolar.format(double.parse(res['data'][0]['precio_d'])*multiplo_peso);
  }else{
    msj(res['msj_general']);
  }
}
  _recargoEnvio() {
      if(_recargo) {
        return Text("Costo del envío: $_varprecioEnvioD / "+_varprecioEnvio,style: TextStyle(fontSize: 20),);
      }else{
        return Text("");
      }
  }
}
