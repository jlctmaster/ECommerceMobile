import 'dart:convert';

import 'package:biomercados/auth/tdc.dart';
import 'package:biomercados/auth/tdd.dart';
import 'package:biomercados/config.dart';
import 'package:biomercados/funciones_generales.dart';
import 'package:biomercados/home/orden.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
class EnviarPago extends StatefulWidget{
  final int id;
  final String titular;
  final String description;
  final String nombreBanco;
  final String moneda;
  final String coins_id;
  final double monto;
  final double rate;
  final int nroOrden;
  final int payment_methods_id;
  const EnviarPago({Key key, this.id, this.titular, this.description, this.nombreBanco, this.moneda, this.monto, this.coins_id, this.nroOrden, this.rate, this.payment_methods_id}) : super(key: key);


  @override
  _enviarPagoState createState() => _enviarPagoState();
}

class _enviarPagoState extends State<EnviarPago> {
  bool _cargando=false;
bool _cargadoTotalPagar=false;
  final _formKey = GlobalKey<FormState>();
  Map tipo={
    "ref": '',
    "monto": ''
  };
  List rateJson;
  String _ref;

  String _monto;
  double total_pay=0.00;
  bool _pagado=false;
  String total_pagar_campo='0';
  Future getSaldo() async {
    var url=await UrlLogin('saldo');
    Map datos = await peticionGet(url);
    print(datos);
    if(datos['success']==true){
      return datos['data'][0]['saldo'];
    }else{
      return '0.00';
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBarBio(context,"Realizar pago."),
      body:  SingleChildScrollView( child: Container(

        child:Padding(padding:EdgeInsets.all(15),child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _datosPagos(),
          
          Divider(),
          //_texto("Monto a pagar: ",widget.description),
          _totalPagar(),
        ],
      ),),),),
    );

  }
