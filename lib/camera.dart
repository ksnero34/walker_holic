import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'main.dart';

import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

// A screen that allows users to take a picture using a given camera.
class Camera extends StatefulWidget {
  final loadingWidget;
  Camera({this.loadingWidget});

  @override
  CameraState createState() => CameraState();
}

class CameraState extends State<Camera> with WidgetsBindingObserver {
  CameraController _controller;
  List<CameraDescription> _cameras;

  int _selected = 0;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    setupCamera();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  Future<void> setupCamera() async {
    await [
      Permission.camera,
    ].request();
    _cameras = await availableCameras();
    var controller = await selectCamera();
    setState(() => _controller = controller);
  }

  selectCamera() async {
    var controller =
        CameraController(_cameras[_selected], ResolutionPreset.max);
    await controller.initialize();
    return controller;
  }

  Future<void> takePicture() async {
    try {
      final DateFormat formatter = DateFormat('yyyyMMddHHmmss');
      String fileName = 'image_${formatter.format(DateTime.now())}';

      final Directory directory = await getApplicationDocumentsDirectory();
      var _imagesFolder = Directory(join('${directory.path}', 'gallery'));
      if (!_imagesFolder.existsSync()) {
        _imagesFolder.createSync();
      }

      final String path = '${_imagesFolder.path}/$fileName.png';
      await _controller.takePicture();
    } catch (e) {
      print(e);
    }
  }

  toggleCamera() async {
    int newSelected = (_selected + 1) % _cameras.length;
    _selected = newSelected;

    var controller = await selectCamera();
    setState(() => _controller = controller);
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight =
        MediaQuery.of(context).padding.top; //기기의 상태창 크기
    final double statusHeight = (MediaQuery.of(context).size.height -
        statusBarHeight -
        MediaQuery.of(context).padding.bottom); // 기기의 화면크기
    return Column(
        //appBar: AppBar(title: const Text('Take a picture')),
        // You must wait until the controller is initialized before displaying the
        // camera preview. Use a FutureBuilder to display a loading spinner until the
        // controller has finished initializing.
        children: [
          Padding(padding: EdgeInsets.only(top: statusBarHeight)),
          Container(
              height: statusHeight * 0.6,
              child: FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (_controller == null) {
                    if (widget.loadingWidget != null) {
                      return widget.loadingWidget;
                    } else {
                      return Container(
                        color: Colors.black,
                      );
                    }
                  } else {
                    return CameraPreview(_controller);
                  }
                },
              )),
          SizedBox(
            height: statusHeight * 0.02,
          ),
          FloatingActionButton(
            // Provide an onPressed callback.
            onPressed: () async {
              // Take the Picture in a try / catch block. If anything goes wrong,
              // catch the error.
              try {
                // Ensure that the camera is initialized.
                await _initializeControllerFuture;

                // Attempt to take a picture and get the file `image`
                // where it was saved.
                final image = await _controller.takePicture();

                // If the picture was taken, display it on a new screen.
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DisplayPictureScreen(
                      // Pass the automatically generated path to
                      // the DisplayPictureScreen widget.
                      imagePath: image.path,
                    ),
                  ),
                );
              } catch (e) {
                // If an error occurs, log the error to the console.
                print(e);
              }
            },
            child: const Icon(Icons.camera_alt),
          ),
          SizedBox(
            height: statusHeight * 0.1,
          ),
        ]);
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, @required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight =
        MediaQuery.of(context).padding.top; //기기의 상태창 크기
    final double statusHeight = (MediaQuery.of(context).size.height -
        statusBarHeight -
        MediaQuery.of(context).padding.bottom); // 기기의 화면크기
    return Scaffold(
      //appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsets.only(top: statusBarHeight)),
          Container(
              height: statusHeight * 0.7, child: Image.file(File(imagePath))),
        ],
      ),
    );
  }
}
