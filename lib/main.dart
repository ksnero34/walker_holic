import 'package:flutter/material.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:walkerholic/badge.dart';
import 'package:walkerholic/camera.dart';
import 'package:walkerholic/maps.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: '부산폴짝',
      home: MyHomePage(),
    );
  }
}

// Main Screen
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> _pages = [camera(), MyMaps(), badge()];

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
          tabBuilder: (BuildContext context, index) {
            return _pages[index];
          }),
    );
  }
}