_datosPagos(){
  if(widget.payment_methods_id==5 || widget.payment_methods_id==10 || widget.payment_methods_id==8 || widget.payment_methods_id==3){
    return Column(children: <Widget>[
         Center(child: subTituloLogin("Realice su pago"),),
      Divider(),  
      ],);
  }else{
    return Column(children: <Widget>[
        Center(child: subTituloLogin("Realice su pago a la siguiente cuenta"),),
      Divider(),
      _texto("Banco: ",widget.nombreBanco),
      _texto("Moneda: ",widget.moneda),
      _texto("Titular: ",widget.titular),
      _texto("Datos: ", widget.description ?? '-'),

    ],);
  }
}
  _totalPagar(){
   return FutureBuilder(
      future: _montoPagar(),
      builder: (context, res) {
        if (res.connectionState == ConnectionState.done) {
            return _bloquePagar(res.data['data'],int.parse(res.data['data'][0]['cant_pagos']));

        }else {
          return Center(child: CircularProgressIndicator(),);
        }
      },
    );
  }
  _texto(String titulo,String value){
    return Padding(padding:EdgeInsets.all(10),child: Row(children: <Widget>[Container(width: 100,child: Text(titulo,style: TextStyle(fontSize: 18,color: Colors.black45),),),Flexible(child:Text(value,style: TextStyle(fontSize: 18)))],),);
  }
  _textob(String titulo,String value){
    return Padding(padding:EdgeInsets.only(left:10,right: 10),child: Row(mainAxisAlignment:MainAxisAlignment.end,children: <Widget>[Expanded(child: Text(titulo,style: TextStyle(fontSize: 18,color: Colors.black45),textAlign: TextAlign.left,),),Container(width:170,child: Text(value,style: TextStyle(fontSize: 18),textAlign: TextAlign.right,),)],),);
  }
  _textod(String titulo,Widget value){
    return Padding(padding:EdgeInsets.only(left:10,right: 10),child: Row(mainAxisAlignment:MainAxisAlignment.end,children: <Widget>[Expanded(child: Text(titulo,style: TextStyle(fontSize: 18,color: Colors.black45),textAlign: TextAlign.left,),),Container(width:100,child: value,)],),);
  }
  _textoc(String titulo,String value){
    return Padding(padding:EdgeInsets.only(left:10,right: 10),child: Row(mainAxisAlignment:MainAxisAlignment.end,children: <Widget>[Expanded(child: Text(titulo,style: TextStyle(fontSize: 21,color: Colors.black45),),),Container(width:170,child:Text(value,style: TextStyle(fontSize: 21),textAlign: TextAlign.right,))],),);
  }
  _cambiarMoneda(double valor,rj){
    int coins_id=int.parse(widget.coins_id);
    for(int i=0; i<rj.length; i++){

      if(int.parse(rj[i]['id'])==coins_id){
       // msj(coins_id.toString());
        return valor/double.parse(rj[i]['rate']);
      }
    }
  }
  _cambiarMonedaNativa(double valor,rj){
    int coins_id=int.parse(widget.coins_id);
    for(int i=0; i<rj.length; i++){

      if(int.parse(rj[i]['id'])==coins_id){
       // msj((valor*double.parse(rj[i]['rate'])).toString());
        return valor*double.parse(rj[i]['rate']);
      }
    }
  }

  _formatearMoneda(double valor) {
    int coins_id=int.parse(widget.coins_id);
    String listo='0';
    switch(coins_id){
      case 1:
       return formatDolar.format(valor);
      break;
      default:
        return formatBolivar.format(valor);
        break;

    }
  }
    _formatearMonedaSinSimbolo(double valor) {
    int coins_id=int.parse(widget.coins_id);
    String listo='0';
    switch(coins_id){
      case 1:
       return formatDolarSinSimbolo.format(valor);
      break;
      default:
        return formatBolivarSinSimbolo.format(valor);
        break;

    }
  }
  String _tipoValidacion(){
    switch(widget.coins_id){
      case '1':
        return 'thousand';
      default:
        return 'nro_venezuela';
    }
  }
  _bloquePagar(data,cant_pagos){
    int status=int.parse(data[0]['order_status']);

    rateJson=jsonDecode(data[0]['rate_json']);

    double orden  =       _cambiarMoneda(double.parse(data[0]['total_pay']), rateJson);
    //double embalaje=      _cambiarMoneda(double.parse(data[0]['total_packaging']), rateJson);
    double transporte=    _cambiarMoneda(double.parse(data[0]['total_transport']), rateJson);
    double abono=0.00;
  if(data[0]['pago_json']==null){
    abono=0.00;
  }else{
    List r=jsonDecode(data[0]['pago_json']);
    String _status;
    double _amount;
    for(int i=0; i<r.length; i++){
      _status=r[i]['status'];
      _amount=_cambiarMoneda(r[i]['amount'], rateJson);
      if(_status!="rechazado"){
        abono+=_amount;
      }
    }
   // msj(r[0]['id'].toString());
  //  abono=0.00;
  }
    double totalPagar=orden-abono;
if(totalPagar<=0){
  totalPagar=0.00;
  _pagado=true;
}
if(status>1) _pagado=true;

    total_pay=totalPagar;
    print(double.parse(totalPagar.toStringAsFixed(2)));
  if(double.parse(totalPagar.toStringAsFixed(2))>0 || _pagado==true) {

    total_pagar_campo=_formatearMonedaSinSimbolo(totalPagar);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        //   _textod("Orden: ",_futureFormateo(orden)),
        _textob("Orden: ", "+ " + _formatearMoneda(orden)),
        //_textob("Envío: ","+ "+_formatearMoneda(transporte)),
        //    _textob("Embalaje: ","+ "+_formatearMoneda(embalaje)),
        _textob("Abonos: ", "- " + _formatearMoneda(abono)),
        //REDONDEO AL SUPERIOR
        Divider(),
        //_textoc("Total a pagar: ",_formatearMoneda(double.parse((totalPagar+0.004).toStringAsFixed(2)))),
        _textoc("Total a pagar: ", _formatearMoneda(totalPagar)),
        //_textoc("Total a pagar: ",(totalPagar+0.004).toStringAsFixed(2)),
        formu(_pagado,cant_pagos),


      ],
    );
  }else{
    return Center(child: Text("Disculpe, este método de pago no se encuentra disponible para su orden. Esto puede ser debido a que el monto a pagar en la moneda seleccionada es muy bajo.",textAlign:TextAlign.center,style: TextStyle(color: Colors.red),),);
  }
  }
  formu(bool pagado,cant_pagos){
    if(pagado){
     return Column(children: <Widget>[
        Icon(Icons.check_circle, size: 50, color: Color(colorVerde),),
        Text("Gracias por su compra, le invitamos a conocer todas nuestras categorías y promociones.\n (Inspirados en Servir)", style: TextStyle(fontSize: 20),textAlign: TextAlign.center,),
        Text(
          "Es posible que algunos de sus pagos estén en proceso de verificación. En el menu Orden o Tracking puede ver el estatus de su orden.",
          textAlign: TextAlign.center,),
        link("Volver al menu principal", "/home", context)
      ],);
    }else{
      if(cant_pagos>1){
        return Center(child:Text("Disculpe, a alcanzado el límite de pagos permitidos. Diríjase a la tienda Biomercados mas cercana.",style: TextStyle(fontSize: 18,color: Colors.red)) ,);
      }else {
        return _formularios();
      }
    }
  }
  _formularios() {
    switch (widget.payment_methods_id) {
      case 8 :
        return _formularioTDC();
        break;
      case 10 :
        return _formularioTDD();
        break;
      case 3 :
        return _formularioEfectivo();
        break;
      case 5:
        return _formularioBiowallet();
        break;
      default:
        return _formularioTransferencia();
    }
  }
