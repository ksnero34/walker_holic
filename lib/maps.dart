import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:background_location/background_location.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';
import 'package:walkerholic/location/getnearest.dart';
import 'location/locationservice.dart';
import 'dart:ui' as ui;
import 'location/user_location.dart';
import 'location/getnearest.dart';
import 'main.dart';
//import 'location/site_poly.dart';

//import 'main.dart';
//import 'main.dart';

class MyMaps extends StatefulWidget {
  @override
  _MyMaps createState() => _MyMaps();
}

class _MyMaps extends State<MyMaps> {
  NaverMapController mapController;
  LatLng _initialcameraposition = LatLng(35.133134, 129.101699);
  LatLng simin_l = LatLng(35.168693, 129.057662);
  LatLng unitedn_l = LatLng(35.127479, 129.098139);
  LatLng gwang_l = LatLng(35.140535, 129.117227);
  //static const API_KEY = 'AIzaSyBD5fZj8nd9dubNHAn95BKm7DvzWl_m49s';
  //site_polyline site_polys;
  List<LatLng> latlist = <LatLng>[];
  //GoogleMapController _controller;
  //loc.Location _location = loc.Location();

  OverlayImage simin_icon;
  OverlayImage unitedn_icon;
  OverlayImage gwang_icon;

  String site = getnearestsite.getsite();
  String status = '대기중';
  String nearestsiteimgpass = 'assets/loadings.gif';

  //getnearestsite nearestsite = new getnearestsite();

  List<Marker> _markers = <Marker>[];
  //Set<Polyline> _polyline = {};
  LatLng test1 = LatLng(35.133275, 129.101065);
  LatLng test2 = LatLng(35.131752, 129.101332);
  LatLng test3 = LatLng(35.129989, 129.105215);

  //목적지까지 poly line 그릴 변수
  PolylinePoints polylinePoints;
  List<LatLng> polylineCoordinates = [];
  //Map<PolylineId, Polyline> polylines = {};

