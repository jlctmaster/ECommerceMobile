import 'dart:convert';

import 'package:flutter/material.dart';
import '/main.dart';
import '../funciones_generales.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthBlock with ChangeNotifier {
  Map resJson;
  AuthBlock() {
    setUser();
  }
  AuthService _authService = AuthService();
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
  getCarritob({contexto})async{
    return jsonDecode(await getData('carrito'));
  }
  cantCarrito() async{
    Map carrito=await getCarrito();
    Map precios=jsonDecode(await getData('listarPrecios'))['data'];
    Map productos;
    int cant=0;
    double totalD=0.00;
    double totalB=0.00;
    if(carrito['productos']!=null){
//print(precios);
      productos=carrito['productos'];
      productos.forEach((key, value) {
        if(value>0){

         
          cant+=value;
           if(precios[key]!=null){
            totalD+=double.parse(precios[key]['d'])*value;
            totalB+=double.parse(precios[key]['b'])*value;
          }
        }
        
       
      });
     // print("TOTAL:"+totalD.toString());
      await saveDataNoJson('total', "$totalD / $totalB");
     // msj(total.toString());
      return cant.toString();
    }else{
      return "0";
    }
  }

    totalCarrito() async{
    Map carrito=await getCarrito();
    Map precios=jsonDecode(await getData('listarPrecios'))['data'];
    Map productos;
    int cant=0;
    double totalD=0.00;
    double totalB=0.00;
    if(carrito['productos']!=null){
//print(precios);
      productos=carrito['productos'];
      productos.forEach((key, value) {
        if(value>0){

         
          cant+=value;
           if(precios[key]!=null){
            totalD+=double.parse(precios[key]['d'])*value;
            totalB+=double.parse(precios[key]['b'])*value;
          }
        }
        
       
      });
      return formatDolar.format(totalD)+" / "+formatBolivar.format(totalB);
    }else{
      return "0";
    }
  }







  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  // Loading
  bool _loading = false;
  String _loadingType;
  bool get loading => _loading;
  String get loadingType => _loadingType;
  set loading(bool loadingState) {
    _loading = loadingState;
    notifyListeners();
  }
  set loadingType(String loadingType) {
    _loadingType = loadingType;
    notifyListeners();
  }
  // Loading
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  set isLoggedIn(bool isUserExist) {
    _isLoggedIn = isUserExist;
    notifyListeners();
  }

  // user
  Map _user = {};
  Map get user => _user;
  setUser() async {
    //_user = await _authService.getUser();

    _user = await _authService.getUser();
    isLoggedIn = _user == null ? false : true;
    notifyListeners();
  }

  login(UserCredential userCredential) async {
    loading = true;
    loadingType = 'login';
    bool res=await _authService.login(userCredential);
    loading = false;
    if(res) {
      await saveDataNoJson('noLogin', 'false');
      await setUser();
      //await iniciarCarrito();
      return true;
    }else{
      return false;
    }
    //if(isLoggedIn)
    loading = false;
  }
  Future<Map> cambiarClavePublico(User user) async {
    loading = true;
    loadingType = 'cambiar_clave_publico';
    resJson= await _authService.cambiarClavePublico(user);
    loading = false;
  }
  Future<Map> register(User user) async {
    loading = true;
    loadingType = 'register';
    resJson= await _authService.register(user);
    loading = false;
  }
  Future<Map> recuperar(User user) async {
    loading = true;
    loadingType = 'recuperar';
    resJson= await _authService.enviarCodRecuperacion(user);
    loading = false;
  }

  Future<Map> confirmarCorreo(User user) async {
    loading = true;
    loadingType = 'confirmar_correo';
    resJson= await _authService.confirmarCorreo(user);
    loading = false;
  }
  Future<Map> confirmarCodRecuperacion(User user) async {
    loading = true;
    loadingType = 'confirmarCodRecuperacion';
    resJson= await _authService.confirmarCodRecuperacion(user);
    loading = false;
  }
  logout() async {
    await _authService.logout();
    isLoggedIn = false;
    notifyListeners();
  }
}