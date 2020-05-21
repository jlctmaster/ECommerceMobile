import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:async/async.dart';
import 'package:biomercados/blocks/auth_block.dart';
import 'package:biomercados/widget/cant_carrito.dart';
import 'package:biomercados/widget/cant_carritob.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'config.dart';
import 'package:shared_preferences/shared_preferences.dart';

  int colorVerde=0xff28b67a;
  int colorVerdeb=0xff80bc00;
  int colorAmarillo=0xffeba900;
  int colorRojo=0xffe1251b;
  btnAtras(context){
    return Transform.rotate(
      angle:  180 * pi/180,
      child: IconButton(
        padding: const EdgeInsets.only(bottom: 6.00),
        icon: Icon(Icons.play_circle_filled,size: 40,),
        color: Color(colorAmarillo),
        onPressed: () {
          Navigator.pop(context);
          // Navigator.pushNamed(context, '/');

        },
      ),
    );
  }
btnAtras3(context){
  return Transform.rotate(
    angle:  180 * pi/180,
    child: IconButton(

      icon: Icon(Icons.play_circle_filled,size: 35,),
      color: Color(colorAmarillo),
      onPressed: () {
        Navigator.pop(context);
        // Navigator.pushNamed(context, '/');

      },
    ),
  );
}
  textoTop(texto){
    return Expanded(
      child:
      Container(
        margin: const EdgeInsets.only(right: 40.0,top:5),
        child: Center(
            child: Text(texto,style:TextStyle(color: Color(colorRojo),fontSize: 20,fontWeight: FontWeight.bold))
        )
        ,
      ),
    );
  }
  textoTop2(texto){//se cambio para el nuevo diseño esta enla orden
    return
Center(
            child: Text(texto,style:TextStyle(color: Color(colorVerde),fontSize: 20))
        );

  }
textoTop3(texto){
  return
    //Center(
        Text(texto,style:TextStyle(color: Color(colorRojo),fontSize: 20,fontWeight: FontWeight.bold));
   // );

}
rUrl(String value){
    return value.replaceAll("\\", "/");
}
  logoBio(){
    return Image (image: AssetImage("assets/images/logo_peque.png"), height: 130.00,);
  }
  imagenFondo(){
    return BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/fondo_login.png"),
            fit: BoxFit.cover,
        )
    );
  }
  espaciadoTop(){
    return Padding(
      padding: const EdgeInsets.only(
        left: 40,
        top: 20,
        right: 40,
        bottom: 0,
      ),
    );
  }
  topFormularios(String texto){

    return Center(child: Container(
        padding: EdgeInsets.only(top:30),
        child:Text(texto,textAlign: TextAlign.center,style: TextStyle(color: Color(0xff28b67a), fontSize: 18.00))
    ),);
  }
topCompletoLogin(context,String texto){
  return Row(

    children: [
      btnAtras(context),
      textoTop(texto),
    ],
  );
}

topLoginB(String texto){
    return Column(
      children: <Widget>[

  logoBio(),
  Padding(padding: const EdgeInsets.only(bottom: 30.0),),
  Center(child: Text(texto, style: TextStyle(color:Color(colorRojo), fontSize: 22, fontWeight: FontWeight.bold),),),
  Padding(padding: const EdgeInsets.only(bottom:20.0),),
      ],
    );
}
subTituloLogin(String texto){
  return Text(texto,textAlign: TextAlign.center,style: TextStyle(color: Color(0xff28b67a), fontSize: 18.00),);
}
getRecordarClave() async {
   Map recuerdo=Map();
   if(await getData('recuerdo')==null){
     recuerdo=null;
   }else{
    recuerdo=jsonDecode(await getData('recuerdo') ?? []);
   }
   
   return recuerdo;
}

