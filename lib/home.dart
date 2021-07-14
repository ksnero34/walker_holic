import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:walkerholic/board/notice.dart';
import 'package:http/http.dart' as http;
import 'board/latestissue.dart';
import 'maps.dart';

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

    return ListView(children: <Widget>[
      SizedBox(
        height: statusHeight * 0.1,
      ),
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        //Padding(padding: EdgeInsets.only(top: statusBarHeight)),
        //SizedBox(
        //height: statusHeight * 0.05,
        //),

        GestureDetector(
          onTap: () {
            //print('pressedddd');
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
          height: statusHeight * 0.01,
        ),
        Container(
          child: Text(
            '공지사항',
          ),
        ),
        SizedBox(
          height: statusHeight * 0.01,
        ),
        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: FutureBuilder<List<notice>>(
              future: fetchnotice(http.Client()),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);

                return snapshot.hasData
                    ? noticeList(notices: snapshot.data)
                    : Center(child: CircularProgressIndicator());
              }),
          height: statusHeight * 0.3,
        ),
        SizedBox(
          height: statusHeight * 0.01,
        ),
      ]),
    ]);
  }
}
