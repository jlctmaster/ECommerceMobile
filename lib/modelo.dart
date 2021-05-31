import 'dart:convert';

import 'config.dart';
import 'funciones_generales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class ModeloTime{
  Map res=Map();
  String evento;
  String url;

  String titulo;

  bool listandoProductos=false; //para evitar que mientras espera el await consulte mil veces
  Future listarProductosIA(context) async {

    evento='listarProductosIA';
    url = await UrlLogin(evento);
    await procesarEvento('get',120);
    if(res['success']==true) {
      return res['data'];
    }else{
      return null;
    }
  }
  Future<void> verificarSesionN(context) async {
    await new Future.delayed(const Duration(seconds: 3));
    evento='verificarSesion';
    url=await UrlLogin(evento);
    await procesarEvento('get',240);
    if(res['success']!=null) {
      if (res['success']) {
        await delData('user');
        await _setData(3);
        //Phoenix.rebirth(context);
        Navigator.pushNamedAndRemoveUntil(context,'/', (Route<dynamic> route) => false);
       // print("SESSION INACTIVA");
      } else {
       // print("SESSION ACTIVA");
      }
    }

  }

  Future listarProductos() async {

      titulo = await getTitulo();
      evento = await getEvento();
      url = await UrlNoLogin(evento);
      if(evento=='listarFavoritos') {
        res = await peticionGetZlib(url);
      }else {
        await procesarEvento('get', 120);
      }

      return res;

  }
  Future listarCategorias() async{
    evento='listarCombos';
    url=await UrlLogin(evento);
    await procesarEvento('get', 480);
    return res;
  }
  Future listarPrecios() async{
    evento='listarPrecios';
    url=UrlNoLogin(evento);
    await procesarEvento('get', 480);
    return res;
  }
  Future listarCombos() async{
    evento='listarCombos';
    url=await UrlLogin(evento);
    await procesarEvento('get', 120);
    return res;
  }

  Future listarPublicidad(String tipo) async{
    evento='listarPublicidad&tipo='+tipo;
    url=UrlNoLogin(evento);
    print(url);
    await procesarEvento('get', 120);
    return res;
  }
  borrarRecordarClave() async {
    Map data = Map();
    await saveData('recuerdo',data);
  }
  Future listarPublicidadFinal() async{
    evento='listarPublicidadFinal';
    url=await UrlLogin(evento);
    await procesarEvento('get', 120);
    return res;
  }
  Future listarPublicidadMedio() async{
    evento='listarPublicidadMedio';
    url=await UrlLogin(evento);
    await procesarEvento('get', 120);
    return res;
  }
  Future listarProductosNuevo(String tipo) async {

    switch(tipo){
      case 'listarProductosConPromocion':
        evento='listarProductosConPromocion';
        break;
      case 'listarProductos':
        evento='listarProductos';
        break;
      case 'compraFacil':
        evento='listarProductos';
        break;
      case 'ia':
        evento='listarProductosIA';
        break;
      case 'promocion':
        evento='listarProductosPromocion';
      break;
      default:
        titulo = await getTitulo();
        evento = await getEvento();
    }
    url = UrlNoLogin(evento);
    

    if(evento=='listarFavoritos') {
      url = await UrlLogin(evento);
      res = await peticionGetZlib(url);

    }else {
      await procesarEvento('get', 120);
    }
    print(res);
    return res;

  }

  horasDisponiblesEntrega() async {
    evento='horasDisponiblesEntrega';
    url=UrlNoLogin(evento);
    await procesarEvento('get', 120);
    if (res['success']==true) {
      return res['data'];
    }else{
      return false;
    }
  }


  listarMetodosDePago() async {
    evento='listarMetodosDePago';
    url=await UrlLogin(evento);
    await procesarEvento('get', 240);
    if (res['success']==true) {
      return res['data'];
    }else{
      msj(res['msj_general']);
    }
  }

  listarBancosdelMetododePago(payment_methods_id) async {
    evento='listarBancosdelMetododePago&payment_methods_id=$payment_methods_id';
    url=await UrlLogin(evento);
    await procesarEvento('get', 240);
    if (res['success']==true) {
      return res['data'];
    }else{
      //print("aaaaaaaaaaaaaaaaaaaaaaa"+res['msj_general']);
      //msj(res['msj_general']);
      return null;
    }
  }
  envio() async {
    evento='recargoEnvio';
    url=UrlNoLogin(evento);
    await procesarEvento('get', 240);
    return res;
  }



  procesarEvento(tipo,int tiempoActualizacion) async {
    if(tipo=='get') {
      if (await getTiempo(tiempoActualizacion)) {
        //print("REAL : "+evento);
        res=await peticionGetZlib(url);
        if(res['success']==true) {
          await _setData(tiempoActualizacion);
        }
      }else{
       // print("CACHE : "+evento);
        res=jsonDecode(await getData('data_$evento'));
      }
    }
  }
  getTiempo(tiempoActualizacion) async {

    DateTime time=DateTime.now();

    String tiempo=await getData('tiempo_$evento');
    if(tiempo!=null) {
   
      DateTime tiempoViejo= DateTime.parse(tiempo);
      if (time.isAfter(tiempoViejo)) {
        return true;
      } else {
        return false;
      }
    }else{

      await _setData(tiempoActualizacion);

      return true;
    }
  }
  _setData(tiempoActualizacion) async {
    DateTime time=DateTime.now().add(Duration(seconds: tiempoActualizacion));

    await saveData('data_$evento',res);

    await saveDataNoJson('tiempo_$evento',time.toString());
    return true;
  }
}