setRecordarClave(String correo,String clave) async {
    Map recuerdo=Map();
    recuerdo['si']=true;
    recuerdo['correo']=correo;
    recuerdo['clave']=clave;
    await saveData('recuerdo',recuerdo);
}
peticionGetZlib(url) async {
  var data;
  try {
    final response = await http.get(
        url, headers: {"Accept": "application/json"}).timeout(
        Duration(seconds: 20));

    try {
      var bytes = response.bodyBytes;
      var inflated = zlib.decode(bytes);
     data = utf8.decode(inflated);

    }catch(_){
      data=response.body;
    }

    if (response.statusCode == 200 || response.statusCode ==409) {
      return jsonDecode(data);
    } else {
      return msjIntentedeNuevo();
    }
  } catch (_) {
    return msjConexion();
  }
}
cerrar_sesion(context){
  //ModalRoute.withName('/');
  //Phoenix.rebirth(context);

  Navigator.pushNamedAndRemoveUntil(context,'/', (Route<dynamic> route) => false);
}
getData(key) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
  //return jsonDecode(await storage.getItem(key));
}
delData(key) async{
SharedPreferences prefs = await SharedPreferences.getInstance();
await prefs.remove(key);
}
delIdData(key,id) async {
  Map l=await getData(key);
  List lista=l['data'];
  List listaNueva=List();
  int cant=lista.length;
  for(int i=0; i<cant; i++){
    if(lista[i]['id']!=id){
      listaNueva.add(lista[i]);
    }
  }
  l['data']=listaNueva;

  await saveData(key,l);
  //await storage.setItem(key,jsonEncode(l));
}
saveData(key,Map nuevaData) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //await storage.setItem(key,jsonEncode(nuevaData));
  await prefs.setString(key, jsonEncode(nuevaData));
}
saveDataNoJson(key,nuevaData) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //await storage.setItem(key,jsonEncode(nuevaData));
  await prefs.setString(key, nuevaData);
}
peticionGet(url) async {
  try {
    final response = await http.get(
        url, headers: {"Accept": "application/json"}).timeout(
        Duration(seconds: 20),);
    print(response.body);
    if (response.statusCode == 200 || response.statusCode ==409) {
      return jsonDecode(response.body);
    } else {
      return msjIntentedeNuevo();
    }
  } catch (_) {
    return msjConexion();
  }
}
AppBarBio(context,texto){
  return AppBar(
    leading: leadingBio(context),
    //iconTheme: IconThemeData(color: Colors.red),
    backgroundColor: colorAppBarBio(),
    title: titleBio(texto),//Text("Orden Nro."+widget.id,style: TextStyle(color: Colors.red),),
elevation: 0,
  );
}
colorAppBarBio(){
    return Colors.white;
}
leadingBio(context){
    return btnAtras3(context);
}
titleBio(texto){
    return textoTop3(texto);
}
iconoCarrito(context,actualizar){
  final proveedor = Provider.of<AuthBlock>(context);
    int cant=0;
  return IconButton(
color: Color(colorVerde),
    icon:Stack(children: <Widget>[Icon(Icons.shopping_cart),Padding(padding: EdgeInsets.only(top:8,left: 14),child:
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
                    fontSize: 14.0));
              }
            }
        )) //) You can add a Icon instead of text also, like below.
      //child: new Icon(Icons.arrow_forward, size: 50.0, color: Colors.black38)),
    )

    )],),
    //icon: btnCarrito(true),
    onPressed: () {
  if(cant>0) {
    Navigator.pushNamed(context, '/cart',arguments: actualizar);
  }else{
    msj("Su carrito se encuentra vacio..");
  }
    },
  );
}
btnCarrito(bool actualizar){
  return Stack(children: <Widget>[Icon(Icons.shopping_cart),Padding(padding: EdgeInsets.only(top:8,left: 14),child: CantCarrito(actualizar: actualizar,))],);
  //return Icon(Icons.shopping_cart);

}
btnCarritob(){
  return Stack(children: <Widget>[Icon(Icons.shopping_cart),Padding(padding: EdgeInsets.only(top:8,left: 14),child: CantCarritob())],);
  //return Icon(Icons.shopping_cart);

}
roundUp(double value){
    return double.parse((value+0.004).toStringAsFixed(2));
}
roundDown(double value){
  return double.parse((value-0.005).toStringAsFixed(2));
}

peticionPost(url, Map<String, String> body) async {
  try {
    final response = await http.post(
        url, headers: {"Accept": "application/json"},body:body).timeout(
        Duration(seconds: 20));
    print(response.body);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  } catch (_) {
    return msjConexion();
  }
}

