import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:villaspark/blocks/auth_block.dart';

import '../funciones_generales.dart';
import '../modelo.dart';
class AddCarrito extends StatefulWidget {
  final int id;
  final int stock;
  final int pedidoMaximo;
//COLOCAR EL REQUIRED AVERIGUAR EL MOTIVO
  const AddCarrito({Key key, this.id, this.stock, this.pedidoMaximo}) : super(key: key);
  @override
  _addCarritoState createState() => _addCarritoState();
}

class _addCarritoState extends State<AddCarrito> {
 
  int _cant=0;

    Future _getTaskAsync;
 /* @override
  void initState() {
    _getTaskAsync =  getData('carrito');
    super.initState();
  }*/
  Map rowCarritoViejo;
  @override
  Widget build(BuildContext context) {
     final proveedor = Provider.of<AuthBlock>(context);
     //final proveedor = Provider.of<AuthBlock>(context,listen: false);

                  return FutureBuilder(
                  future: proveedor.getCarritob(),
                  builder: (context, res) {
                    if (res.connectionState == ConnectionState.done) {
                      Map rowCarrito=res.data;
                      rowCarritoViejo=rowCarrito;
                           if (rowCarrito['productos'] != null) {
                                  Map pro=rowCarrito['productos'];
                                if (pro[widget.id.toString()] != null) {
                                  _cant=pro[widget.id.toString()];
                                }
                            }
                      return _todo(proveedor,rowCarrito);
                      
                    }else {
                      return _todo(proveedor,rowCarritoViejo);
                    }
                  },
                );








                 
        
  }

_todo(proveedor,rowCarrito){
  return Column(

          children: _cant==0 ? 
          [
            Padding(padding: EdgeInsets.only(top:100)),
            _btnMasCarrito(proveedor,rowCarrito)
          ] : [
            Padding(padding: EdgeInsets.only(top:73)),
            _btnMasMenosCarrito(proveedor,rowCarrito),
            _btnMasCarrito(proveedor,rowCarrito)
          ],

        );   
}
_btnMasCarrito(proveedor,rowCarrito){

return RawMaterialButton(
  onPressed: () async{
           _cant=_cant+1;
           if(_cant>widget.pedidoMaximo && widget.pedidoMaximo!=0){

             msj("Máximo permitido.");
           }else{
              if(_cant>widget.stock){
                msj("Stock Agotado.");
              }else{
                  await setCarrito(widget.id,_cant);
                  proveedor.notifyListeners();

              }
           }

          
        
  },
  elevation: 2.0,
  fillColor: Color(colorVerde).withOpacity(0.9),
  child: _cant==0 ? Icon(
    Icons.add,
    size: 20.0,
    color: Colors.white,
  ) : 
      Text("+ "+_cant.toString(),style: TextStyle(color: Colors.white),),


    
  padding: EdgeInsets.all(0.0),

  shape: CircleBorder(),
);
              
                    

}
_btnMasMenosCarrito(proveedor,rowCarrito){

return       Container(
  height: 27,
  child:RawMaterialButton(

  onPressed: () async{
   

           _cant=_cant-1;
            await setCarrito(widget.id,_cant);
           proveedor.notifyListeners();
       
  },
  elevation: 2.0,
  fillColor: Color(colorRojo).withOpacity(0.7),
  child:Icon(
    Icons.remove,
    size: 20.0,
    color: Colors.white,
  ) ,


    
  padding: EdgeInsets.all(0.0),

  shape: CircleBorder(),
));
              
                   

}
}