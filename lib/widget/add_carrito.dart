import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/blocks/auth_block.dart';
import 'package:Pide/pide_icons.dart';
import '../funciones_generales.dart';
import '../modelo.dart';
class AddCarrito extends StatefulWidget {
  final int id;
  final int stock;
  final int pedidoMaximo;
  final double priceB;
  final double priceD;
//COLOCAR EL REQUIRED AVERIGUAR EL MOTIVO
  const AddCarrito({Key key, this.id, this.stock, this.pedidoMaximo, this.priceB, this.priceD}) : super(key: key);
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
  return _cant==0 ? 
          
           
            _btnAgregarCarrito(proveedor,rowCarrito)
           :Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children:[
_btnMasMenosCarrito(proveedor,rowCarrito),
_cantidad(proveedor,rowCarrito),
            _btnMasCarrito(proveedor,rowCarrito)
             ]
           ) 
        ;   
}
final ButtonStyle flatButtonStyle = TextButton.styleFrom(
 // backgroundColor:  Color(colorVerde).withOpacity(0.9),
  backgroundColor:  Color(0xFFA2BF26),
  primary: Colors.white,

//textStyle: ,
 // minimumSize: Size(88, 36),
  padding: EdgeInsets.symmetric(horizontal: 16.0),
  
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    //borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.0),bottomRight: Radius.circular(10.0)),
  ),
);
_btnMasCarrito(proveedor,rowCarrito){
return RawMaterialButton(
  onPressed: () async{

          
           //double _total=_cant*widget.priceB;
             //  msjb("Total: "+_total.toString(),context);
           if(_cant>widget.pedidoMaximo && widget.pedidoMaximo!=0){

             msj("Máximo permitido.");
           }else{
              if(_cant>widget.stock){
                msj("Stock Agotado.");
              }else{
                 _cant=_cant+1;
                  await setCarrito(widget.id,_cant);
                  proveedor.notifyListeners();
                  String total=await proveedor.totalCarrito();
                  msjb("Total:  "+total,context);
              }
           }
  },
  elevation: 2.0,
  fillColor: Color(colorVerde).withOpacity(0.9),
  child: Icon(
    Pide.add,
    size: 20.0,
    color: Colors.white,
  ) ,


    
  padding: EdgeInsets.all(0.0),

  shape: CircleBorder(),
);
              
                    

}
_cantidad(proveedor,rowCarrito){
return Text(_cant.toString());
              
                    

}
_btnAgregarCarrito(proveedor,rowCarrito){
return Container(
  margin: const EdgeInsets.only(left: 5.0,bottom: 5,right: 5),
width: double.infinity,
  // height: double.infinity,
  child:TextButton(

  style: flatButtonStyle,
    onPressed: () async{

           _cant=_cant+1;
           //double _total=_cant*widget.priceB;
             //  msjb("Total: "+_total.toString(),context);
           if(_cant>widget.pedidoMaximo && widget.pedidoMaximo!=0){

             msj("Máximo permitido.");
           }else{
              if(_cant>widget.stock){
                msj("Stock Agotado.");
              }else{
                  await setCarrito(widget.id,_cant);
                  proveedor.notifyListeners();
                  String total=await proveedor.totalCarrito();
                  msjb("Total:  "+total,context);
              }
           }
  },
  child: Text('Agregar'),
));

                           

}
_btnMasMenosCarrito(proveedor,rowCarrito){

return       Container(
  height: 27,
  child:RawMaterialButton(

  onPressed: () async{
   

           _cant=_cant-1;
            await setCarrito(widget.id,_cant);
           proveedor.notifyListeners();
                 String total=await proveedor.totalCarrito();
                  msjb(total,context);
       
  },
  elevation: 2.0,
  fillColor: Color(colorRojo).withOpacity(0.7),
  child:Icon(
    Pide.remove,
    size: 20.0,
    color: Colors.white,
  ) ,


    
  padding: EdgeInsets.all(0.0),

  shape: CircleBorder(),
));
              
                   

}
}