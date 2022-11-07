import 'dart:convert';

import 'auth/tdc.dart';
import 'auth/tdd.dart';
import 'config.dart';
import 'funciones_generales.dart';
import 'home/orden.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:Pide/pide_icons.dart';

class EnviarPago extends StatefulWidget {
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
  final String symbol;
  const EnviarPago(
      {Key key,
      this.id,
      this.titular,
      this.description,
      this.nombreBanco,
      this.moneda,
      this.monto,
      this.coins_id,
      this.nroOrden,
      this.rate,
      this.payment_methods_id,
      this.symbol})
      : super(key: key);

  @override
  _enviarPagoState createState() => _enviarPagoState();
}

class _enviarPagoState extends State<EnviarPago> {
  bool _cargando = false;
  bool _cargadoTotalPagar = false;
  final _formKey = GlobalKey<FormState>();
  Map tipo = {"ref": '', "monto": ''};
  List rateJson;
  String _ref;
  String horaEntrega = "";
  String _monto;
  double total_pay = 0.00;
  bool _pagado = false;
  String total_pagar_campo = '0';
  Future getSaldo() async {
    var url = await UrlLogin('saldo');
    Map datos = await peticionGet(url);
    print(datos);
    if (datos['success'] == true) {
      return datos['data'][0]['saldo'];
    } else {
      return '0.00';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBio(context, "Modulo de pago."),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _datosPagos(),

                Divider(),
                //_texto("Monto a pagar: ",widget.description),
                _totalPagar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _datosPagos() {
    if (widget.payment_methods_id == 5 ||
        widget.payment_methods_id == 10 ||
        widget.payment_methods_id == 12 ||
        widget.payment_methods_id == 8 ||
        widget.payment_methods_id == 3) {
      return Column(
        children: <Widget>[
          // Center(child: subTituloLogin("Realice su pago"),),
          // Divider(),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Center(
            child: subTituloLogin("Realice su pago a la siguiente cuenta"),
          ),
          Divider(),
          _texto("Banco: ", widget.nombreBanco),
          _texto("Moneda: ", widget.moneda),
          _texto("Titular: ", widget.titular),
          _texto("Datos: ", widget.description ?? '-'),
        ],
      );
    }
  }

  _totalPagar() {
    return FutureBuilder(
      future: _montoPagar(),
      builder: (context, res) {
        if (res.connectionState == ConnectionState.done) {
          return _bloquePagar(res.data['data'], int.parse(res.data['data'][0]['cant_pagos']));
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  _texto(String titulo, String value) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Container(
            width: 100,
            child: Text(
              titulo,
              style: TextStyle(fontSize: 18, color: Colors.black45),
            ),
          ),
          Flexible(child: Text(value, style: TextStyle(fontSize: 18)))
        ],
      ),
    );
  }

  _textob(String titulo, String value) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Text(
              titulo,
              style: TextStyle(fontSize: 18, color: Colors.black45),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            width: 170,
            child: Text(
              value,
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.right,
            ),
          )
        ],
      ),
    );
  }

  _textod(String titulo, Widget value) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Text(
              titulo,
              style: TextStyle(fontSize: 18, color: Colors.black45),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            width: 100,
            child: value,
          )
        ],
      ),
    );
  }

  _textoc(String titulo, String value) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Text(
              titulo,
              style: TextStyle(fontSize: 21, color: Colors.black45),
            ),
          ),
          Container(
              width: 170,
              child: Text(
                value,
                style: TextStyle(fontSize: 21),
                textAlign: TextAlign.right,
              ))
        ],
      ),
    );
  }

  _cambiarMoneda(double valor, rj) {
    int coins_id = int.parse(widget.coins_id);
    for (int i = 0; i < rj.length; i++) {
      if (int.parse(rj[i]['id']) == coins_id) {
        // msj(coins_id.toString());
        return valor * double.parse(rj[i]['rate']);
      }
    }
  }

  _cambiarMonedaNativa(double valor, rj) {
    int coins_id = int.parse(widget.coins_id);
    for (int i = 0; i < rj.length; i++) {
      if (int.parse(rj[i]['id']) == coins_id) {
        // msj((valor*double.parse(rj[i]['rate'])).toString());
        return valor * double.parse(rj[i]['rate']);
      }
    }
  }

  _formatearMoneda(double valor) {
    int coins_id = int.parse(widget.coins_id);
    String listo = '0';
    switch (coins_id) {
      case 1:
        return formatDolar.format(valor);
        break;
      case 2:
        return formatBolivar.format(valor);

        break;
      default:
        return formatDolarSinSimbolo.format(valor) + " " + widget.symbol;
        break;
    }
  }

  _formatearMonedaSinSimbolo(double valor) {
    int coins_id = int.parse(widget.coins_id);
    String listo = '0';
    switch (coins_id) {
      case 1:
        return formatDolarSinSimbolo.format(valor);
        break;
      default:
        return formatBolivarSinSimbolo.format(valor);
        break;
    }
  }

  String _tipoValidacion() {
    switch (widget.coins_id) {
      case '1':
        return 'thousand';
      default:
        return 'nro_venezuela';
    }
  }

  _bloquePagar(data, cant_pagos) {
    int status = int.parse(data[0]['order_status']);

    rateJson = jsonDecode(data[0]['rate_json']);

    double orden = _cambiarMoneda(double.parse(data[0]['total_pay']), rateJson);
    //double embalaje=      _cambiarMoneda(double.parse(data[0]['total_packaging']), rateJson);
    double transporte = _cambiarMoneda(double.parse(data[0]['total_transport']), rateJson);
    double abono = 0.00;
    if (data[0]['pago_json'] == null) {
      abono = 0.00;
    } else {
      List r = jsonDecode(data[0]['pago_json']);
      horaEntrega = data[0]['delivery_time_date'];
      String _status;
      double _amount;
      for (int i = 0; i < r.length; i++) {
        _status = r[i]['status'];
        _amount = _cambiarMoneda(r[i]['amount'], rateJson);
        if (_status != "rechazado") {
          abono += _amount;
        }
      }
      // msj(r[0]['id'].toString());
      //  abono=0.00;
    }
    double totalPagar = orden - abono;
    if (totalPagar <= 0) {
      totalPagar = 0.00;
      _pagado = true;
    }
    if (status > 1) _pagado = true;

    total_pay = totalPagar;
    print(double.parse(totalPagar.toStringAsFixed(2)));
    if (double.parse(totalPagar.toStringAsFixed(2)) > 0 || _pagado == true) {
      total_pagar_campo = _formatearMonedaSinSimbolo(totalPagar);
      return _pagado != true
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                //   _textod("Orden: ",_futureFormateo(orden)),
                abono > 0 ? _textob("Orden: ", "+ " + _formatearMoneda(orden)) : SizedBox(),
                //_textob("Envío: ","+ "+_formatearMoneda(transporte)),
                //    _textob("Embalaje: ","+ "+_formatearMoneda(embalaje)),
                abono > 0 ? _textob("Abonos: ", "- " + _formatearMoneda(abono)) : SizedBox(),
                //REDONDEO AL SUPERIOR
                Divider(),
                //_textoc("Total a pagar: ",_formatearMoneda(double.parse((totalPagar+0.004).toStringAsFixed(2)))),
                _textoc("Total a pagar: ", _formatearMoneda(totalPagar)),
                //_textoc("Total a pagar: ",(totalPagar+0.004).toStringAsFixed(2)),
                formu(_pagado, cant_pagos),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Center(
                    child: Text(
                  "Orden procesada!",
                  style: TextStyle(fontSize: 29),
                )),
                formu(_pagado, cant_pagos),
              ],
            );
    } else {
      return Center(
        child: Text(
          "Disculpe, este método de pago no se encuentra disponible para su orden. Esto puede ser debido a que el monto a pagar en la moneda seleccionada es muy bajo.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.red),
        ),
      );
    }
  }

  _horaEntrega() {
    return Column(
      children: [
        Text("Su orden Nro. " + widget.nroOrden.toString() + " será entregada aproximadamente a las:"),
        Text(horaEntrega, style: TextStyle(fontSize: 18)),
      ],
    );
  }

  formu(bool pagado, cant_pagos) {
    if (pagado) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Pide.check_circle,
            size: 50,
            color: Color(colorVerde),
          ),
          Text(
            "Gracias por preferirnos.",
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          _horaEntrega(),
          Text(
            "Para mayor información puede comunicarse via WhatsApp al Nro.",
            textAlign: TextAlign.center,
          ),
          Text(
            "+58 412 1507327",
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          linkGrande("Salir al menú principal", "/home", context)
        ],
      ));
    } else {
      if (cant_pagos > 2) {
        return Center(
          child: Text("Disculpe, a alcanzado el límite de pagos permitidos. Diríjase a la tienda PIDE mas cercana.",
              style: TextStyle(fontSize: 18, color: Colors.red)),
        );
      } else {
        return _formularios();
      }
    }
  }

  _formularios() {
    switch (widget.payment_methods_id) {
      case 8:
        return _formularioTDC();
        break;
      case 10:
        return _formularioTDD();
        break;
      case 3:
        return _formularioEfectivo();
        break;
      case 5:
        return _formularioBiowallet();
        break;
      case 12:
        return _formularioPagoEnCasa();
        break;
      default:
        return _formularioTransferencia();
    }
  }

  _formularioEfectivo() {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Divider(),
            Center(
              child: subTituloLogin(
                  "Ingrese el monto de la suma de sus billetes, le daremos su cambio en dólares o bolivares. (SOLO DISPONIBLE PARA RETIROS EN NUESTRA TIENDA)"),
            ),
            Row(
              children: <Widget>[
                //Expanded(child: Padding(padding:EdgeInsets.only(right: 5), child: _campoTexto_ref('Seriales','Por favor ingrese los seriales de su efectivo','todo',true),),),
                Expanded(
                    child: _campoTexto_monto('Ingrese el monto', 'Por favor ingrese el Monto que pagara en efectivo', 'numero', true, otroTipo: 'efectivo')),
              ],
            ),
            _botonRojo()
          ],
        ));
  }

  _formularioBiowallet() {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Divider(),
            Center(
              child: subTituloLogin("¿Ingrese el monto a pagar?"),
            ),
            Center(
              child: _mostrarSaldo(),
            ),
            Row(
              children: <Widget>[
                Expanded(child: _campoTexto_monto('Ingrese el monto', 'Por favor ingrese el Monto que pagara', 'thousand', true)),
              ],
            ),
            _botonRojo()
          ],
        ));
  }

  _formularioPagoEnCasa() {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Divider(),
            Center(
              child: subTituloLogin("Verifique el monto y presione aceptar"),
            ),
            Row(
              children: <Widget>[
                Expanded(child: _campoTexto_monto('Monto a pagar', 'Verifique su monto a pagar', 'nro_venezuela', true)),
              ],
            ),
            _botonRojo(texto: "Aceptar")
          ],
        ));
  }

  _mostrarSaldo() {
    return FutureBuilder(
      future: getSaldo(),
      builder: (context, res) {
        if (res.connectionState == ConnectionState.done) {
          return Text(
            "Su saldo disponible: " + formatDolar.format(double.parse(res.data)),
            style: TextStyle(fontSize: 20),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  _formularioTransferencia() {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Divider(),
            Center(
              child: subTituloLogin("Reportenos su pago"),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: _campoTexto_ref('Nro. de Referencia', 'Por favor ingrese el Nro. de referencia de su pago', 'todo', true),
                  ),
                ),
                Expanded(child: _campoTexto_monto('Monto transferido', 'Por favor ingrese el Monto que transfirio a nuestra cuenta', _tipoValidacion(), true)),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                "PIDE no reembolsara dinero si su pago es superior al total a pagar.",
                style: TextStyle(color: Colors.red),
              ),
            ),
            _botonRojo()
          ],
        ));
  }

  _formularioTDC() {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Divider(),
            Center(
              child: subTituloLogin("¿Cuanto pagara mediante su TDC?"),
            ),
            Row(
              children: <Widget>[
                Expanded(child: _campoTexto_monto('Monto a pagar', 'Por favor ingrese el Monto a pagar mediante su TDC', _tipoValidacion(), true)),
              ],
            ),
            _botonRojob()
          ],
        ));
  }

  _formularioTDD() {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Divider(),
            Center(
              child: subTituloLogin("¿Cuanto pagara mediante su TDD?"),
            ),
            Row(
              children: <Widget>[
                Expanded(child: _campoTexto_monto('Monto a pagar', 'Por favor ingrese el Monto a pagar mediante su TDD', _tipoValidacion(), true)),
              ],
            ),
            _botonRojotdd()
          ],
        ));
  }

  _campoTexto_ref(String txt_label, String msj_validar, tipo, obligatorio) {
    TextInputType tipoKey;
    switch (tipo) {
      case 'nro_venezuela':
      case 'float':
      case 'numero':
        tipoKey = TextInputType.number;
        break;
      default:
        tipoKey = TextInputType.text;
    }
    //TextInputType emailAddress = TextInputType.emailAddress;
    return TextFormField(
      validator: (value) {
        return validar(tipo, value, obligatorio);
      },
      onSaved: (value) {
        //setState(() {
        _ref = value;
        // });
      },
      keyboardType: tipoKey,
      decoration: InputDecoration(
        //hintText: 'Ingrese su nombre y apellido',
        labelText: txt_label,
      ),
    );
  }

  _campoTexto_monto(String txt_label, String msj_validar, tipo, obligatorio, {otroTipo = 'otro'}) {
    TextInputType tipoKey;

    switch (tipo) {
      case 'nro_venezuela':
      case 'float':
      case 'thousand':
        tipoKey = TextInputType.text;
        break;
      case 'numero':
        //tipoKey=TextInputType.numberWithOptions(decimal: true,signed: true);
        tipoKey = TextInputType.numberWithOptions(decimal: false);
        break;
      default:
        tipoKey = TextInputType.text;
    }
    //TextInputType emailAddress = TextInputType.emailAddress;
    return TextFormField(
      initialValue: total_pagar_campo.trim(),
      validator: (value) {
        return validarMonto(tipo, value, obligatorio, otroTipo: otroTipo);
      },
      onSaved: (value) {
        value = set_formato_moneda(value);
        // msj(value);
        // msj(double.parse(value).toString());
        // if(widget.coins_id!='2') {
        // msj(widget.rate.toString());
        // _monto = (double.parse(value) / widget.rate).toString();
        //}else{
        // msj(formatDolar.format(value));

        _monto = value;
        //}
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

  set_formato_moneda(String value) {
    String listo = '';
    String b = value.trim();
    List c;
    // b=b.replaceAll(RegExp(r'\s'), '');
    // b=b.replaceAll(RegExp(r',\.'), ' ');
    b = b.replaceAll(' ', '');
    b = b.replaceAll('.', ' ');
    b = b.replaceAll(',', ' ');
    c = b.split(' ');

    int total = c.length;

    if (total > 1) {
      c[total - 1] = "." + c[total - 1];

      //  for(int i=0; i<c.length; i++){
      //  listo=listo+c[i];
      // }
      c.forEach((element) => listo = "$listo$element");
    } else {
      listo = b;
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
            child: ElevatedButton(
              child: _cargando
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : Text('Realizar pago'),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Tdd(
                              nroOrden: widget.nroOrden,
                              monto: _monto,
                            )),
                  ).then((value) {
                    setState(() {});
                  });
                }
              },
            ),
          ),
        ));
  }

  _botonRojob() {
    return Padding(
        padding: const EdgeInsets.only(top: 25.0),
        child: Center(
          child: SizedBox(
            width: 150,
            height: 40,
            child: ElevatedButton(
              child: _cargando
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : Text('Realizar pago'),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Tdc(
                              nroOrden: widget.nroOrden,
                              monto: _monto,
                            )),
                  ).then((value) {
                    setState(() {});
                  });
                }
              },
            ),
          ),
        ));
  }

  _botonRojo({texto: 'Pagar'}) {
    return Padding(
        padding: const EdgeInsets.only(top: 25.0),
        child: Center(
          child: SizedBox(
            width: 150,
            height: 40,
            child: ElevatedButton(
              child: _cargando
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : Text(texto),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  setState(() {
                    _cargando = true;
                  });
                  _formKey.currentState.save();
                  await _guardarPago(tipo);
                  setState(() {
                    _cargando = false;
                    // msjb("Pago realizado!",context);
                  });
                }
              },
            ),
          ),
        ));
  }

  _guardarPago(tipo) async {
    String url = await UrlLogin('guardarPago&coins_id=' +
        widget.coins_id.toString() +
        '&ref=$_ref&amount=$_monto&orders_id=' +
        widget.nroOrden.toString() +
        '&bank_datas_id=' +
        widget.id.toString());

    Map res = await peticionGet(url);
    //final response = await http.get(url,headers: {"Accept": "application/json"},
    //);
    //print(response.body);
    // Map res= jsonDecode(response.body);
    if (res['success'] == true) {
      msj("Su pago ha sido abonado.");
    } else {
      msj(res['msj_general']);
    }
  }

  _montoPagar() async {
    int orders_id = widget.nroOrden;

    String urlb = await UrlLogin('totalPagar&orders_id=$orders_id');

    Map res = await peticionGetZlib(urlb);

    //  int cantPago=await getCantPago(widget.nroOrden);
    //  print("aaaaaaaaaaaa $cantPago");

    //  res['limitePago']=false;
    //  if(cantPago>1){
    //  res['limitePago']=true;
    //  return res;
    // }
    if (res['success'] == true) {
      return res;
    } else {
      msj(res['msj_general']);
    }
  }

  validarMonto(tipo, value, obligatorio, {otroTipo = 'otro'}) {
    if (validar(tipo, value, obligatorio) == null) {
      double monto;
      double pagar = double.parse(total_pay.toStringAsFixed(2));

      if (value != null && value != '') {
        monto = double.parse(set_formato_moneda(value));
        if (otroTipo == 'efectivo' && monto > pagar) {
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
    } else {
      return validar(tipo, value, obligatorio);
    }
  }
}
