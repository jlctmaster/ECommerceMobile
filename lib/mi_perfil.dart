import 'dart:convert';
import 'dart:io';

import 'package:biomercados/camara.dart';
import 'package:biomercados/take_picture_screen.dart';
import 'package:biomercados/widget/cedula.dart';
import 'package:biomercados/widget/sexo.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'config.dart';
import 'funciones_generales.dart';
import 'blocks/auth_block.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
class MiPerfil extends StatefulWidget {
  @override
  _MiPerfilState createState() => _MiPerfilState();
}

class _MiPerfilState extends State<MiPerfil> {
  final _formKey = GlobalKey<FormState>();
  int _radioValue1 = -1;
  int correctScore = 0;
  bool radioCargado = false;
  bool _cargando = false;
  String _msjErrorRadio = "";
  var campo = {
    'rif': '',
    'tipoRif': '',
    'sex': '',
    'name': '',
    'birthdate':''
  };
  File _image;

  final f = new DateFormat('dd-MM-yyyy hh:mm');
  bool primeraVez = false;
  DateTime selectedDate = DateTime.now().subtract(new Duration(days: 3600));
  TextEditingController _controller;
  String fecha;
  bool cargandoImagen=false;
  Future getImage() async {
    setState(() {
      cargandoImagen=true;
    });



    String base64Image;
    String url= await UrlLogin('actualizarFotoPerfil');
    var image = await ImagePicker.pickImage(source: ImageSource.camera,maxWidth: 500,
      maxHeight: 500,);
    if(image!=null) {
      base64Image = base64Encode(image.readAsBytesSync());
      //Map res=await upload("fotoPerfil",url,base64Image);
      Map res = await peticionPost(url, {"image": base64Image});
      print(res['data']);
      if (res != null) {
        saveData('perfil', res);
      }
    }

    setState(() {
      cargandoImagen=false;
      _image = image;

    });
  }

  upload(String fileName,url,base64Image) async {
    http.post(url, body: {
      "image": base64Image,
      "name": fileName,
    }).then((result) {
      return jsonDecode(result.body);

    }).catchError((error) {
      return null;
    });
  }


