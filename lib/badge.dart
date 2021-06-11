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
    if (DateTime.parse(key_val.getString('시민공원')) != null)
      simin_history =
          DateFormat('Hms').format(DateTime.parse(key_val.getString('시민공원')));
    else
      simin_history = '00:00:00';
    if (DateTime.parse(key_val.getString('유엔공원')) != null)
      unitedn_history =
          DateFormat('Hms').format(DateTime.parse(key_val.getString('유엔공원')));
    else
      unitedn_history = '00:00:00';
    if (DateTime.parse(key_val.getString('광안리')) != null)
      gwang_history =
          DateFormat('Hms').format(DateTime.parse(key_val.getString('광안리')));
    else
      gwang_history = '00:00:00';
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
    return Center(
      child: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: statusBarHeight)),
          Text('badge'),
          Row(
            children: [
              Text('산책여부 : '),
              Text('$status'),
            ],
          ),
          Text('산책 히스토리(시민공원)'),
          Text(simin_history),
          Text('산책 히스토리(유엔공원)'),
          Text(unitedn_history),
          Text('산책 히스토리(광안리)'),
          Text(gwang_history),
        ],
      ),
    );
  }
}
