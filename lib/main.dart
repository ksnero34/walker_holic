import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:walkerholic/badge.dart';
import 'package:walkerholic/camera.dart';
//import 'package:walkerholic/location/user_location.dart';
import 'package:background_location/background_location.dart';
import 'package:walkerholic/location/getnearest.dart';
import 'package:walkerholic/status/user_status.dart';
import 'package:walkerholic/status/walk_history.dart';

import 'home.dart';
import 'location/locationservice.dart';
import 'location/user_location.dart';

LatLng userlocation_global;
//getnearestsite nearestlocation_global;
user_status status_global;
user_history history_global;
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      // Remove the debug
      debugShowCheckedModeBanner: false,
      title: '부산폴짝',
      home: MyHomePage(),
    );
  }
}

// Main Screen
class MyHomePage extends StatefulWidget {
  //const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> _pages = [camera(), home(), badge()];

  Widget mytabbuilder(BuildContext ctx, int index) {
    return _pages[index];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BackgroundLocation.startLocationService();
    BackgroundLocation.getLocationUpdates((_location) async {
      userlocation_global = LatLng(_location.latitude, _location.longitude);
      getnearestsite.setnearest(userlocation_global);
      //print(getnearestsite.getsite());
      //nearestlocation_global.setnearest(userlocation_global);

      //compute(nearestlocation_global.setnearest, userlocation_global);
      //print(userlocation_global.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight =
        MediaQuery.of(context).padding.top; //기기의 상태창 크기
    final double statusHeight = (MediaQuery.of(context).size.height -
        statusBarHeight -
        MediaQuery.of(context).padding.bottom); // 기기의 화면크기

    return CupertinoPageScaffold(
      child: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.camera_alt_outlined)),
              BottomNavigationBarItem(
                  icon: Image(
                      height: statusHeight * 0.3,
                      image: AssetImage('assets/loadings.gif'))),
              BottomNavigationBarItem(icon: Icon(Icons.location_searching))
            ],
          ),
          tabBuilder: mytabbuilder),
    );
  }
}

//tabBuilder: (BuildContext context, index) {
//          return _pages[index];
//      }

/*
위치 스트림
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserLocation>(
      create: (context) => LocationService().locationStream,
      //      builder: (context) => LocationService().locationStream,
      child: CupertinoApp(
        // Remove the debug
        debugShowCheckedModeBanner: false,
        title: '부산폴짝',
        home: MyHomePage(),
      ),
    );
  }
}

*/
