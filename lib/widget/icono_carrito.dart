import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/blocks/auth_block.dart';
import 'package:Pide/pide_icons.dart';
import '../funciones_generales.dart';

class IconoCarrito extends StatefulWidget {
  IconoCarrito({Key key}) : super(key: key);

  @override
  _IconoCarritoState createState() => _IconoCarritoState();
}

class _IconoCarritoState extends State<IconoCarrito> {
  @override
  Widget build(BuildContext context) {
    int cant=0;
    final proveedor = Provider.of<AuthBlock>(context);
    return Container(
       child: IconButton(
color: Color(colorVerde),
    icon:Stack(
      
      children: <Widget>[
      Icon(Pide.shopping_cart,),
      Padding(padding: EdgeInsets.only(top:8,left: 10),child:
    Container(
        width: 17.0,
        height: 17.0,
        
       
        
        // padding: const EdgeInsets.all(3.0),//I used some padding without fixed width and height
        decoration: new BoxDecoration(

          shape: BoxShape.circle,
          // You can use like this way or like the below line
          //borderRadius: new BorderRadius.circular(30.0),
          color: Color(colorRojo),
        ),
        child: Center(child:
        FutureBuilder(
            future: proveedor.cantCarrito(),
            builder: (context, projectSnap) {
              if(projectSnap.data==0){
                return Text('');
              }else {
                if(projectSnap.data!=null) {
                  if (int.parse(projectSnap.data) > 0) {
                    cant = int.parse(projectSnap.data);
                  } else {
                    cant = 0;
                  }
                }else{
                  cant=0;
                }
                return Text(cant.toString(), style: TextStyle(color: Colors.white,
                    fontSize: 10.0));
              }
            }
        )) //) You can add a Icon instead of text also, like below.
      //child: new Icon(Pide.arrow_forward, size: 50.0, color: Colors.black38)),
    )

    )],),
    //icon: btnCarrito(true),
    onPressed: () {
     
  if(cant>0) {
    //Navigator.pushNamed(context, '/cart',arguments: actualizar);
    Navigator.pushNamed(context, '/cart');
  }else{
    msj("Su carrito se encuentra vacio..");
  }
    },
  ),
    );
  }
 
}