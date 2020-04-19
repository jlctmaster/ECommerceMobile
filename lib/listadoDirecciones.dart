import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'package:flutter/rendering.dart';
import 'funciones_generales.dart';

import 'blocks/modelo.dart';
import 'direcciones.dart';

class ListadoDirecciones extends StatefulWidget {
  @override
  _listadoDireccionesState createState() => _listadoDireccionesState();
}
class _listadoDireccionesState extends State<ListadoDirecciones> {
  final _formKey = GlobalKey<FormState>();
  final Modelo modelo = Modelo();
  String customerid;
  List data=null;
  bool cargado=false;
  bool _cargando=false;
  FocusNode _focus = new FocusNode();
  var campo={
    'cities_id':null,
  'address': '',
  'urb': '',
  'zip_code': '',
  'sector': '',
  'nro_home': '',
    'reference_point':''
  };
  bool loading=false;
bool _btnDireccionesCargando=false;

  _capturarRetroceso()async{//para actualizar la pagina esta despues que retrocedan de la pagina productos
    setState(() {

    });
    print("capturado retroceso");
  }
  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
        appBar: AppBar(
          title: Text('Mis direcciones'),
        ),
        body:SingleChildScrollView(
        child:SafeArea(
          child:
              Padding(
                padding: const EdgeInsets.only(left: 20.0,right: 20.00),
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                   topFormularios("Administre las direcciones para sus compras"),
                    _listadoDeDirecciones(),

                  ],
                ),
              ),
        )),
        floatingActionButton: FloatingActionButton(
      onPressed: (){
        Navigator.pushNamed(context, '/direcciones');
      },
      tooltip: 'Increment',
      child: Icon(Icons.add),
           backgroundColor: Colors.green,

    ),
    );


  }

  _bloqueDireccion(data,datab,index){
    String id=data['id'];
    String address=data['address'];
    String reference_point = data['reference_point'] ?? '';
    String nro_home = data['nro_home'] ?? '';
    String sector = data['sector'] ?? '';
    String urb = data['urb']?? '';
    String zip_code = data['zip_code']?? '';
    String cities_id = data['cities_id']?? '';
    String states_id = data['states_id']?? '';
    String regions_id = data['regions_id']?? '';
    return ListTile(
      title: Text(
        address,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),

      subtitle:Container(
                child: Text("Estado "+data['st_name']+", municipio "+data['re_name']+", parroquia "+data['ci_name']+",Urb: "+urb+", Sector: "+sector+", Nro. "+nro_home+", Punto de referencia: "+reference_point,
                )),

      trailing:
      IconButton(icon: Icon(Icons.highlight_off, size: 35.0),onPressed: (){


        _showAlert("¿Esta seguro de eliminar la dirección: $address?",datab,index);
        },color: Color(colorRojo),)
      ,
      onTap: (){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Direcciones(id: id,address: address,urb:urb,nro_home: nro_home,reference_point: reference_point,sector: sector,zip_code: zip_code,cities_id:cities_id,states_id: states_id,regions_id: regions_id,),
        ),
      ).then((val)=>{_capturarRetroceso()});


      },
    );
  }
  void _dialogueResult(String value){
    if(value=='si'){
      msj("si");
      Navigator.pop(context);
    }else {
      Navigator.pop(context);
    }
  }
  void _showAlert(String value,datab,index) {
    showDialog(
        context: context,
        builder: (_) =>
        new AlertDialog(
          title: new Text('Confirmación'),
          content: new Text(value,
            style: new TextStyle(fontSize: 25.0),),
          actions: <Widget>[
            new FlatButton(onPressed: () {
              Navigator.pop(context);
            }, child: new Text('NO')),
            new FlatButton(onPressed: () async {
             modelo.eliminarDireccion(datab[index]['id']);
              setState(() {
                datab.removeAt(index);
              });
              Navigator.pop(context);

            }, child: Text('SI')),
          ],
        )
    );
  }

  _listarDirecciones(data){

    if(data!=null) {
      return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: _bloqueDireccion(data[index],data,index),
          );
        },
        padding:EdgeInsets.only(bottom: 70.0),
      );
    }else {
      return Text(
        "No tienes direcciones, agregue una donde desee recibir sus compras.",
        style: TextStyle(fontSize: 20,),
        textAlign: TextAlign.justify,
      );
    }
  }
_listadoDeDirecciones(){

    return Column(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top:20),),
  FutureBuilder(
  future: modelo.getAdreess(),
  builder: (context, projectSnap) {
  if (projectSnap.connectionState == ConnectionState.done) {
  return _listarDirecciones(projectSnap.data);

  }else {
  return CircularProgressIndicator();
  }
  },

  ),

    ],);
}

}

