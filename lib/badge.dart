import 'package:flutter/cupertino.dart';
import 'status/walk_history.dart';
import 'status/user_status.dart';

class badge extends StatefulWidget {
  @override
  _badgeState createState() => _badgeState();
}

class _badgeState extends State<badge> {
  String status;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (user_status.check_status())
      status = '산책중';
    else
      status = '대기중';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
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
