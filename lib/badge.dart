import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'main.dart';
import 'status/walk_history.dart';
import 'status/user_status.dart';

class badge extends StatefulWidget {
  @override
  _badgeState createState() => _badgeState();
}

class _badgeState extends State<badge> {
  String status = '';
  String simin_history;
  String unitedn_history;
  String gwang_history;

  List<String> gwang_badge = [
    'assets/badge_gwang_black.png',
    'assets/badge_gwang_black.png',
    'assets/badge_gwang_black.png'
  ];
  List<String> simin_badge = [
    'assets/badge_simin_black.png',
    'assets/badge_simin_black.png',
    'assets/badge_simin_black.png'
  ];
  List<String> unitedn_badge = [
    'assets/badge_unitedn_black.png',
    'assets/badge_unitedn_black.png',
    'assets/badge_unitedn_black.png'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (user_status.check_status())
      setState(() {
        status = '산책중';
      });
    else
      setState(() {
        status = '대기중';
      });
    // String start_time = DateFormat('yy/mm/dd Hm').format(start);
    //print('asdfasdf');
    //print(DateTime.parse(key_val.getString('시민공원')));
    // if ((DateTime.parse(key_val.getString('시민공원')) == null) ||
    //     (DateTime.parse(key_val.getString('시민공원')) == ''))
    //   simin_history = '00:00:00';
    // else
    simin_history =
        DateFormat('Hms').format(DateTime.parse(key_val.getString('시민공원')));
    // if (DateTime.parse(key_val.getString('유엔공원')) == null ||
    //     (DateTime.parse(key_val.getString('유엔공원')) == ''))
    //   unitedn_history = '00:00:00';
    // else
    unitedn_history =
        DateFormat('Hms').format(DateTime.parse(key_val.getString('유엔공원')));
    // if (DateTime.parse(key_val.getString('광안리')) == null ||
    //     (DateTime.parse(key_val.getString('광안리')) == ''))
    //   gwang_history = '00:00:00';
    // else
    gwang_history =
        DateFormat('Hms').format(DateTime.parse(key_val.getString('광안리')));

    if (key_val.getInt('광안리_밤') >= 5)
      gwang_badge[0] = 'assets/badge_gwang_night.png';
    if (key_val.getInt('광안리_낮') >= 5)
      gwang_badge[2] = 'assets/badge_gwang_day.png';
    if ((key_val.getInt('광안리_밤') + key_val.getInt('광안리_낮')) >= 5)
      gwang_badge[1] = 'assets/badge_gwang_gold.png';

    if (key_val.getInt('시민공원_밤') >= 5)
      gwang_badge[0] = 'assets/badge_simin_night.png';
    if (key_val.getInt('시민공원_낮') >= 5)
      gwang_badge[2] = 'assets/badge_simin_day.png';
    if ((key_val.getInt('시민공원_밤') + key_val.getInt('시민공원_낮')) >= 5)
      gwang_badge[1] = 'assets/badge_simin_gold.png';

    if (key_val.getInt('유엔공원_밤') >= 5)
      gwang_badge[0] = 'assets/badge_unitedn_night.png';
    if (key_val.getInt('유엔공원_낮') >= 5)
      gwang_badge[2] = 'assets/badge_unitedn_day.png';
    if ((key_val.getInt('유엔공원_밤') + key_val.getInt('유엔공원_낮')) >= 5)
      gwang_badge[1] = 'assets/badge_unitedn_gold.png';
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight =
        MediaQuery.of(context).padding.top; //기기의 상태창 크기
    final double statusHeight = (MediaQuery.of(context).size.height -
        statusBarHeight -
        MediaQuery.of(context).padding.bottom); // 기기의 화면크기

    const myduration = const Duration(seconds: 5);
    new Timer(myduration, () {
      if (user_status.check_status())
        setState(() {
          status = '산책중';
        });
      else
        setState(() {
          status = '대기중';
        });
      if (DateTime.parse(key_val.getString('시민공원')) !=
          null) if (simin_history != DateTime.parse(key_val.getString('시민공원')))
        setState(() {
          simin_history = DateFormat('Hms')
              .format(DateTime.parse(key_val.getString('시민공원')));
        });

      if (DateTime.parse(key_val.getString('유엔공원')) !=
          null) if (unitedn_history != DateTime.parse(key_val.getString('유엔공원')))
        setState(() {
          unitedn_history = DateFormat('Hms')
              .format(DateTime.parse(key_val.getString('유엔공원')));
        });

      if (DateTime.parse(key_val.getString('광안리')) != null) if (gwang_history !=
          DateTime.parse(key_val.getString('광안리')))
        setState(() {
          gwang_history = DateFormat('Hms')
              .format(DateTime.parse(key_val.getString('광안리')));
        });
    });

    Widget badge_pressed(BuildContext context, String badge) {
      String title = '테스팅중';
      String content = '이스터에그 테스트중';
      if (badge == 'gwang_1') {
        title = '광안리 산책길을 밤에 산책시 획득가능';
        content = '광안대교 야경과 함께!';
      } else if (badge == 'gwang_2') {
        title = '광안리 산책길을 5회 이상 산책시 획득가능';
        content = '광안리 마스터(ง •̀_•́)ง';
      } else if (badge == 'gwang_3') {
        title = '광안리 산책길을 낮에 산책시 획득가능';
        content = '시원한 바닷바람과 함께!';
      } else if (badge == 'simin_1') {
        title = '시민 공원을 밤에 산책시 획득가능';
        content = '밤하늘 별과함께!';
      } else if (badge == 'simin_2') {
        title = '시민 공원을 5회 이상 산책시 획득가능';
        content = '당신이 진정한 부산시민...!';
      } else if (badge == 'simin_3') {
        title = '시민 공원을 낮에 산책시 획득가능';
        content = '피크닉을 즐겨보세요(ㅇ_<)';
      } else if (badge == 'unitedn_1') {
        title = '유엔 공원을 밤에 산책시 획득가능';
        content = '산책도 좋지만 덥지 않나요..?';
      } else if (badge == 'unitedn_2') {
        title = '유엔 공원을 5회 이상 산책시 획득가능';
        content = '산책도 좋지만 덥지 않나요..?';
      } else if (badge == 'unitedn_3') {
        title = '유엔 공원을 낮에 5회 이상 산책시 획득가능';
        content = '산책도 좋지만 덥지 않나요..?';
      }

      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        title: Text(title),
        content: SingleChildScrollView(child: Text(content)),
        actions: <Widget>[
          new TextButton(
            child: Text("닫기"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    }

    // Text('badge'),
    // Row(
    //   children: [
    //     Text('산책여부 : '),
    //     Text('$status'),
    //   ],
    // ),
    // Text('산책 히스토리(시민공원)'),
    // Text(simin_history),
    // Text('산책 히스토리(유엔공원)'),
    // Text(unitedn_history),
    // Text('산책 히스토리(광안리)'),
    // Text(gwang_history),
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(height: statusBarHeight),
          Container(
            decoration: BoxDecoration(
              color: Colors.brown[100],
            ),
            height: statusHeight * 0.1,
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              '광안리 산책길',
              style: TextStyle(fontSize: statusHeight * 0.06),
            ),
          ),
          Container(
            height: statusHeight * 0.2,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.6), BlendMode.dstATop),
              image: AssetImage('assets/gwang1.png'),
            )),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ClipOval(
                    child: Material(
                      color: Colors.white, // button color
                      child: InkWell(
                        splashColor: Colors.white, // inkwell color
                        child: SizedBox(
                          width: statusHeight * 0.18,
                          height: statusHeight * 0.18,
                          child: Image.asset(gwang_badge[0]),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            //barrierDismissible: false,
                            builder: (BuildContext context) {
                              return badge_pressed(context, 'gwang_1');
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  ClipOval(
                    child: Material(
                      color: Colors.white, // button color
                      child: InkWell(
                        splashColor: Colors.white, // inkwell color
                        child: SizedBox(
                          width: statusHeight * 0.18,
                          height: statusHeight * 0.18,
                          child: Image.asset(gwang_badge[1]),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            //barrierDismissible: false,
                            builder: (BuildContext context) {
                              return badge_pressed(context, 'gwang_2');
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  ClipOval(
                    child: Material(
                      color: Colors.white, // button color
                      child: InkWell(
                        splashColor: Colors.white, // inkwell color
                        child: SizedBox(
                          width: statusHeight * 0.18,
                          height: statusHeight * 0.18,
                          child: Image.asset(gwang_badge[2]),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            //barrierDismissible: false,
                            builder: (BuildContext context) {
                              return badge_pressed(context, 'gwang_3');
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ]),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.brown[100],
            ),
            height: statusHeight * 0.1,
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              '부산 시민 공원',
              style: TextStyle(fontSize: statusHeight * 0.06),
            ),
          ),
          Container(
            height: statusHeight * 0.2,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.6), BlendMode.dstATop),
              image: AssetImage('assets/simin1.png'),
            )),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ClipOval(
                    child: Material(
                      color: Colors.white, // button color
                      child: InkWell(
                        splashColor: Colors.white, // inkwell color
                        child: SizedBox(
                          width: statusHeight * 0.18,
                          height: statusHeight * 0.18,
                          child: Image.asset(simin_badge[0]),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            //barrierDismissible: false,
                            builder: (BuildContext context) {
                              return badge_pressed(context, 'simin_1');
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  ClipOval(
                    child: Material(
                      color: Colors.white, // button color
                      child: InkWell(
                        splashColor: Colors.white, // inkwell color
                        child: SizedBox(
                          width: statusHeight * 0.18,
                          height: statusHeight * 0.18,
                          child: Image.asset(simin_badge[1]),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            //barrierDismissible: false,
                            builder: (BuildContext context) {
                              return badge_pressed(context, 'simin_2');
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  ClipOval(
                    child: Material(
                      color: Colors.white, // button color
                      child: InkWell(
                        splashColor: Colors.white, // inkwell color
                        child: SizedBox(
                          width: statusHeight * 0.18,
                          height: statusHeight * 0.18,
                          child: Image.asset(simin_badge[2]),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            //barrierDismissible: false,
                            builder: (BuildContext context) {
                              return badge_pressed(context, 'simin_3');
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ]),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.brown[100],
            ),
            height: statusHeight * 0.1,
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              '유엔공원',
              style: TextStyle(fontSize: statusHeight * 0.06),
            ),
          ),
          Container(
            height: statusHeight * 0.2,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.6), BlendMode.dstATop),
              image: AssetImage('assets/unitedn1.png'),
            )),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ClipOval(
                    child: Material(
                      color: Colors.white, // button color
                      child: InkWell(
                        splashColor: Colors.white, // inkwell color
                        child: SizedBox(
                          width: statusHeight * 0.18,
                          height: statusHeight * 0.18,
                          child: Image.asset(unitedn_badge[0]),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            //barrierDismissible: false,
                            builder: (BuildContext context) {
                              return badge_pressed(context, 'unitedn_1');
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  ClipOval(
                    child: Material(
                      color: Colors.white, // button color
                      child: InkWell(
                        splashColor: Colors.white, // inkwell color
                        child: SizedBox(
                          width: statusHeight * 0.18,
                          height: statusHeight * 0.18,
                          child: Image.asset(unitedn_badge[1]),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            //barrierDismissible: false,
                            builder: (BuildContext context) {
                              return badge_pressed(context, 'unitedn_2');
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  ClipOval(
                    child: Material(
                      color: Colors.white, // button color
                      child: InkWell(
                        splashColor: Colors.white, // inkwell color
                        child: SizedBox(
                          width: statusHeight * 0.18,
                          height: statusHeight * 0.18,
                          child: Image.asset(unitedn_badge[2]),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            //barrierDismissible: false,
                            builder: (BuildContext context) {
                              return badge_pressed(context, 'unitedn_3');
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ]),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.brown[100],
            ),
            height: statusHeight * 0.1,
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              '그외 다른지역',
              style: TextStyle(fontSize: statusHeight * 0.06),
            ),
          ),
        ],
      )),
    );
  }
}
