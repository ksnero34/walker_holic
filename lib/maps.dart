import 'dart:async';
//import 'dart:html';
import 'dart:math';
import 'dart:typed_data';

import 'package:background_location/background_location.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:location/location.dart' as loc;
import 'package:geolocator/geolocator.dart';
//import 'package:provider/provider.dart';
import 'package:walkerholic/location/getnearest.dart';
import 'package:walkerholic/status/user_status.dart';
//import 'location/locationservice.dart';
import 'dart:ui' as ui;
//import 'location/user_location.dart';
import 'location/getnearest.dart';
import 'main.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'status/user_status.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:geocoding/geocoding.dart';
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

  String _placeDistance;

  List<Image> pictureLists = [Image.asset('assets/loadings.gif')];
  final pictureLists_init = [Image.asset('assets/loadings.gif')];
  final pictureLists_simin = [
    Image.asset('assets/simin1.png'),
    Image.asset('assets/simin2.png'),
    Image.asset('assets/simin3.png'),
    Image.asset('assets/simin4.png'),
    Image.asset('assets/simin5.png'),
  ];
  final pictureLists_unitedn = [
    Image.asset('assets/unitedn1.png'),
    Image.asset('assets/unitedn2.png'),
    Image.asset('assets/unitedn3.png'),
    Image.asset('assets/unitedn4.png'),
    Image.asset('assets/unitedn5.png'),
  ];
  final pictureLists_gwang = [
    Image.asset('assets/gwang1.png'),
    Image.asset('assets/gwang2.png'),
    Image.asset('assets/gwang3.png'),
    Image.asset('assets/gwang4.png'),
    Image.asset('assets/gwang5.png'),
    Image.asset('assets/gwang6.png'),
  ];

  //GoogleMapController _controller;
  //loc.Location _location = loc.Location();

  BitmapDescriptor simin_icon;
  BitmapDescriptor unitedn_icon;
  BitmapDescriptor gwang_icon;
  BitmapDescriptor current_icon;

  String site = getnearestsite.getsite();
  String status;
  String nearestsiteimgpass = 'assets/loadings.gif';

  //getnearestsite nearestsite = new getnearestsite();

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  bool walking_ready = false;
  String destination_set = user_status.get_destination();
  String upperstatus;

  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    seticon_img();
    if (user_status.check_status()) {
      status = '?????????';
    } else
      status = '?????????';
    if (status == '?????????')
      upperstatus = '?????? ????????? : $destination_set';
    else
      upperstatus = '?????? ????????? ????????? : $site';
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
    current_icon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 0.2), 'assets/ic_icon.png');
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    mapController = _cntlr;
    if (user_status.check_status()) {
      _calculateDistance(destination_set);
      set_destinationimg(destination_set);
    }
    /*_location.onLocationChanged.listen((l) {
      _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 15),
      ));
    });*/
  }

  void set_destinationimg(String destination) {
    if (destination == '????????????')
      pictureLists = pictureLists_simin;
    else if (destination == '????????????')
      pictureLists = pictureLists_unitedn;
    else if (destination == '?????????')
      pictureLists = pictureLists_gwang;
    else
      pictureLists = pictureLists_init;
  }

  _createPolylines(String destination) {
    //?????? ??????????????? if????????? ???????????? ?????? polyline ?????? ??????
    polylines.add(Polyline(
      polylineId: PolylineId('poly'),
      visible: true,
      color: Colors.blue,
      points: _createPoints(destination),
      width: 5,
    ));
  }

  //destination ??? ?????? ???????????? ?????? ?????? ??????
  List<LatLng> _createPoints(String destination) {
    final List<LatLng> points = <LatLng>[];
    if (destination == '????????????') {
      points.add(LatLng(35.133275, 129.101065));
      points.add(LatLng(35.131752, 129.101332));
      points.add(LatLng(35.129989, 129.105215));
    } else if (destination == '????????????') {
      points.add(LatLng(35.133275, 129.101065));
      points.add(LatLng(35.131752, 129.101332));
      points.add(LatLng(35.129989, 129.105215));
    } else {
      points.add(LatLng(35.139962, 129.117072));
      points.add(LatLng(35.146006, 129.117182));
      points.add(LatLng(35.146071, 129.114713));
      points.add(LatLng(35.147075, 129.114344));
      points.add(LatLng(35.149061, 129.114954));
      points.add(LatLng(35.153469, 129.118390));
      points.add(LatLng(35.154532, 129.120116));
      points.add(LatLng(35.155673, 129.123524));
      points.add(LatLng(35.152968, 129.124462));
    }

    return points;
  }

  //void set_init_walking(String destination) {}

  //????????? ?????? ????????? ?????? ????????? ????????????
  Future<bool> _calculateDistance(String destination) async {
    try {
      Position startCoordinates = Position(
          latitude: userlocation_global.latitude,
          longitude: userlocation_global.longitude);

      Position destinationCoordinates;

      Marker startMarker, destinationMarker;
      // Start Location Marker
      startMarker = Marker(
        markerId: MarkerId('userstartloc'),
        position: LatLng(
          startCoordinates.latitude,
          startCoordinates.longitude,
        ),
        infoWindow: InfoWindow(
          title: '?????? ??????',
        ),
        icon: current_icon,
      );
      if (destination == '????????????') {
        destinationMarker = Marker(
            markerId: MarkerId('simin_mid'),
            position: simin_l,
            icon: simin_icon,
            infoWindow: InfoWindow(title: '????????????', snippet: '????????????'));
        destinationCoordinates =
            Position(latitude: simin_l.latitude, longitude: simin_l.longitude);
      } else if (destination == '????????????') {
        destinationMarker = Marker(
            markerId: MarkerId('unitedn_mid'),
            position: unitedn_l,
            icon: unitedn_icon,
            infoWindow: InfoWindow(title: '????????????', snippet: '????????????'));
        destinationCoordinates = Position(
            latitude: unitedn_l.latitude, longitude: unitedn_l.longitude);
      } else {
        destinationMarker = Marker(
            markerId: MarkerId('gwang_mid'),
            position: gwang_l,
            icon: gwang_icon,
            infoWindow: InfoWindow(title: '?????????', snippet: '????????????'));
        destinationCoordinates =
            Position(latitude: gwang_l.latitude, longitude: gwang_l.longitude);
      }
      // Destination Location Marker

      // Adding the markers to the list
      markers.add(startMarker);
      markers.add(destinationMarker);

      // print('START COORDINATES: $startCoordinates');
      // print('DESTINATION COORDINATES: $destinationCoordinates');

      final LatLng southwest = LatLng(
        min(startCoordinates.latitude, destinationCoordinates.latitude),
        min(startCoordinates.longitude, destinationCoordinates.longitude),
      );

      final LatLng northeast = LatLng(
        max(startCoordinates.latitude, destinationCoordinates.latitude),
        max(startCoordinates.longitude, destinationCoordinates.longitude),
      );

      LatLngBounds bounds = LatLngBounds(
        southwest: southwest,
        northeast: northeast,
      );

      // Accomodate the two locations within the
      // camera view of the map
      mapController.animateCamera(
        CameraUpdate.newLatLngBounds(
          bounds,
          100.0,
        ),
      );

      // Calculating the distance between the start and the end positions
      // with a straight path, without considering any route
      // double distanceInMeters = await Geolocator().bearingBetween(
      //   startCoordinates.latitude,
      //   startCoordinates.longitude,
      //   destinationCoordinates.latitude,
      //   destinationCoordinates.longitude,
      // );

      //await _createPolylines(startCoordinates, destinationCoordinates);
      _createPolylines(destination);

      double totalDistance = getnearestsite.getDistance(
          userlocation_global,
          LatLng(destinationCoordinates.latitude,
              destinationCoordinates.longitude));

      // ?????? api??? ???????????? ???????????? ??????
      // for (int i = 0; i < polylineCoordinates.length - 1; i++) {
      //   totalDistance += _coordinateDistance(
      //     polylineCoordinates[i].latitude,
      //     polylineCoordinates[i].longitude,
      //     polylineCoordinates[i + 1].latitude,
      //     polylineCoordinates[i + 1].longitude,
      //   );
      // }

      setState(() {
        _placeDistance = totalDistance.toStringAsFixed(2);
        //print('????????? ?????? ?????? : $_placeDistance m');
      });

      return true;
    } catch (e) {
      print(e);
    }
  }

  // Create the polylines for showing the route between two places
  //_createPolylines(String destination) async {}

  @override
  Widget build(BuildContext context) {
    //var userLocation = Provider.of<UserLocation>(context);
    final double statusBarHeight =
        MediaQuery.of(context).padding.top; //????????? ????????? ??????
    final double statusHeight = (MediaQuery.of(context).size.height -
        statusBarHeight -
        MediaQuery.of(context).padding.bottom); // ????????? ????????????

    //BackgroundLocation.startLocationService();

    //???????????? ?????? ????????? ?????? ????????? ?????? ????????? ????????? ??????
    BackgroundLocation.getLocationUpdates((_location) async {
      userlocation_global = LatLng(_location.latitude, _location.longitude);
      getnearestsite.setnearest(userlocation_global);
      if (site != getnearestsite.getsite()) {
        setState(() {
          site = getnearestsite.getsite();
          if (status == '?????????') {
            mapController
                .animateCamera(CameraUpdate.newLatLng(userlocation_global));
          }
        });
      }
      //print(getnearestsite.getsite());
      //print(nearestlocation_global.getsite());
    });

    //??????????????? ????????? ?????? ???????????? ???????????????
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
                  Text('  '),
                  Text('?????? ?????? : $status'),
                  Text('                '),
                  Text(upperstatus),
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
                  markers: markers,
                  mapToolbarEnabled: false,
                  polylines: polylines,
                ),
                // ???????????? ??????
                SafeArea(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                      child: ClipOval(
                        child: Material(
                          color: Colors.white54, // button color
                          child: InkWell(
                            splashColor: Colors.white, // inkwell color
                            child: SizedBox(
                              width: 65,
                              height: 65,
                              child: Icon(Icons.my_location),
                            ),
                            onTap: () {
                              if (status != '?????????') {
                                destination_set = '';
                                setState(() {
                                  if (markers.isNotEmpty) markers.clear();
                                  if (polylines.isNotEmpty) polylines.clear();
                                  _placeDistance = null;
                                  set_destinationimg(destination_set);
                                });
                                if (walking_ready) {
                                  Fluttertoast.showToast(
                                    msg: '?????? ???????????? ???????????????!',
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 2,
                                  );
                                }
                                walking_ready = false;
                              }
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
                //?????? ?????? ?????? ?????? ??????
                SafeArea(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                      child: ClipOval(
                        child: Material(
                          color: Colors.orange[100], // button color
                          child: InkWell(
                            splashColor: Colors.orange, // inkwell color
                            child: SizedBox(
                              width: 65,
                              height: 65,
                              child: Image.asset('assets/simin_icon.png'),
                            ),
                            onTap: () async {
                              if (status != '?????????') {
                                destination_set = '????????????';
                                setState(() {
                                  set_destinationimg(destination_set);
                                });
                                setState(() {
                                  if (markers.isNotEmpty) markers.clear();
                                  if (polylines.isNotEmpty) polylines.clear();
                                  _placeDistance = null;
                                });
                                _calculateDistance(destination_set);
                                walking_ready = true;
                                Fluttertoast.showToast(
                                  msg:
                                      '?????? ???????????? ?????????????????? ???????????????!\n\n????????? ????????? ????????? $_placeDistance m ?????????!',
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 2,
                                );
                              }
                              //?????? ??????, ?????? ??????, ?????????????????? ?????????
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: ClipOval(
                        child: Material(
                          color: Colors.orange[100], // button color
                          child: InkWell(
                            splashColor: Colors.orange, // inkwell color
                            child: SizedBox(
                              width: 65,
                              height: 65,
                              child: Image.asset('assets/unitedn_icon.png'),
                            ),
                            onTap: () async {
                              if (status != '?????????') {
                                destination_set = '????????????';
                                setState(() {
                                  set_destinationimg(destination_set);
                                });
                                setState(() {
                                  if (markers.isNotEmpty) markers.clear();
                                  if (polylines.isNotEmpty) polylines.clear();
                                  _placeDistance = null;
                                });
                                _calculateDistance(destination_set);
                                walking_ready = true;
                                Fluttertoast.showToast(
                                  msg:
                                      '?????? ???????????? ?????????????????? ???????????????!\n\n????????? ????????? ????????? $_placeDistance m ?????????!',
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 2,
                                );
                                //?????? ??????, ?????? ??????, ?????????????????? ?????????
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0, top: 10.0),
                      child: ClipOval(
                        child: Material(
                          color: Colors.orange[100], // button color
                          child: InkWell(
                            splashColor: Colors.orange, // inkwell color
                            child: SizedBox(
                              width: 65,
                              height: 65,
                              child: Image.asset('assets/gwang_icon.png'),
                            ),
                            onTap: () async {
                              if (status != '?????????') {
                                destination_set = '?????????';
                                setState(() {
                                  set_destinationimg(destination_set);
                                });
                                setState(() {
                                  if (markers.isNotEmpty) markers.clear();
                                  if (polylines.isNotEmpty) polylines.clear();
                                  _placeDistance = null;
                                });
                                _calculateDistance(destination_set);
                                walking_ready = true;
                                Fluttertoast.showToast(
                                  msg:
                                      '?????? ???????????? ???????????? ???????????????!\n\n????????? ????????? ????????? $_placeDistance m ?????????!',
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 2,
                                );
                                //?????? ??????, ?????? ??????, ?????????????????? ?????????
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //?????? ?????? ?????? ????????? ???
                //????????????, ?????? ?????????
                SafeArea(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
                      child: ClipOval(
                        child: Material(
                          color: Colors.white54, // button color
                          child: InkWell(
                            splashColor: Colors.white, // inkwell color
                            child: SizedBox(
                              width: 65,
                              height: 65,
                              child: Image.asset('assets/ic_icon.png'),
                            ),
                            onTap: () async {
                              if (walking_ready) {
                                setState(() {
                                  status = '?????????';
                                  upperstatus = '?????? ????????? : $destination_set';
                                });
                                user_status.start_walk(
                                    destination_set, userlocation_global);
                                walking_ready = false;
                                Fluttertoast.showToast(
                                  msg: '????????? ???????????????!',
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 2,
                                );
                              } else {
                                if (status == '?????????') {
                                  user_status.end_walk();
                                  setState(() {
                                    status = '?????????';
                                    upperstatus = '?????? ????????? ????????? : $site';
                                    destination_set = '';
                                    set_destinationimg(destination_set);
                                    if (markers.isNotEmpty) markers.clear();
                                    if (polylines.isNotEmpty) polylines.clear();
                                    _placeDistance = null;
                                  });
                                  Fluttertoast.showToast(
                                    msg: '????????? ???????????????!',
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 2,
                                  );
                                  mapController.animateCamera(
                                    CameraUpdate.newCameraPosition(
                                      CameraPosition(
                                        target: userlocation_global,
                                        zoom: 15.0,
                                      ),
                                    ),
                                  );
                                } else {
                                  //????????????????????? ????????? ????????????
                                  Fluttertoast.showToast(
                                    msg: '???????????? ?????? ????????? ?????????!',
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 2,
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
            CarouselSlider(
                options: CarouselOptions(
                  height: statusHeight * 0.3,
                  autoPlay: true,
                  autoPlayAnimationDuration: Duration(seconds: 3),
                  autoPlayInterval: Duration(seconds: 8),
                ),
                items: pictureLists.map((image) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: image,
                        ),
                      );
                    },
                  );
                }).toList()),
            // Image(
            //     height: statusHeight * 0.3,
            //     image: AssetImage(nearestsiteimgpass)),
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
