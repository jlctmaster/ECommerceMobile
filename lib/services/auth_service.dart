import 'dart:convert';
import 'package:biomercados/config.dart';
import 'package:biomercados/funciones_generales.dart';
import 'package:biomercados/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';




class AuthService {
  final storage = FlutterSecureStorage();
  // Create storage
  Future<bool> login(UserCredential userCredential) async {
    Map res=Map();
    String password=userCredential.password;
    String email= userCredential.usernameOrEmail;
    String url='$BASE_URL/api_rapida.php?evento=loginMovil&email=$email&password=$password';
    res= await peticionGet(url);


    if(res['success']==true){
      setUser(jsonEncode(res));
      return true;
    }else{
      msj(res['msj_general']);
      return false;
    }

  }

  Future<Map> register(User user) async {
    String url='$BASE_URL/api_rapida.php?evento=registrarUsuario';
    String rifCompleto=user.tipo['tipoRif']+"-"+user.tipo['rif'];


    return await peticionPost(url, {
      'email':     user.tipo['email'],
      'password':  user.password,
      'name':      user.tipo['name'],
      'rif':       rifCompleto,
      'sex':       user.tipo['sex'],
      'tlf':       user.tipo['tlf'],
      'birthdate':user.tipo['birthdate']
    });


  }
  Future<Map> enviarCodRecuperacion(User user) async {
    String url='$BASE_URL/api_rapida.php?evento=enviarCodRecuperacion&email='+user.email;
    return await peticionGet(url);
  }
  Future<Map> confirmarCorreo(User user) async {
    String url='$BASE_URL/api_rapida.php?evento=confirmarCorreo';
    return await peticionPost(url, {
      'email':     user.tipo['email'],
      'codigoCorreo':     user.tipo['codigoCorreo'],
    });
  }
  Future<Map> cambiarClavePublico(User user) async {
    String url='$BASE_URL/api_rapida.php?evento=cambiarClavePublico';
    return await peticionPost(url, {
      'email':     user.tipo['email'],
      'codigoCorreo':     user.tipo['codigoCorreo'],
      'password':user.password,
    });
  }
  Future<Map> confirmarCodRecuperacion(User user) async {
    String url='$BASE_URL/api_rapida.php?evento=confirmarCodRecuperacion';

    return await peticionPost(url, {
      'email':     user.tipo['email'],
      'codigoCorreo':     user.tipo['codigoCorreo'],
    });
  }

  setUser(String value) async {
    await storage.write(key: 'user', value: value);
  }

  getUser() async {
    String user = await storage.read(key: 'user');
    if (user != null) {
      return jsonDecode(user);
    }
  }
  logout() async {
    await storage.delete(key: 'user');
  }
}