msjConexion(){
  Map data={
    'success':false,
    'msj_general':"Verifique su conexión a internet."
  };
 // msj("Verifique su conexión a internet, intente de nuevo.");
  return data;
}
msjIntentedeNuevo(){
  Map data={
    'success':false,
    'msj_general':"Disculpe intente nuevamente."
  };
  // msj("Verifique su conexión a internet, intente de nuevo.");
  return data;
}
msj(String msj){
  Fluttertoast.showToast(
      msg: msj,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      fontSize: 16.0);
}
msjb(String msj,context){
  Scaffold.of(context)
      .showSnackBar(SnackBar(content: Text(msj)));
}
noInternet(){
    return Center(child: Text("Verifique su conexión a internet",style: TextStyle(color: Colors.red),),);
}
validar(tipo,String value,bool obligatorio){
  Map exp;
  String val=value.trim();
  exp=patron_validacion(tipo);
  String msjObligatorio='Campo obligatorio';
  if(obligatorio){
    if (val.isEmpty) {
      return msjObligatorio;
    }
  }else if (val.isEmpty) {
    return null;
  }
  if(!RegExp(exp['patron']).hasMatch(value)){
      return exp['msj'];

  }else{
    return null;
  }

}



patron_validacion(tipo){
    Map v;
    v={
      'texto': {
      'patron':r"^[a-zA-Z ñÑáéíóúÁÉÍÓÚ\s]+$",
      'msj':"Solo se acepta letras"
    },
      'texto_numero':{
      'patron':r"^[a-zA-Z0-9 ñÑáéíóúÁÉÍÓÚ\s]+$",
        'msj':"Solo se acepta texto y/o numeros enteros"
      },
      'texto_especial':{
        'patron':r"^[a-zA-Z., ñÑáéíóúÁÉÍÓÚ\s]+$",
        'msj':"Solo se acepta letras, comas y puntos"
      },
      'numero':{
        'patron':r"^[\d]+$",
        'msj':"Solo se aceptan numeros enteros",
      },
      'float':{
        'patron':r"^[\d.,]+$",
        'msj':"Solo se aceptan numeros enteros o con decimales"
      },
      'thousand':{
        'patron':r"^\$?(([1-9](\d*|\d{0,2}(,\d{3})*))|0)(\.\d{1,2})?$",
        'msj':"Use punto (.) para decimales"
      },
      'nro_venezuela':{
        'patron':r"^\$?(([1-9](\d*|\d{0,2}(\.\d{3})*))|0)(,\d{1,2})?$",
        'msj':"Use coma (,) para decimales"
      },
      'correo':{
        'patron':r"([0-9a-zA-Z]+[-._+&])*[0-9a-zA-Z]+@([-0-9a-zA-Z]+[.])+[a-zA-Z]{2,6}",
        'msj':"Debe introducir un correo electronico valido Ej: leonardo@gmail.com"
      },
      'todo':{
        'patron':r"[^\s]",
        'msj':"No deje espacios en blanco"
      },
      'url':{
        'patron':r"^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \?=.-]*)*\/?$",
        'msj':"Debe introducir una URL valida Ej: http://leonardo.com"
      },
      'tlf':{
        'patron':r"^\+?\d{1,3}?[- .]?\(?(?:\d{2,3})\)?[- .]?\d\d\d[- .]?\d\d\d\d$",
        'msj':"Debe introducir un telefono valido Ej: 0255-1111222"
      },
      'ip':{
        'patron':r"\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b",
        'msj':"Debe introducir una ip valida Ej: 192.168.1.1"
      },
      'fecha':{
        'patron':r"^(?:(?:0?[1-9]|1\d|2[0-8])(\/|-)(?:0?[1-9]|1[0-2]))(\/|-)(?:[1-9]\d\d\d|\d[1-9]\d\d|\d\d[1-9]\d|\d\d\d[1-9])$|^(?:(?:31(\/|-)(?:0?[13578]|1[02]))|(?:(?:29|30)(\/|-)(?:0?[1,3-9]|1[0-2])))(\/|-)(?:[1-9]\d\d\d|\d[1-9]\d\d|\d\d[1-9]\d|\d\d\d[1-9])$|^(29(\/|-)0?2)(\/|-)(?:(?:0[48]00|[13579][26]00|[2468][048]00)|(?:\d\d)?(?:0[48]|[2468][048]|[13579][26]))$",
        'msj':"Debe introducir una fecha valida Ej: 29-02-1988"
      },
      'pass':{
        'patron':r"(?!^[0-9]*$)(?!^[a-zA-Z]*$)^([a-zA-Z0-9]{8,14})$",
        'msj':"Debe introducir una contraseña que contenga entre 8 a 10 caracteres, estos deben contener letras y numeros"
      },
      'passb':{
        'patron':r"(?!^[0-9]*$)(?!^[a-zA-ZñÑáéíóúÁÉÍÓÚ\-!/#$%&()=?¡{}[\]_.:,;*+@<>|°¬]*$)^([a-zA-Z0-9ñáéíóúÁÉÍÓÚ\-!/#$%&()=?¡{}[\]_.:,;*+@<>|°¬]{8,})$",
        'msj':"Minimo 8 caracteres, estos deben contener letra(s) y numero(s)"
      }

    };
  return v[tipo];
}
setCantPago(nroOrden) async {
  Map usuario= await getUser();
  int cantPago=usuario['cantPago'][nroOrden] ?? 0;
  usuario['cantPago'][nroOrden]=cantPago+1;
  await saveData('user',usuario);
}

