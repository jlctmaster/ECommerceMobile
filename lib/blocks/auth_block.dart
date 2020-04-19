import 'package:flutter/material.dart';
import 'package:biomercados/auth/cambiarClavePublico.dart';
import 'package:biomercados/auth/confirmarCodRecuperacion.dart';
import 'package:biomercados/funciones_generales.dart';
import 'package:biomercados/models/user.dart';
import 'package:biomercados/services/auth_service.dart';

class AuthBlock extends ChangeNotifier {
  Map resJson;
  AuthBlock() {
    setUser();
  }
  AuthService _authService = AuthService();
  // Index
  int _currentIndex = 1;
  int get currentIndex => _currentIndex;
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
    _user = await _authService.getUser();
    isLoggedIn = _user == null ? false : true;
    notifyListeners();
  }

  login(UserCredential userCredential) async {
    loading = true;
    loadingType = 'login';
    bool res=await _authService.login(userCredential);
    if(res) {
      await setUser();
      await iniciarCarrito();
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