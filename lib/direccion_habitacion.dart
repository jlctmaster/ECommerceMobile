import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'funciones_generales.dart';

import 'blocks/modelo.dart';
class DireccionHabitacion extends StatefulWidget {
  final String id;
  final String cities_id;
  final String address;
  final String urb;
  final String zip_code;
  final String sector;
  final String nro_home;
  final String regions_id;
  final String states_id;
  final String reference_point;

  const DireccionHabitacion({Key key, this.id, this.cities_id, this.address, this.urb, this.zip_code, this.sector, this.nro_home, this.reference_point, this.regions_id, this.states_id}) : super(key: key);


  @override
  _direccionHabitacionState createState() => _direccionHabitacionState();
}

class _direccionHabitacionState extends State<DireccionHabitacion> {

  final _formKey = GlobalKey<FormState>();
  final Modelo modelo = Modelo();
  String vali;
  String _value;
  String _cities_id;
  String customerid;
  List data=null;
  bool cargado=false;
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
  var _regions_id;

  var _states_id;
bool _avisoObligatorioState=false;
bool _avisoObligatorioRegions=false;
bool _avisoObligatorioCities=false;
bool _widgetCities=true;
bool _widgetRegions=true;

  bool _buenoStates=false;



  Future _habitacion;
  @override
  void initState() {
    _habitacion =  getData('addressHabitacion');
    super.initState();
  }






  @override
  Widget build(BuildContext context) {

    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        appBar: AppBarBio(context, 'Dirección de habitación'),
        body:SingleChildScrollView(
        padding: EdgeInsets.only(bottom: bottom),
        reverse: true,
        child:SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20.0,right: 20.00),
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                   topFormularios("Agrege su dirección de habitación"),
                    Padding(padding: EdgeInsets.all(10.00),),
                    Form(
                        key: _formKey,

                            child: FutureBuilder(
                            future: _habitacion,
                            builder: (context, projectSnap) {
                              if (projectSnap.connectionState == ConnectionState
                                  .done) {
                                Map row = Map();
                                try {
                                  if(projectSnap.data!=null) {
                                    Map data = jsonDecode(projectSnap.data);


                                    if (data['success'] == true) {
                                      row = data['data'][0];
                                    }
                                  }


                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Flexible(child: StatesId(row)),
                                          Flexible(child: RegionsId(row)),
                                          Flexible(child: CitiesId(row)),
                                        ],
                                      ),
                                      _campoTexto(
                                          "urb", "Urbanización/Barrio/Empresa",
                                          'todo', true, row['urb']),
                                      Row(
                                        children: <Widget>[
                                          Expanded(child: Padding(
                                              padding: EdgeInsets.only(
                                                  right: 5),
                                              child: _campoTexto(
                                                  "zip_code", "Codigo postal",
                                                  'numero', true,
                                                  row['zip_code']))),
                                          Expanded(child: _campoTexto(
                                              "sector", "Sector/Avenida/Calle",
                                              'todo', true, row['sector'])),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Expanded(child: Padding(
                                            padding: EdgeInsets.only(right: 5),
                                            child: _campoTexto(
                                                "nro_home", "Nro de casa/local",
                                                'todo', true,
                                                row['nro_home']),)),
                                          Expanded(child: _campoTexto(
                                              "reference_point",
                                              "Punto de referencia", 'todo',
                                              true,
                                              row['reference_point'])),
                                        ],
                                      ),
                                      Padding(padding: EdgeInsets.only(top:10),),
                                      Text("La dirección de habitación no aplica para el delivery, si desea registrar una dirección para delivery ingrese en el menú principal -> direcciones de entrega."),
                                      _botonEnvio(row['id'])
                                    ],


                                  );
                                }catch(e){
                                  return Text("");
                                }
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            }
                        ),
                    ),

                  ],
                ),
              )



            ],
          ),
        ))
    );

  }