getCantPago(nroOrden) async {
  Map usuario= await getUser();
  int cantPago=0;
 // print(usuario['cantPago'][nroOrden]);
if(usuario['cantPago']==null){
  return cantPago;
}else {
  cantPago = usuario['cantPago'][nroOrden] ?? 0;
  return cantPago;
}

}
setEvento(evento,String titulo) async {
  await saveDataNoJson('evento', evento);
  await saveDataNoJson('titulo', titulo);
}
getEvento() async {
  String evento = await getData('evento');
  return evento;
}
getTitulo() async {
  String titulo = await getData('titulo');
  return titulo;
}
delEvento()async {
  await delData('evento');
}
delTitulo()async {
  await delData('titulo');
}

_crearCarrito(idUsuario)async{
  delCarrito();
Map carrito= Map();
carrito['estado']=idUsuario;
carrito['productos']=null;

  await saveData('carrito',carrito);
print("Carrito creado");
}
iniciarCarrito() async {
  //delCarrito();
    Map usuario= await getUser();
    int idUsuario=int.parse(usuario['id']);

    print("iniciando carrito para: $idUsuario");

  String res= await getData('carrito');
  Map map;
  if(map!=null){
    map=jsonDecode(res);
    if(map['estado']==idUsuario){
      print("Carrito ya existe");
      return true;
    }else{
      await _crearCarrito(idUsuario);

      return true;
    }
  }else{
    await _crearCarrito(idUsuario);
    return true;
  }
}
setCarrito(int idProducto,int cant) async{
  Map carrito= Map();
  print("Agregado al carrito $idProducto $cant");


  carrito= await jsonDecode(await getData('carrito'));
  print(carrito);
  if(carrito['productos']==null){
    Map productos= Map();
    productos["$idProducto"]=cant;
    carrito['productos']=productos;
  }else{
    Map productos =carrito['productos'];
    productos["$idProducto"]=cant;
    carrito['productos']=productos;
  }
print("Cargo");

  await saveData('carrito',carrito);

}

setOtroCarrito(String id,String valor) async{ //Ejemplo, metodos de pago, direccion y hora de entrega
  print("Agregado al carrito Otro iten: $id => $valor");
  Map carrito= Map();
  carrito= jsonDecode(await getData('carrito'));
  carrito[id]=valor;
  await saveData('carrito',carrito);

}

getCarrito()async{
  return jsonDecode(await getData('carrito'));
  }
delCarrito()async {
  await delData('carrito');
}
class Customer {
  int id;
  int cant;

  Customer(this.id, this.cant);

  @override
  String toString() {
    return '{ ${this.id}, ${this.cant} }';
  }
}
colorStatus(os_id){

    Color color;
  switch(os_id){
    case '1':
      color=Color(colorAmarillo);
      break;
    case '3':
    case '9':
    case '12':
    case '11':
      color=Color(colorRojo);
      break;
    case '8':
      color=Color(colorVerdeb);
      break;
    default:
      color=Color(colorVerde);
  }
  return color;
}
InkWell link(String texto,String link,context){
  return InkWell(
    child: Text(texto, style: TextStyle(fontWeight: FontWeight.bold ,color: Colors.green)),
    onTap: () {

        Navigator.pushNamed(context, link);
    },
  );
}

final formatDolar = new NumberFormat.simpleCurrency(locale: 'en_US',decimalDigits: 2);
final formatBolivar = new NumberFormat.simpleCurrency(locale: 'es_ES',name: 'Bs',decimalDigits: 2);