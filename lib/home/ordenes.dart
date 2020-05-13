import 'dart:convert';

import 'package:biomercados/config.dart';
import 'package:biomercados/funciones_generales.dart';
import 'package:biomercados/home/orden.dart';
import 'package:biomercados/widget/modal.dart';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
class Ordenes extends StatefulWidget{

  @override
  _OrdenesState createState() => _OrdenesState();
}

class _OrdenesState extends State<Ordenes> {
  bool _cargando=false;


  @override
  Widget build(BuildContext context) {
    return  Column(children: <Widget>[
      Padding(
        padding: EdgeInsets.only(top:10),
        child: textoTop2("Ordenes de compras"),
      ),

Divider(),
        FutureBuilder(
          future: _listarOrdenes(),
          builder: (context, res) {
            if (res.connectionState == ConnectionState.done) {

              return _ordenes(res.data);
            }else {
              return Center(child: CircularProgressIndicator(),);
            }
          },
        ),
      ],);

  }
  _ordenes(data){

    if(data!=null) {

      return Flexible(
        child: ListView.builder(
          //physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int index) {

            return Card(
              child: _orden(data,index),
            );
          },
          padding:EdgeInsets.only(bottom: 20.0),
        ),
      );
    }else {
      return Text(
        "Todavia no has realizado compras.",
        style: TextStyle(fontSize: 20,),
        textAlign: TextAlign.justify,
      );
    }
  }
  _orden(data,index){
    Map row=data[index];
    Color color;
    print(row['orders_status_id']);
    String os_id=row['orders_status_id'];
    color=colorStatus(os_id);
    return ListTile(
      //leading: Container(child: Image.network(BASE_URL_IMAGEN+row['image'],height: 30,),width: 100,),
      title: Row(children: <Widget>[
        Text(
          "Nro. "+row['id'],
        ),
        Text(
          " "+row['status_tracking'],
          style: TextStyle(color: color),
        ),
      ],),

      subtitle:Container(
          child: Text(row['fecha'])
      ),

      trailing: os_id=='1' ? IconButton(icon: Icon(Icons.highlight_off,color: Color(colorRojo), ),onPressed: (){
        //_showAlert("¿Esta seguro de cancelar la orden Nro. "+row['id']+"?",data,index);
        showDialog(
            context: context,
            builder: (_) =>Modal(value:"¿Esta seguro de cancelar la orden Nro. "+row['id']+"?",nroOrden:int.parse(row['id']),context: context,onChanged: _eliminar,),

        );

      },) : Icon(Icons.navigate_next,) //IconButton(icon: Icon(Icons.navigate_next,),)
      ,
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Orden(id:row['id'],ordenStatus: int.parse(os_id),textoStatus: row['status_tracking'],),
          ),
        ).then((val)=>{_capturarRetroceso()});

      },
    );
  }
  _capturarRetroceso()async{//para actualizar la pagina esta despues que retrocedan de la pagina productos
    //setState(() {

   // });
    print("capturado retroceso");
  }
  _listarOrdenes() async {
    List a;

    String url=await UrlLogin('listarOrdenes');
    final response = await http.get(url,headers: {"Accept": "application/json"},);

    print(response.body);
    Map res= jsonDecode(response.body);

    if (response.statusCode == 200) {

      return res['data'];
    }else{
      msj(res['msj_general']);
    }
  }
  void _showAlert(String value,data,index) {
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
              print("weliminar");
              setState(() {
                _cargando=true;
              });
              await _cancelarOrden(data[index]['id']);
              //modelo.eliminarDireccion(datab[index]['id']);
              setState(() {
                data.removeAt(index);
              });
              Navigator.pop(context);

            }, child: Text('SI')),
          ],
        )
    );
  }

  _cancelarOrden(id) async{
    String url=await UrlLogin('cancelarOrden&orders_id=$id');
    final response = await http.get(url,headers: {"Accept": "application/json"},);

    print(response.body);
    msj(jsonDecode(response.body)['msj_general']);

  }

  _eliminar(value) {
    setState(() {

    });
  }
}