_botonEnvio(id){
    return Padding(padding: EdgeInsets.all(20.00),child: Center(child: RaisedButton(
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(18.0),
        ),
        color: Color(0xFFe1251b),
        textColor: Colors.white,
        child: _btnDireccionesCargando==true ? CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ) : Text('Guardar'),
        onPressed: () async {
          if (_validarCombos() && _formKey.currentState.validate() && !_btnDireccionesCargando && !_btnDireccionesCargando) {
            _formKey.currentState.save();

            setState(() {_btnDireccionesCargando=true;});
            await modelo.guardarDireccionHabitacion(campo,id);
            setState(() {_btnDireccionesCargando=false;});
            if(modelo.resJson['success']==true){
              msj(modelo.resJson['msj_general']);
             // Navigator.pushNamed(context, '/ListadoDirecciones');
              //Navigator.pushReplacementNamed(context, '/ListadoDirecciones');
              msj("Guardado");
              //Navigator.pop(context);
              //Navigator.of(context).pop();
            }else{
              msj(modelo.resJson['msj_general']);
            }
          }else{
            setState(() {
              _btnDireccionesCargando=false;
            });
            msj("Verifique los datos.");
          }
        }

    )));
}
  Widget _selectCitiesId(List data){
    if(_regions_id==null){
      return Padding(padding: EdgeInsets.all(0.00),);
    }
    if(data==null){
      return Row(children: <Widget>[Text("Parroquias:"),IconButton(icon: Icon(Icons.autorenew),onPressed: (){setState(() {});},)],);
    }
      return DropdownButton(
        items: data?.map((item) {
          return DropdownMenuItem(
            child: Text(item['name']),
            value: item['id'],
          );
        })?.toList() ?? [],
        hint: Text("Parroquia",),

        onChanged: (newVal) {
          setState(() {
            campo['cities_id']=newVal;
            _cities_id = newVal;
            _avisoObligatorioCities=false;
          });
        },
        isExpanded: true,
        value: _cities_id,
        underline: _validarCombosLinea(_avisoObligatorioCities),
      );

  }
  Widget CitiesId(row) {
    if (_cities_id== null && _widgetCities==true){
      campo['cities_id']=row['cities_id'];
      _cities_id = row['cities_id'];
    }
    return FutureBuilder(
      future: modelo.getCities(_regions_id,all:true),
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.done) {
          return _selectCitiesId(projectSnap.data);

        }else {
          //print(" add   $projectSnap.data");
          return CircularProgressIndicator();
        }
      },

    );
  }
  Widget _selectRegionsId(List data){
    if(_states_id==null){
      return Padding(padding: EdgeInsets.all(0.00),);
    }
    if(data==null){
      return Row(children: <Widget>[Text("Municipios:"),IconButton(icon: Icon(Icons.autorenew),onPressed: (){setState(() {});},)],);
    }
    return DropdownButton(
      items: data?.map((item) {
        return DropdownMenuItem(
          child: Text(item['name']),
          value: item['id'],
        );
      })?.toList() ?? [],
      hint: Text("Municipio",),

      onChanged: (newVal) {
        setState(() {
          _cities_id=null;
          _widgetCities=false;
          modelo.citiesCargado=false;
          _avisoObligatorioRegions=false;
          _regions_id = newVal;
        });
      },
      isExpanded: true,
      value: _regions_id,
      underline: _validarCombosLinea(_avisoObligatorioRegions),
    );

  }
  Widget RegionsId(row) {
    if (_regions_id == null && _widgetRegions==true){
      _regions_id = row['regions_id'];
    }
    return FutureBuilder(
      future: modelo.getRegions(_states_id,all:true),
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.done) {
          return _selectRegionsId(projectSnap.data);

        }else {
          //print(" add   $projectSnap.data");
          return CircularProgressIndicator();
        }
      },

    );
  }
  Widget _selectStatesId(List data){
    if(data==null){
      return Row(children: <Widget>[Text("Estados:"),IconButton(icon: Icon(Icons.autorenew),onPressed: (){setState(() {});},)],);
    }

    return DropdownButton(

      items: data?.map((item) {
        if(item['id']==_states_id){ //para evitar el error si desactiamos un estado y el usuario consulta y tiene el estado viejo
          _buenoStates=true;
        }
        return DropdownMenuItem(
          child: Text(item['name']),
          value: item['id'],
        );

      })?.toList() ?? [],
      hint: Text("Estado",),
      onChanged: (newVal) {

        setState(() {

          _regions_id=null;
          _cities_id=null;
          _widgetRegions=false;
          modelo.citiesCargado=false;
          modelo.regionsCargado=false;
          _avisoObligatorioState=false;
          _states_id = newVal;
        });
      },
underline: _validarCombosLinea(_avisoObligatorioState),
      isExpanded: true,
      value: _buenoStates ? _states_id : null,
    );

  }
  bool _validarCombos() {
    if(_states_id==null) _avisoObligatorioState=true;
    if(_regions_id==null) _avisoObligatorioRegions=true;
    if(_cities_id==null) _avisoObligatorioCities=true;
    if(_states_id!=null && _regions_id!=null && _cities_id!=null){
      return true;
    }else{
      setState(() {
      });
      return false;
    }
  }
  Widget _validarCombosLinea(tipo){
    if(tipo){
      return Container(color: Colors.red, height: 0.5);
    }else {
      return Container(color: Colors.grey, height: 0.5);
    }
  }
  Widget StatesId(row) {
    if (_states_id == null){
      _states_id = row['states_id'];
    }
    return FutureBuilder(
      future: modelo.getStates(all:true),
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.done) {
          return _selectStatesId(projectSnap.data);

        }else {
          return CircularProgressIndicator();
        }
      },

    );
  }



  _campoTexto(String name,String txt_label,tipo,obligatorio,val){
    TextInputType tipoKey;
    switch(tipo){
      case 'correo':
        tipoKey=TextInputType.emailAddress;
        break;
      case 'numero':
        tipoKey=TextInputType.number;
        break;
      default:
        tipoKey=TextInputType.text;
    }
    //TextInputType emailAddress = TextInputType.emailAddress;
    return TextFormField(
      initialValue: val,
      validator: (value) {
        return validar(tipo,value,obligatorio);
      },
      onSaved: (value) {
        //msj(value);
        //setState(() {
          campo[name]=value;
        //});
      },
      keyboardType: tipoKey,
      decoration: InputDecoration(
        //hintText: 'Ingrese su nombre y apellido',
        labelText: txt_label,
      ),
     // focusNode: _focus,
    );

  }


}

