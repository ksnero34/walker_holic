import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
//import 'main.dart';

class MyMaps extends StatefulWidget {
  @override
  _MyMaps createState() => _MyMaps();
}

class _MyMaps extends State<MyMaps> {
  GoogleMapController mapController;

  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  GoogleMapController _controller;
  Location _location = Location();

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 15),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight =
        MediaQuery.of(context).padding.top; //기기의 상태창 크기
    final double statusHeight = (MediaQuery.of(context).size.height -
        statusBarHeight -
        MediaQuery.of(context).padding.bottom); // 기기의 화면크기
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: statusBarHeight)),
            SizedBox(
              height: statusHeight * 0.05,
            ),
            Container(
              height: statusHeight * 0.65,
              child: GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: _initialcameraposition),
                mapType: MapType.normal,
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
              ),
            ),
            Image(
                height: statusHeight * 0.3,
                image: AssetImage('assets/img_soo.jpg')),
          ],
        ),
      ),
    );
  }
}
