import 'package:biomercados/blocks/auth_block.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:biomercados/funciones_generales.dart';
import 'package:provider/provider.dart';
class AgregarProducto extends StatefulWidget {
  final double precioDolar;
  final double precioBolivar;
  final int stock;
  final int pedidoMax;
  final int id;
  const AgregarProducto({Key key, this.precioDolar, this.precioBolivar,this.id, this.stock, this.pedidoMax}) : super(key: key);
  @override
  _AgregarProductoState createState() => _AgregarProductoState();
}
class _AgregarProductoState extends State<AgregarProducto> {
  int _cant=0;
  List productos;
  String _bolivar='0';
  String _dolar='0';
  int _stock=0;
  int _pedidoMax=0;

  bool cargado=false;
  final formatDolar = new NumberFormat.simpleCurrency(locale: 'en_US',decimalDigits: 2);
  final formatBolivar = new NumberFormat.simpleCurrency(locale: 'es_ES',name: 'Bs',decimalDigits: 2);

  bool _rojoStock=false;
  Color _colorStock=Colors.black;
  bool _rojoMaximo=false;
  Color _colorMaximo=Colors.black;
  //Future init() async {
   // print("initssssssssssssssssss");
    //await getCarrito();
 // }

  @override
  Widget build(BuildContext context) {
    final proveedor = Provider.of<AuthBlock>(context);
    return FutureBuilder(
      future: proveedor.getCarritob(),
      builder: (context, obj) {
       // if (obj.connectionState == ConnectionState.done) {
         // if(productos!=null){
           // obj.data['productos']=jsonEncode(productos);
        //  }
        _stock=widget.stock-_cant;
        _pedidoMax=widget.pedidoMax;
          if(cargado==false) {
            if (obj.connectionState == ConnectionState.done) {
              if (obj.data['productos'] != null) {
              //if (obj.data['productos'] ?? false) {
              //print("producto lleno");
            //  print(obj.data['productos']);
              // productos=jsonDecode(obj.data['productos']);
              // int prueba=obj.data['productos'][widget.id.toString()];
              //print("consultando "+widget.id.toString()+" resultado: $prueba");
              // _stock=widget.stock-_cant;
              if (obj.data['productos'][widget.id.toString()] != null) {
                _cant = obj.data['productos'][widget.id.toString()];
               // print("La nueva cantidad es: $_cant");
                // setState(() {

                _dolar = formatDolar.format((widget.precioDolar * _cant));
                _bolivar = formatBolivar.format((widget.precioBolivar * _cant));

                //});
              }
              } else {
              print("producto NULO");
              }
              cargado = true;
            }
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child://Row(
                  //children: <Widget>[
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: //<Widget>[

  widget.pedidoMax>0 ? [wStock(),wPedidoMax()] : [wStock()]

            //],
)
                 // ],
                //),
              ),


              FlatButton(child: Icon(Icons.do_not_disturb_on),

                  onPressed: () async {


                  if(_cant>0) {
                    _rojoStock=false;
                    _colorStock=Colors.black;

                    _cant--;
                    _stock++;
                    _dolar=formatDolar.format((widget.precioDolar*_cant));
                    _bolivar=formatBolivar.format((widget.precioBolivar*_cant));
                    //productos[widget.id] = _cant;
                    await setCarrito(widget.id,_cant);
                   proveedor.actualizar();
                  }
                   if(_pedidoMax>_cant){
                    if(_rojoMaximo){

                        _rojoMaximo=false;
                        _colorMaximo=Colors.black;


                    }
                  }

              }),
              Icon(Icons.shopping_cart,size: 16,),
              Text("$_cant",style: TextStyle(fontSize: 21),),
              FlatButton(
                child: Icon(Icons.add_circle),
                onPressed: () async {

if(_stock>0 && (_pedidoMax>_cant || widget.pedidoMax==0) && widget.stock>_cant) {

  //setState(() async {

    if (_cant >= 0) {
      _cant++;

      _stock--;
      _dolar = formatDolar.format((widget.precioDolar * _cant));
      _bolivar = formatBolivar.format((widget.precioBolivar * _cant));
      await setCarrito(widget.id, _cant);
      proveedor.actualizar();
      // productos[widget.id] = _cant;
    }
 // });
}

if(_stock==0 || widget.stock==_cant){
  if(!_rojoStock){
    setState(() {
      _rojoStock=true;
      _colorStock=Colors.red;
    });

  }
}
if(_pedidoMax<=_cant && widget.pedidoMax!=0){
  if(!_rojoMaximo){
    setState(() {
      _rojoMaximo=true;
      _colorMaximo=Colors.red;
    });

  }
}
                },
              ),
            ],
          );

        //}else{
        //  return Center(child:CircularProgressIndicator());
        //}
      },
    );

  }
  Widget wStock(){
    return Text("En stock: "+widget.stock.toString(),style: TextStyle(fontSize: 16,color: _colorStock),);
  }
  Widget wPedidoMax(){
    return Text("Pedido Máximo: $_pedidoMax",style: TextStyle(fontSize: 16,color: _colorMaximo) );
  }
}