  String _placeDistance;

  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    seticon_img();
    //print('initstateddd');
  }

  // Future<Uint8List> getBytesFromAsset(String path, int width) async {
  //   ByteData data = await rootBundle.load(path);
  //   ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
  //       targetWidth: width);
  //   ui.FrameInfo fi = await codec.getNextFrame();
  //   return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
  //       .buffer
  //       .asUint8List();
  // }

  // Future<BitmapDescriptor> getBitmapDescriptorFromAssetBytes(
  //     String path, int width) async {
  //   final Uint8List imageData = await getBytesFromAsset(path, width);
  //   return BitmapDescriptor.fromBytes(imageData);
  // }

  void seticon_img() async {
    simin_icon = await OverlayImage.fromAssetImage(
        assetName: 'assets/marker_simin.png', context: context);
    unitedn_icon = await OverlayImage.fromAssetImage(
        assetName: 'assets/marker_unitedn.png', context: context);
    gwang_icon = await OverlayImage.fromAssetImage(
        assetName: 'assets/marker_gwang.png', context: context);
  }

  void setmarkers() {
    _markers.add(Marker(
        markerId: 'simin_mid',
        position: simin_l,
        icon: simin_icon,
        infoWindow: '시민공원'));
    _markers.add(Marker(
        markerId: 'unitedn_mid',
        position: unitedn_l,
        icon: unitedn_icon,
        infoWindow: '유엔공원'));
    _markers.add(Marker(
        markerId: 'gwang_mid',
        position: gwang_l,
        icon: gwang_icon,
        infoWindow: '광안리'));
  }

  void _onMapCreated(NaverMapController _cntlr) {
    setState(() {
      setmarkers();
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

  // _createPolylines() {
  //   //인수 넘겨받아서 if문으로 산책지에 맞는 polyline 주면 될듯
  //   PolylineId id = PolylineId('poly');
  //   Polyline polyline = Polyline(
  //     polylineId: id,
  //     color: Colors.blue,
  //     points: _createPoints(),
  //     width: 5,
  //   );
  //   polylines[id] = polyline;
  // }

  List<LatLng> _createPoints() {
    final List<LatLng> points = <LatLng>[];
    points.add(test1);
    points.add(test2);
    points.add(test3);
    return points;
  }

  Future<bool> _calculateDistance() async {
    try {
      Position startCoordinates = Position(
          latitude: userlocation_global.latitude,
          longitude: userlocation_global.longitude);

      Position destinationCoordinates = Position(
          latitude: unitedn_l.latitude, longitude: unitedn_l.longitude);

      // Start Location Marker
      Marker startMarker = Marker(
        position: LatLng(
          startCoordinates.latitude,
          startCoordinates.longitude,
        ),
        infoWindow: 'Start',
        //snippet: _startAddress,

        //icon: defa,
      );

      // Destination Location Marker
      Marker destinationMarker = Marker(
        markerId: '$destinationCoordinates',
        position: LatLng(
          destinationCoordinates.latitude,
          destinationCoordinates.longitude,
        ),
        infoWindow: 'Destination',
        //snippet: _destinationAddress,

        //icon: BitmapDescriptor.defaultMarker,
      );

      // Adding the markers to the list
      _markers.add(startMarker);
      _markers.add(destinationMarker);

      print('START COORDINATES: $startCoordinates');
      print('DESTINATION COORDINATES: $destinationCoordinates');

      Position _northeastCoordinates;
      Position _southwestCoordinates;

      // Calculating to check that the position relative
      // to the frame, and pan & zoom the camera accordingly.
      double miny =
          (startCoordinates.latitude <= destinationCoordinates.latitude)
              ? startCoordinates.latitude
              : destinationCoordinates.latitude;
      double minx =
          (startCoordinates.longitude <= destinationCoordinates.longitude)
              ? startCoordinates.longitude
              : destinationCoordinates.longitude;
      double maxy =
          (startCoordinates.latitude <= destinationCoordinates.latitude)
              ? destinationCoordinates.latitude
              : startCoordinates.latitude;
      double maxx =
          (startCoordinates.longitude <= destinationCoordinates.longitude)
              ? destinationCoordinates.longitude
              : startCoordinates.longitude;

      _southwestCoordinates = Position(latitude: miny, longitude: minx);
      _northeastCoordinates = Position(latitude: maxy, longitude: maxx);

      // Accommodate the two locations within the
      // camera view of the map
      //mapController.moveCamera(CameraUpdate.toCameraPosition(position))
      mapController.moveCamera(
        CameraUpdate.fitBounds(
          LatLngBounds(
            northeast: LatLng(
              _northeastCoordinates.latitude,
              _northeastCoordinates.longitude,
            ),
            southwest: LatLng(
              _southwestCoordinates.latitude,
              _southwestCoordinates.longitude,
            ),
          ),
          // padding
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

      //await _createPolylines();

      double totalDistance =
          getnearestsite.getDistance(userlocation_global, simin_l);

      // 본래 목적지까지 polyline따라 거리계산 => 구글맵으론 불가능하기때문에 산책지의 총 거리 계산으로 돌리기
      //
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
    return false;
  }

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
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
                NaverMap(
                  initialCameraPosition:
                      CameraPosition(target: _initialcameraposition, zoom: 15),
                  mapType: MapType.Basic,
                  onMapCreated: _onMapCreated,
                  locationButtonEnable: false,
                  //myLocationButtonEnabled: false,
                  //zoomControlsEnabled: false,

                  markers: _markers,
                  //polylines: Set<Polyline>.of(polylines.values),
                  //mapToolbarEnabled: false,
                ),
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
                                //경로나타내는 메서드
                                setState(() {
                                  //if (polylines.isNotEmpty) polylines.clear();
                                  if (polylineCoordinates.isNotEmpty)
                                    polylineCoordinates.clear();
                                  _markers.clear();
                                  setmarkers();
                                  _calculateDistance().then((isCalculated) {
                                    // if (isCalculated) {
                                    //   ScaffoldMessenger.of(context)
                                    //       .showSnackBar(
                                    //     SnackBar(
                                    //       content: Text(
                                    //           'Distance Calculated Sucessfully'),
                                    //     ),
                                    //   );
                                    // } else {
                                    //   ScaffoldMessenger.of(context)
                                    //       .showSnackBar(
                                    //     SnackBar(
                                    //       content: Text(
                                    //           'Error Calculating Distance'),
                                    //     ),
                                    //  );
                                    //}
                                    //_placeDistance = null;
                                  });
                                });
                              }),
                        ),
                      ),
                    ),
                  ),
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
                              setState(() {
                                //마커랑 폴리라인 있을경우 지움
                                //if (polylines.isNotEmpty) polylines.clear();
                                _markers.clear();
                                setmarkers();
                              });
                              mapController.moveCamera(
                                CameraUpdate.toCameraPosition(
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
                              //polyline testing
                              //await _createPolylines();
                              setState(() {
                                //_createPolylines();
                              });
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