_formularioEfectivo(){
  return Form(
      key: _formKey,
      child:Column(
        children: <Widget>[
          Divider(),
          Center(child: subTituloLogin("Ingrese el monto de la suma de sus billetes completo, el saldo excedente sera acreditado en su cuenta biowallet para futuras compras."),),
          Row(children: <Widget>[
            //Expanded(child: Padding(padding:EdgeInsets.only(right: 5), child: _campoTexto_ref('Seriales','Por favor ingrese los seriales de su efectivo','todo',true),),),
            Expanded(child: _campoTexto_monto('Ingrese el monto','Por favor ingrese el Monto que pagara en efectivo','numero',true,otroTipo: 'efectivo')),
          ],),

          _botonRojo()

        ],
      )
  );
}
_formularioBiowallet(){
  return Form(
      key: _formKey,
      child:Column(
        children: <Widget>[
          Divider(),
          Center(child: subTituloLogin("¿Ingrese el monto a pagar?"),),
          Center(child: _mostrarSaldo(),),
          Row(children: <Widget>[
            
            Expanded(child: _campoTexto_monto('Ingrese el monto','Por favor ingrese el Monto que pagara','thousand',true)),
          ],),

          _botonRojo()

        ],
      )
  );
}
_mostrarSaldo(){

return FutureBuilder(
                  future: getSaldo(),
                  builder: (context, res) {
                    if (res.connectionState == ConnectionState.done) {
                      
                      return Text("Su saldo disponible: "+formatDolar.format(double.parse(res.data)),style: TextStyle(fontSize: 20),);
                      
                    }else {
                      return Center(child: CircularProgressIndicator(),);
                    }
                  },
                );
 
}
  _formularioTransferencia(){
    return Form(
        key: _formKey,
        child:Column(
          children: <Widget>[
            Divider(),
            Center(child: subTituloLogin("Reportenos su pago"),),
            Row(children: <Widget>[

              Expanded(child: Padding(padding:EdgeInsets.only(right: 5), child: _campoTexto_ref('Nro. de Referencia','Por favor ingrese el Nro. de referencia de su pago','todo',true),),),
              Expanded(child: _campoTexto_monto('Monto transferido','Por favor ingrese el Monto que transfirio a nuestra cuenta',_tipoValidacion(),true)),

            ],),
Padding(
  padding: EdgeInsets.only(top:10),
  child:Text("Biomercados no reembolsara si su pago es superior al total a pagar.",style: TextStyle(color: Colors.red),),
)
,
            _botonRojo()

          ],
        )
    );
  }
  _formularioTDC(){
    return Form(
        key: _formKey,
        child:Column(
          children: <Widget>[
            Divider(),
            Center(child: subTituloLogin("¿Cuanto pagara mediante su TDC?"),),
            Row(children: <Widget>[

              Expanded(child: _campoTexto_monto('Monto a pagar','Por favor ingrese el Monto a pagar mediante su TDC',_tipoValidacion(),true)),

            ],),
            _botonRojob()

          ],
        )
    );
  }
    _formularioTDD(){
    return Form(
        key: _formKey,
        child:Column(
          children: <Widget>[
            Divider(),
            Center(child: subTituloLogin("¿Cuanto pagara mediante su TDD?"),),
            Row(children: <Widget>[

              Expanded(child: _campoTexto_monto('Monto a pagar','Por favor ingrese el Monto a pagar mediante su TDD',_tipoValidacion(),true)),

            ],),
            _botonRojotdd()

          ],
        )
    );
  }
  _campoTexto_ref(String txt_label,String msj_validar,tipo,obligatorio){
    TextInputType tipoKey;
    switch(tipo){
      case 'nro_venezuela':
      case 'float':
      case 'numero':
        tipoKey=TextInputType.number;
        break;
      default:
        tipoKey=TextInputType.text;
    }
    //TextInputType emailAddress = TextInputType.emailAddress;
    return TextFormField(
      validator: (value) {
        return validar(tipo,value,obligatorio);
      },
      onSaved: (value) {
        //setState(() {
         _ref=value;
       // });
      },
      keyboardType: tipoKey,
      decoration: InputDecoration(
        //hintText: 'Ingrese su nombre y apellido',
        labelText: txt_label,
      ),
    );

  }
  _campoTexto_monto(String txt_label,String msj_validar,tipo,obligatorio,{otroTipo='otro'}){
    TextInputType tipoKey;
 
    switch(tipo){
      case 'nro_venezuela':
      case 'float':
      case 'thousand':
      tipoKey=TextInputType.text;
        break;
      case 'numero':
        //tipoKey=TextInputType.numberWithOptions(decimal: true,signed: true);
        tipoKey=TextInputType.numberWithOptions(decimal: false);
        break;
      default:
        tipoKey=TextInputType.text;
    }
    //TextInputType emailAddress = TextInputType.emailAddress;
    return TextFormField(
      initialValue:total_pagar_campo.trim(),

      validator: (value) {

        return validarMonto(tipo, value, obligatorio,otroTipo: otroTipo);

      },
      onSaved: (value) {
        value=set_formato_moneda(value);
       // msj(value);
       // msj(double.parse(value).toString());
        if(widget.coins_id!='2') {
          _monto = (double.parse(value) * widget.rate).toString();
        }else{
         // msj(formatDolar.format(value));

          _monto=value;
        }
//msj(widget.rate.toString());
        //_monto=_cambiarMonedaNativa(double.parse(value),rateJson).toString();
       //
        // });
      },
      keyboardType: tipoKey,
      decoration: InputDecoration(
        //hintText: 'Ingrese su nombre y apellido',
        labelText: txt_label,
      ),
    );

  }
  set_formato_moneda(String value){

    String listo='';
    String b=value.trim();
    List c;
   // b=b.replaceAll(RegExp(r'\s'), '');
   // b=b.replaceAll(RegExp(r',\.'), ' ');
    b=b.replaceAll(' ', '');
    b=b.replaceAll('.', ' ');
    b=b.replaceAll(',', ' ');
    c=b.split(' ');

    int total=c.length;

    if(total>1){
      c[total-1]="."+c[total-1];

    //  for(int i=0; i<c.length; i++){
      //  listo=listo+c[i];
     // }
      c.forEach((element) =>listo="$listo$element");
    }else{

    listo=b;
    }
    return listo;
  }
    _botonRojotdd() {

    return Padding(
        padding: const EdgeInsets.only(top: 25.0),
        child: Center(
          child: SizedBox(
            width: 150,
            height: 40,
            child:RaisedButton(
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
              ),
              color: Color(0xFFe1251b),
              textColor: Colors.white,
              child: _cargando ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ) : Text('Realizar pago'),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Tdd(nroOrden: widget.nroOrden,monto: _monto,)),
                  ).then((value){
                    setState(() {});
                  });
                }


              },
            ),
          ),
        )
    );
  }
  _botonRojob() {

    return Padding(
        padding: const EdgeInsets.only(top: 25.0),
        child: Center(
          child: SizedBox(
            width: 150,
            height: 40,
            child:RaisedButton(
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
              ),
              color: Color(0xFFe1251b),
              textColor: Colors.white,
              child: _cargando ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ) : Text('Realizar pago'),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Tdc(nroOrden: widget.nroOrden,monto: _monto,)),
                  ).then((value){
                    setState(() {});
                  });
                }


              },
            ),
          ),
        )
    );
  }
  _botonRojo() {

    return Padding(
        padding: const EdgeInsets.only(top: 25.0),
        child: Center(
          child: SizedBox(
            width: 150,
            height: 40,
            child:RaisedButton(
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                ),
                color: Color(0xFFe1251b),
                textColor: Colors.white,
                child: _cargando ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ) : Text('Pagar'),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    setState(() {
                      _cargando=true;
                    });
                   _formKey.currentState.save();
                    await _guardarPago(tipo);
                  setState(() {

                    _cargando=false;
                  // msjb("Pago realizado!",context);
                  });
                  }


                },
              ),
          ),
        )
    );
  }
  _guardarPago(tipo) async {

    String url=await UrlLogin('guardarPago&coins_id='+widget.coins_id.toString()+'&ref=$_ref&amount=$_monto&orders_id='+widget.nroOrden.toString()+'&bank_datas_id='+widget.id.toString());
    Map res=await peticionGet(url);
    //final response = await http.get(url,headers: {"Accept": "application/json"},
    //);
    //print(response.body);
   // Map res= jsonDecode(response.body);
    if (res['success']==true) {
      msj("Su pago ha sido abonado.");
    }else{
      msj(res['msj_general']);
    }
  }
  _montoPagar() async {
    int orders_id=widget.nroOrden;

    String urlb=await UrlLogin('totalPagar&orders_id=$orders_id');

    Map res= await peticionGetZlib(urlb);

  //  int cantPago=await getCantPago(widget.nroOrden);
  //  print("aaaaaaaaaaaa $cantPago");

  //  res['limitePago']=false;
  //  if(cantPago>1){
    //  res['limitePago']=true;
    //  return res;
   // }
    if (res['success']==true) {
     return res;
    }else{
      msj(res['msj_general']);
    }
  }

  validarMonto(tipo, value, obligatorio,{otroTipo='otro'}) {
    if(validar(tipo, value, obligatorio)==null) {
      double monto;
      double pagar = double.parse(total_pay.toStringAsFixed(2));

      if (value != null && value != '') {
        monto = double.parse(set_formato_moneda(value));
        if(otroTipo=='efectivo' && monto>pagar){
          
          return null;
        }
        if (monto > pagar || monto == 0) {
          return 'Monto incorrecto.';
        } else {
          return null;
        }
      } else {
        return null;
      }
    }else{
      return validar(tipo, value, obligatorio);
    }
  }
}
