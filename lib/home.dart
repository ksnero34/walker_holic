import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'maps.dart';
//import 'main.dart';

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    final double statusBarHeight =
        MediaQuery.of(context).padding.top; //기기의 상태창 크기
    final double statusHeight = (MediaQuery.of(context).size.height -
        statusBarHeight -
        MediaQuery.of(context).padding.bottom); // 기기의 화면크기
    final double statuswidth = MediaQuery.of(context).size.width;

    navigatetomap(BuildContext ctx) async {
      await Navigator.push(
        ctx,
        MaterialPageRoute(builder: (ctx) => MyMaps()),
      );
    }

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      //Padding(padding: EdgeInsets.only(top: statusBarHeight)),
      //SizedBox(
      //height: statusHeight * 0.05,
      //),

      GestureDetector(
        onTap: () {
          print('pressedddd');
          setState(() {
            navigatetomap(context);
          });
        },
        child: Container(
          child: Row(
            children: [
              Image(
                  width: statuswidth * 0.33,
                  image: AssetImage('assets/map_jin.png')),
              Image(
                  width: statuswidth * 0.33,
                  image: AssetImage('assets/map_nam.png')),
              Image(
                  width: statuswidth * 0.33,
                  image: AssetImage('assets/map_soo.png')),
            ],
          ),
        ),
      ),
      SizedBox(
        height: statusHeight * 0.2,
      )
    ]);
  }
}
