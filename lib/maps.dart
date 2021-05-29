import 'dart:async';
import 'dart:typed_data';

import 'package:background_location/background_location.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';
import 'package:walkerholic/location/getnearest.dart';
import 'location/locationservice.dart';
import 'dart:ui' as ui;
import 'location/user_location.dart';
import 'location/getnearest.dart';
import 'main.dart';
//import 'main.dart';
//import 'main.dart';

class MyMaps extends StatefulWidget {
  @override
  _MyMaps createState() => _MyMaps();
}

class _MyMaps extends State<MyMaps> {
  GoogleMapController mapController;
  LatLng _initialcameraposition = LatLng(35.133134, 129.101699);
  LatLng simin_l = LatLng(35.168693, 129.057662);
  LatLng unitedn_l = LatLng(35.127479, 129.098139);
  LatLng gwang_l = LatLng(35.140535, 129.117227);

  //GoogleMapController _controller;
  //loc.Location _location = loc.Location();

  BitmapDescriptor simin_icon;
  BitmapDescriptor unitedn_icon;
  BitmapDescriptor gwang_icon;

  String site = getnearestsite.getsite();
  String status = '대기중';
  String nearestsiteimgpass = 'assets/loadings.gif';

  //getnearestsite nearestsite = new getnearestsite();

  Set<Marker> _markers = {};

  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    seticon_img();
    //print('initstateddd');
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  Future<BitmapDescriptor> getBitmapDescriptorFromAssetBytes(
      String path, int width) async {
    final Uint8List imageData = await getBytesFromAsset(path, width);
    return BitmapDescriptor.fromBytes(imageData);
  }

  void seticon_img() async {
    simin_icon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 0.2), 'assets/marker_simin.png');
    unitedn_icon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 0.2), 'assets/marker_unitedn.png');
    gwang_icon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 0.2), 'assets/marker_gwang.png');
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId('simin_mid'),
          position: simin_l,
          icon: simin_icon,
          infoWindow: InfoWindow(title: '시민공원', snippet: '눈누난나')));
      _markers.add(Marker(
          markerId: MarkerId('unitedn_mid'),
          position: unitedn_l,
          icon: unitedn_icon,
          infoWindow: InfoWindow(title: '유엔공원', snippet: '눈누난나')));
      _markers.add(Marker(
          markerId: MarkerId('gwang_mid'),
          position: gwang_l,
          icon: gwang_icon,
          infoWindow: InfoWindow(title: '광안리', snippet: '눈누난나')));
    });
    mapController = _cntlr;

    /*_location.onLocationChanged.listen((l) {
      _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 15),
      ));
    });*/
  }

  void setnearestimg() {
    if (site == '시민공원')
      nearestsiteimgpass = 'assets/img_simin.jpg';
    else if (site == '유엔공원')
      nearestsiteimgpass = 'assets/img_unitedn.jpg';
    else
      nearestsiteimgpass = 'assets/img_gwang.jpg';
  }

  @override
  Widget build(BuildContext context) {
    //var userLocation = Provider.of<UserLocation>(context);
    final double statusBarHeight =
        MediaQuery.of(context).padding.top; //기기의 상태창 크기
    final double statusHeight = (MediaQuery.of(context).size.height -
        statusBarHeight -
        MediaQuery.of(context).padding.bottom); // 기기의 화면크기

    //BackgroundLocation.startLocationService();
    BackgroundLocation.getLocationUpdates((_location) async {
      userlocation_global = LatLng(_location.latitude, _location.longitude);
      getnearestsite.setnearest(userlocation_global);
      setState(() {
        site = getnearestsite.getsite();
        setnearestimg();
      });
      //print(getnearestsite.getsite());
      //print(nearestlocation_global.getsite());
    });
    const myduration = const Duration(seconds: 5);
    //new Timer(myduration, () {
    //setState(() {

    //print(site);
    //});
    //});

    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: statusBarHeight)),
            SizedBox(
              height: statusHeight * 0.05,
              child: Row(
                children: [
                  Text('현재 상태 : $status'),
                  Text('                '),
                  Text('가장 가까운 산책지 : $site'),
                ],
              ),
            ),
            Container(
              height: statusHeight * 0.65,
              child: Stack(children: [
                GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: _initialcameraposition, zoom: 15),
                  mapType: MapType.normal,
                  onMapCreated: _onMapCreated,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  markers: _markers,
                  mapToolbarEnabled: false,
                ),
                SafeArea(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                      child: ClipOval(
                        child: Material(
                          color: Colors.orange[100], // button color
                          child: InkWell(
                            splashColor: Colors.orange, // inkwell color
                            child: SizedBox(
                              width: 56,
                              height: 56,
                              child: Icon(Icons.my_location),
                            ),
                            onTap: () {
                              mapController.animateCamera(
                                CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    target: userlocation_global,
                                    zoom: 15.0,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
                      child: ClipOval(
                        child: Material(
                          color: Colors.orange[100], // button color
                          child: InkWell(
                            splashColor: Colors.orange, // inkwell color
                            child: SizedBox(
                              width: 56,
                              height: 56,
                              child: Icon(Icons.run_circle_outlined),
                            ),
                            onTap: () {
                              //산책 시작, 상태 설정, 경로나타내는 메서드
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
            Image(
                height: statusHeight * 0.3,
                image: AssetImage(nearestsiteimgpass)),
          ],
        ),
      ),
    );
  }
}

/*
Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  Future<BitmapDescriptor> getBitmapDescriptorFromAssetBytes(
      String path, int width) async {
    final Uint8List imageData = await getBytesFromAsset(path, width);
    return BitmapDescriptor.fromBytes(imageData);
  }

simin_icon =
        await getBitmapDescriptorFromAssetBytes('assets/marker_simin.png', 400);
    unitedn_icon = await getBitmapDescriptorFromAssetBytes(
        'assets/marker_unitedn.png', 400);
    gwang_icon =
        await getBitmapDescriptorFromAssetBytes('assets/marker_gwang.png', 400);*/
