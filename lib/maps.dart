import 'dart:async';
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
    Image.asset('assets/img_simin.jpg'),
    Image.asset('assets/img_simin.jpg'),
    Image.asset('assets/img_simin.jpg')
  ];
  final pictureLists_unitedn = [
    Image.asset('assets/img_unitedn.jpg'),
    Image.asset('assets/img_unitedn.jpg'),
    Image.asset('assets/img_unitedn.jpg')
  ];
  final pictureLists_gwang = [
    Image.asset('assets/img_gwang.jpg'),
    Image.asset('assets/img_gwang.jpg'),
    Image.asset('assets/img_gwang.jpg')
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
  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    seticon_img();
    if (user_status.check_status()) {
      status = '산책중';
    } else
      status = '대기중';
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
    if (user_status.check_status()) _calculateDistance(destination_set);
    /*_location.onLocationChanged.listen((l) {
      _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 15),
      ));
    });*/
  }

  void set_destinationimg(String destiantion) {
    if (destiantion == '시민공원')
      pictureLists = pictureLists_simin;
    else if (destiantion == '유엔공원')
      pictureLists = pictureLists_unitedn;
    else if (destiantion == '광안리')
      pictureLists = pictureLists_gwang;
    else
      pictureLists = pictureLists_init;
  }

  _createPolylines(String destination) {
    //인수 넘겨받아서 if문으로 산책지에 맞는 polyline 주면 될듯
    polylines.add(Polyline(
      polylineId: PolylineId('poly'),
      visible: true,
      color: Colors.blue,
      points: _createPoints(destination),
      width: 5,
    ));
  }

  //destination 에 따라 폴리라인 그릴 좌표 반환
  List<LatLng> _createPoints(String destination) {
    final List<LatLng> points = <LatLng>[];
    if (destination == '시민공원') {
      points.add(LatLng(35.133275, 129.101065));
      points.add(LatLng(35.131752, 129.101332));
      points.add(LatLng(35.129989, 129.105215));
    } else if (destination == '유엔공원') {
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

  void set_init_walking(String destination) {}

  //산책지 위치 눌렀을 경우 실행될 메서드들
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
          title: '현재 위치',
        ),
        icon: current_icon,
      );
      if (destination == '시민공원') {
        destinationMarker = Marker(
            markerId: MarkerId('simin_mid'),
            position: simin_l,
            icon: simin_icon,
            infoWindow: InfoWindow(title: '시민공원', snippet: '눈누난나'));
        destinationCoordinates =
            Position(latitude: simin_l.latitude, longitude: simin_l.longitude);
      } else if (destination == '유엔공원') {
        destinationMarker = Marker(
            markerId: MarkerId('unitedn_mid'),
            position: unitedn_l,
            icon: unitedn_icon,
            infoWindow: InfoWindow(title: '유엔공원', snippet: '눈누난나'));
        destinationCoordinates = Position(
            latitude: unitedn_l.latitude, longitude: unitedn_l.longitude);
      } else {
        destinationMarker = Marker(
            markerId: MarkerId('gwang_mid'),
            position: gwang_l,
            icon: gwang_icon,
            infoWindow: InfoWindow(title: '광안리', snippet: '눈누난나'));
        destinationCoordinates =
            Position(latitude: gwang_l.latitude, longitude: gwang_l.longitude);
      }
      // Destination Location Marker

      // Adding the markers to the list
      markers.add(startMarker);
      markers.add(destinationMarker);

      print('START COORDINATES: $startCoordinates');
      print('DESTINATION COORDINATES: $destinationCoordinates');

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

      // 구글 api상 국내에선 도보사용 불가
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
        print('DISTANCE: $_placeDistance m');
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
        MediaQuery.of(context).padding.top; //기기의 상태창 크기
    final double statusHeight = (MediaQuery.of(context).size.height -
        statusBarHeight -
        MediaQuery.of(context).padding.bottom); // 기기의 화면크기

    //BackgroundLocation.startLocationService();

    //사용자의 위치 바뀔때 마다 처리할 내용 있으면 여기서 처리
    BackgroundLocation.getLocationUpdates((_location) async {
      userlocation_global = LatLng(_location.latitude, _location.longitude);
      getnearestsite.setnearest(userlocation_global);
      if (site != getnearestsite.getsite()) {
        setState(() {
          site = getnearestsite.getsite();
          //if (status == '산책중') set_destinationimg(destination_set);
        });
      }
      //print(getnearestsite.getsite());
      //print(nearestlocation_global.getsite());
    });
    //주기적으로 처리할 내용 있을경우 여기서처리
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
                  Text('  '),
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
                  markers: markers,
                  mapToolbarEnabled: false,
                  polylines: polylines,
                ),
                // 현재위치 버튼
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
                              if (status != '산책중') {
                                destination_set = '';
                                setState(() {
                                  if (markers.isNotEmpty) markers.clear();
                                  if (polylines.isNotEmpty) polylines.clear();
                                  _placeDistance = null;
                                  set_destinationimg(destination_set);
                                });
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
                //화면 상단 버튼 세개 배치
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
                              width: 56,
                              height: 56,
                              child: Icon(Icons.run_circle_outlined),
                            ),
                            onTap: () async {
                              if (status != '산책중') {
                                destination_set = '시민공원';
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
                              }
                              //산책 시작, 상태 설정, 경로나타내는 메서드
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
                              width: 56,
                              height: 56,
                              child: Icon(Icons.run_circle_outlined),
                            ),
                            onTap: () async {
                              if (status != '산책중') {
                                destination_set = '유엔공원';
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
                                //산책 시작, 상태 설정, 경로나타내는 메서드
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
                              width: 56,
                              height: 56,
                              child: Icon(Icons.run_circle_outlined),
                            ),
                            onTap: () async {
                              if (status != '산책중') {
                                destination_set = '광안리';
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
                                //산책 시작, 상태 설정, 경로나타내는 메서드
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //화면 상단 세개 아이콘 끝
                //산책시작, 종료 아이콘
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
                            onTap: () async {
                              if (walking_ready) {
                                setState(() {
                                  status = '산책중';
                                });
                                user_status.start_walk(
                                    destination_set, userlocation_global);
                                walking_ready = false;
                              } else {
                                if (status == '산책중') {
                                  user_status.end_walk();
                                  setState(() {
                                    status = '대기중';
                                    destination_set = '';
                                    set_destinationimg(destination_set);
                                    if (markers.isNotEmpty) markers.clear();
                                    if (polylines.isNotEmpty) polylines.clear();
                                    _placeDistance = null;
                                  });
                                  mapController.animateCamera(
                                    CameraUpdate.newCameraPosition(
                                      CameraPosition(
                                        target: userlocation_global,
                                        zoom: 15.0,
                                      ),
                                    ),
                                  );
                                } else {
                                  //산책먼저하라는 메시지 알려주기
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
                    height: statusHeight * 0.3, autoPlay: false),
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
