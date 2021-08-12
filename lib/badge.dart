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
        content = '광안대교 야경 존멋 ㅎ.ㅎ';
      } else if (badge == 'gwang_2') {
        title = '광안리 산책길을 5회 이상 산책시 획득가능';
        content = '(ง •̀_•́)ง';
      } else if (badge == 'gwang_3') {
        title = '광안리 산책길을 낮에 산책시 획득가능';
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
    return Material(
      child: Localizations(
          locale: const Locale('en', 'US'),
          delegates: <LocalizationsDelegate<dynamic>>[
            DefaultWidgetsLocalizations.delegate,
            DefaultMaterialLocalizations.delegate,
          ],
          child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  SizedBox(height: statusBarHeight),
                  SizedBox(
                    height: statusHeight * 0.1,
                    child: Text(
                      '광안리 산책길',
                      style: TextStyle(fontSize: statusHeight * 0.06),
                    ),
                  ),
                  SizedBox(
                    height: statusHeight * 0.2,
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
                                  child: Image.asset(
                                      'assets/badge_gwang_black.png'),
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
                                  child: Image.asset(
                                      'assets/badge_gwang_black.png'),
                                ),
                                onTap: () {},
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
                                  child: Image.asset(
                                      'assets/badge_gwang_black.png'),
                                ),
                                onTap: () {},
                              ),
                            ),
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: statusHeight * 0.1,
                    child: Text(
                      '부산 시민공원',
                      style: TextStyle(fontSize: statusHeight * 0.06),
                    ),
                  ),
                  SizedBox(
                    height: statusHeight * 0.2,
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
                                  child: Image.asset(
                                      'assets/badge_simin_black.png'),
                                ),
                                onTap: () {},
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
                                  child: Image.asset(
                                      'assets/badge_simin_black.png'),
                                ),
                                onTap: () {},
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
                                  child: Image.asset(
                                      'assets/badge_simin_black.png'),
                                ),
                                onTap: () {},
                              ),
                            ),
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: statusHeight * 0.1,
                    child: Text(
                      'UN공원',
                      style: TextStyle(fontSize: statusHeight * 0.06),
                    ),
                  ),
                  SizedBox(
                    height: statusHeight * 0.2,
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
                                  child: Image.asset(
                                      'assets/badge_unitedn_black.png'),
                                ),
                                onTap: () {},
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
                                  child: Image.asset(
                                      'assets/badge_unitedn_black.png'),
                                ),
                                onTap: () {},
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
                                  child: Image.asset(
                                      'assets/badge_unitedn_black.png'),
                                ),
                                onTap: () {},
                              ),
                            ),
                          ),
                        ]),
                  ),
                  SizedBox(
                    child: Text(
                      '그 외 다른 지역',
                      style: TextStyle(fontSize: statusHeight * 0.06),
                    ),
                  ),
                ],
              )))),
    );
  }
}
