import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Camara extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Camara> {
  File _image;
  final picker = ImagePicker();
  Future getImage() async {
          final pickedFile=await picker.getImage(source: ImageSource.camera);
          var image= File(pickedFile.path);
  

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleccione una imagen de perfil'),
      ),
      body: Center(
        child: _image == null
            ? Text('No ha seleccionado una imagen.')
            : Image.file(_image),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Imagen',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}