  @override
  Widget build(BuildContext context) {

    AuthBlock auth = Provider.of<AuthBlock>(context);
    return Scaffold(
        appBar: AppBarBio(context, 'Mi perfil'),
        body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  // Form(
                  // key: _formKey,

                  FutureBuilder(

                    future: _getUsuario(),
                    builder: (context, projectSnap) {
                      if (projectSnap.connectionState == ConnectionState.done) {
                        Map row = projectSnap.data;
                        if (radioCargado == false) {
                          campo = {
                            'rif': row['nro_rif'],
                            'tipoRif': row['nacionalidad'],
                            'sex': row['sex'],
                            'name': row['name'],
                            'birthdate': row['birthdate']
                          };

                          fecha = f.format(DateTime.parse(row['birthdate'])).split(' ')[0];
                        }else{
                          fecha = f.format(selectedDate.toLocal()).split(' ')[0];
                      }

                        _controller = new TextEditingController(text: primeraVez ? '' : fecha);
                        Map rowSelect = {
                          'nroCedula': row['nro_rif'],
                          'nacionalidad': row['nacionalidad']
                        };

                        radioCargado = true;
                        String urlImagen=BASE_URL+'/'+(row['avatar']);
                        return Padding(
                            padding: EdgeInsets.only(right: 30, left: 30),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Center(child: cargandoImagen==false ? IconButton(

                                    icon:

                                    CachedNetworkImage(
                                      imageUrl: urlImagen,
                                      imageBuilder: (context, imageProvider) => Container(
                                        width: 130.0,
                                        height: 130.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: imageProvider, fit: BoxFit.cover),
                                        ),
                                      ),
                                      placeholder: (context, url) => CircularProgressIndicator(),
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                    ),









                                    iconSize: 140,
                                    color: Color(colorVerde),
                                    onPressed: getImage,
                                    ) : CircularProgressIndicator(),

                                    ),
                                  Center(child: Text(row['email'],
                                    style: TextStyle(fontSize: 20),),),
                                  _campoTexto('name', 'Nombre y apellido',
                                      'todo', true, row['name']),
                                  Cedula(row: rowSelect,
                                    onChanged: _actualizarCedula,),

                                  _Calendario(),

                                  Sexo(campo: row['sex'],
                                    onChanged: _actualizarSexo,),

                                  _botonRojo()
                                ]
                            )
                        );
                      } else {
                        //print(" add   $projectSnap.data");
                        return Center(child: CircularProgressIndicator(),);
                      }
                    },

                  ),
                  // ),
                ],
              ),
            )
        )
    );
  }

  void _actualizarSexo(value) {
    print("Sexo actualizado " + value);
    campo['sex'] = value;
  }

  void _actualizarCedula(row) {
    print("Cedula actualizada " + row['nacionalidad'] + " " + row['nroCedula']);
    campo['rif'] = row['nroCedula'];
    campo['tipoRif'] = row['nacionalidad'];
  }

  _botonRojo() {
    return Padding(
        padding: const EdgeInsets.only(top: 25.0),
        child: Center(
          child: SizedBox(
            width: 150,
            height: 40,
            child: Consumer<AuthBlock>(builder:
                (BuildContext context, AuthBlock auth, Widget child) {
              return RaisedButton(
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                ),
                color: Color(0xFFe1251b),
                textColor: Colors.white,
                child: _cargando ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ) : Text('Guardar'),
                onPressed: () async {
                  await _guardarPerfil(campo);
                },
              );
            }),
          ),
        )
    );
  }

  _getUsuario() async {
   // String url = await UrlLogin('getPerfil');
   // Map res=await peticionGet(url);
    Map res= jsonDecode(await getData('perfil'));
    return res['data'][0];
  }

  _guardarPerfil(campo) async {
    String rif = campo['tipoRif'] + "-" + campo['rif'];
    String sex = campo['sex'];
    String name = campo['name'];
    String birthdate = campo['birthdate'];
    String url = await UrlLogin('actualizarPerfil');
    Map res= await peticionPost(url,{
      'rif':     rif,
      'sex':  sex,
      'name':      name,
      'birthdate':       birthdate,
    });
    await saveData('perfil',res);
    msj(res['msj_general']);
  }

  _campoTexto(String name, String txt_label, tipo, obligatorio, val) {
    TextInputType tipoKey;
    switch (tipo) {
      case 'correo':
        tipoKey = TextInputType.emailAddress;
        break;
      case 'numero':
        tipoKey = TextInputType.number;
        break;
      default:
        tipoKey = TextInputType.text;
    }
    //TextInputType emailAddress = TextInputType.emailAddress;
    return TextFormField(
      initialValue: val,
      validator: (value) {
        return validar(tipo, value, obligatorio);
      },
      onChanged: (value) {
        campo[name] = value;
      },
      keyboardType: tipoKey,
      decoration: InputDecoration(
        //hintText: 'Ingrese su nombre y apellido',
        labelText: txt_label,
      ),
      // focusNode: _focus,
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    DatePicker.showDatePicker(
        context,
        minDateTime:DateTime(1960, 8),
        maxDateTime:DateTime(2010,12),
        initialDateTime: selectedDate,
        locale: DateTimePickerLocale.es,
        //pickerMode: DateTimePickerMode.date,
        dateFormat: 'dd-MMMM-yyyy',
        onConfirm:(dateTime, selectedIndex) {
          setState(() {
            primeraVez=false;
            selectedDate = dateTime;
            _actualizarFecha(selectedDate.toLocal().toString().split(' ')[0]);
          });

        }
    );
  }
  _actualizarFecha(value){
    campo['birthdate']=value;
  }
  _Calendario() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          //Text("Fecha de nacimiento:",style: TextStyle(color: Colors.black54,fontSize: 16),),
          //Text("${selectedDate.toLocal()}".split(' ')[0]),
          TextFormField(
            readOnly: true,
            onTap: () => _selectDate(context),
            validator: (value) {
              return validar('fecha', value, true);
            },
            // onChanged: (a) => setState((){autovalidate_calendario=true;}) ,
            controller: _controller,

            decoration: InputDecoration(
              //hintText: 'Ingrese su nombre y apellido',
              labelText: "Fecha de nacimiento",
            ),
          ),

        ],
      ),
    );
  }

}