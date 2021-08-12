import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walkerholic/badge.dart';
//import 'package:walkerholic/location/user_location.dart';
import 'package:background_location/background_location.dart';
import 'package:walkerholic/location/getnearest.dart';
import 'package:walkerholic/report.dart';
import 'package:walkerholic/report_form.dart';
import 'package:walkerholic/status/user_status.dart';
import 'package:walkerholic/status/walk_history.dart';
import 'package:is_first_run/is_first_run.dart';
import 'home.dart';
import 'package:camera/camera.dart';

LatLng userlocation_global;
//getnearestsite nearestlocation_global;
user_status status_global;
user_history history_global;

SharedPreferences key_val;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    title: '부산폴짝',
    initialRoute: '/',
    routes: {
      '/': (context) => MyApp(),
      '/reportform': (context) => report(),
    },
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      // Remove the debug
      debugShowCheckedModeBanner: false,
      title: '부산폴짝',
      home: MyHomePage(),
      localizationsDelegates: [
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
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
  List<Widget> _pages = [report(), home(), badge()];

  Widget mytabbuilder(BuildContext ctx, int index) {
    return _pages[index];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    set_keyval();

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

  Future<void> set_keyval() async {
    key_val = await SharedPreferences.getInstance();
    bool firstRun = await IsFirstRun.isFirstRun();
    if (firstRun) {
      String inittime = DateTime.parse('0000-01-01T00:00:00.000000').toString();
      key_val.setString('시민공원', inittime);
      key_val.setString('유엔공원', inittime);
      key_val.setString('광안리', inittime);
    }
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
            currentIndex: 1,
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
