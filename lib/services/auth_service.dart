import 'dart:convert';
import '../config.dart';
import '../funciones_generales.dart';
import '../models/user.dart';



class AuthService {
  // Create storage
  Future<bool> login(UserCredential userCredential) async {
    //var status = await Permission.storage.status;

    Map res=Map();
    String password=userCredential.password;
    String email= userCredential.usernameOrEmail;
    String url='$BASE_URL/api_rapida.php?evento=theBest&email=$email&password=$password';
    res=await peticionGetZlib(url);

    if(res['success']==true){
      await setUser(res['data']['usuario']['data']);
      await setData(res['data']);
      return true;
     // setUser(jsonEncode(res['data']['usuario']['data']));
     // return true;
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

  setUser(Map value) async {
    await saveData('user',value);
  }
  setData(Map value) async {
    value.forEach(await actualizarTodo);
  }

  void actualizarTodo(key, value) async{
    await saveData(key,value);
  }

  getUser() async {
    String user = await getData('user');
    if (user != null) {
 
      return jsonDecode(user);
    }
  }
  logout() async {
    await delData('user');
  }
}