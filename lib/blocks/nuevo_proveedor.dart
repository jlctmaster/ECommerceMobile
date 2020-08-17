import 'dart:convert';

import 'package:flutter/material.dart';
import '../funciones_generales.dart';

class NuevoProveedor with ChangeNotifier {
  Map resJson;
 
  // Index
  int _currentIndex = 1;
  int get currentIndex => _currentIndex;

  int _count = 0;
  int get count => _count;
  void incrementCarrito() {
    _count++;
    notifyListeners();
  }
  agregarCarrito(id,_cant) async{
    setCarrito(id,_cant);
    notifyListeners();
  }
  actualizar(){
    notifyListeners();
  }
  getCarritob()async{
    return jsonDecode(await getData('carrito'));
  }
  cantCarrito() async{
    Map carrito=await getCarrito();
    Map productos;
    int cant=0;
    if(carrito['productos']!=null){

      productos=carrito['productos'];
      productos.forEach((key, value) {
        if(value>0){
          cant+=value;
        }
      });

      return cant.toString();
    }else{
      return "0";
    }
  }







  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }



}