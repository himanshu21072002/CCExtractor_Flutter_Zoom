// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';

import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';

import 'main.dart';
import 'package:tflite/tflite.dart';
import 'zoom_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CameraController _cameraController;
  late Future<void> _initControllerFuture;
  File? _imageFile;
  List<dynamic>? _recognitions;
  double zoomLevel = 1;

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/ssd_mobilenet.tflite",
      labels: "assets/ssd_mobilenet.txt",
    );
  }

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(
      cameras![0],
      ResolutionPreset.medium,
    );
    _initControllerFuture = _cameraController.initialize();
    loadModel();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    setState(() {
      print('dispose abdb ioawbafobadb;buao d aan wid ap foas  se pf nefsef sf s');
    });
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initControllerFuture;
      final image = await _cameraController.takePicture();
      setState(() {
        _imageFile = File(image.path);
        _autoZoom(_imageFile!);
      });
    } catch (e) {
      print(e);
    }
  }

  void _autoZoom(File imageFile) async {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final recognitions = await Tflite.detectObjectOnImage(
      path: _imageFile!.path,
      model: "SSDMobileNet",
      threshold: 0.1,
      imageMean: 127.5,
      imageStd: 127.5,
      numResultsPerClass: 1,
    );
    setState(() {
      _recognitions = recognitions;
    });
    if (_recognitions != null && _recognitions!.isNotEmpty) {
      final recognition = _recognitions!.first;
      double w = recognition['rect']['w'];
      double h = recognition['rect']['h'];
      double x = width / w;
      double y = height / h;
      String detectedClass = recognition['detectedClass'].toString();
      setState(() {
        zoomLevel = min(x, y) / 400;
      });
      await _cameraController.setZoomLevel(zoomLevel);
      final camImage = await _cameraController.takePicture();
      setState(() {
         _cameraController.setZoomLevel(1);
        _imageFile = File(camImage.path);
      });

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ZoomPage(
                    imageFile: _imageFile!,
                    detectedObject: detectedClass,
                  ),),);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: CameraPreview(_cameraController),
          ),
          ElevatedButton(
            onPressed: _takePicture,
            child: const Icon(Icons.camera_alt),
          ),
        ],
      ),
    );
  }
}
