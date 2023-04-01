import 'dart:io';

import 'package:flutter/material.dart';

class ZoomPage extends StatelessWidget {
  final File imageFile;
  final String detectedObject;
  const ZoomPage({Key? key, required this.imageFile, required this.detectedObject}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zoom Page'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(child: Material(elevation:0,child: Image.file(imageFile))),
          Container(
            height: height*0.05,
            width: double.infinity,
            color: Colors.blueAccent,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(detectedObject,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: height*0.03,
                fontWeight: FontWeight.bold
              ),),
            ),
          )
        ],
      ),
    );
  }
}
