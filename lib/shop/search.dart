import '../funciones_generales.dart';
import 'package:flutter/material.dart';
import 'package:Pide/pide_icons.dart';

class ShopSearch extends StatefulWidget {
  @override
  _ShopSearchState createState() => _ShopSearchState();
}

class _ShopSearchState extends State<ShopSearch> {
  String dropdownValue = 'Mas recientes';
  String evento;
  @override
  RangeValues _values = RangeValues(0.0, 50.0);
  Widget build(BuildContext context) {
    return Container(
      height: 425,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [BoxShadow(blurRadius: 2, color: Colors.black12, spreadRadius: 3)]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 15),
                child: Container(
                  width: 30,
                  height: 2,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
              Container(
                margin: new EdgeInsetsDirectional.only(bottom: 15.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: dropdownValue,
                    icon: Icon(Pide.keyboard_arrow_down),
                    style: TextStyle(color: Colors.black),
                    underline: Container(
                      height: 1,
                      color: Colors.grey[300],
                    ),
                    onChanged: (String newValue) async {
                      //  await setEvento('listarProductos');
                      setState(() {
                        dropdownValue = newValue;
                      });
                    },
                    items: <String>['Mas recientes', 'Mas vendidos', 'Mejores precios', 'Orden alfabético A-Z', 'Orden alfabético Z-A']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text('Selecciona el rango de precios', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              RangeSlider(
                  values: _values,
                  min: 0,
                  max: 50,
                  activeColor: Theme.of(context).primaryColor,
                  inactiveColor: Colors.grey[300],
                  onChanged: (RangeValues values) {
                    setState(() {
                      if (values.end - values.start >= 1) {
                        _values = values;
                      } else {
                        /*
                          if (_values.start == values.start) {
                            _values = RangeValues(_values.start, _values.start + 1);
                          } else {
                            _values = RangeValues(_values.end - 1, _values.end);
                          }

                           */
                      }
                    });
                  }),
            ],
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        width: 120,
                        height: 45.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Theme.of(context).accentColor),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('\$ ${_values.start.round()}', style: TextStyle(color: Colors.white)),
                        )),
                    Text(
                      'a',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    Container(
                        width: 120,
                        height: 45.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Theme.of(context).accentColor),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('\$ ${_values.end.round()}', style: TextStyle(color: Colors.white)),
                        )),
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ButtonTheme(
                      buttonColor: Theme.of(context).primaryColor,
                      minWidth: double.infinity,
                      height: 40.0,
                      child: ElevatedButton(
                        onPressed: () async {
                          String eventoActual = await getEvento();
                          String tituloActual = await getTitulo();
                          print(dropdownValue + " " + _values.end.round().toString() + " " + _values.start.round().toString());
                          String precioInicial = _values.start.round().toString();
                          String precioFinal = _values.end.round().toString();

                          setEvento('$eventoActual&precioInicial=$precioInicial&precioFinal=$precioFinal&tipo=$dropdownValue', tituloActual);
                          // setEvento('listarProductosFiltrados&precioInicial=$precioInicial&precioFinal=$precioFinal&tipo=$dropdownValue',"Productos Filtrados");
                          Navigator.pushNamed(context, '/home');
                        },
                        child: Text(
                          "Aplicar filtros",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
