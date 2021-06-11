import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'status/walk_history.dart';
import 'status/user_status.dart';

class badge extends StatefulWidget {
  @override
  _badgeState createState() => _badgeState();
}

class _badgeState extends State<badge> {
  String status = '';

  @override
  Future<void> initState() {
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
          Text('산책 히스토리'),
        ],
      ),
    );
  }
}
