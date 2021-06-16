import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'board/latestissue.dart';

class report extends StatefulWidget {
  const report({Key key}) : super(key: key);

  @override
  report_State createState() => report_State();
}

class report_State extends State<report> {
  @override
  Widget build(BuildContext context) {
    final double statusBarHeight =
        MediaQuery.of(context).padding.top; //기기의 상태창 크기
    final double statusHeight = (MediaQuery.of(context).size.height -
        statusBarHeight -
        MediaQuery.of(context).padding.bottom); // 기기의 화면크기

    return Column(
      children: [
        Padding(padding: EdgeInsets.only(top: statusBarHeight)),
        ListView(children: <Widget>[
          // 리포트 양식 만들어야함
          Container(
            child: Text('최근 민원 사항'),
          ),
          SizedBox(
            height: statusHeight * 0.01,
          ),
          Container(
            child: FutureBuilder<List<issue>>(
                future: fetchissues(http.Client()),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);

                  return snapshot.hasData
                      ? issueList(issues: snapshot.data)
                      : Center(child: CircularProgressIndicator());
                }),
            height: statusHeight * 0.3,
          ),
        ]),
        SizedBox(
          height: statusHeight * 0.1,
        ),
      ],
    );
  }
}
