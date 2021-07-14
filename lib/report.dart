import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:walkerholic/report_form.dart';
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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.only(top: statusBarHeight)),
        Text('최근 민원 사항'),
        SizedBox(
          height: statusHeight * 0.01,
        ),
        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: FutureBuilder<List<issue>>(
              future: fetchissues(http.Client()),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);

                return snapshot.hasData
                    ? issueList(issues: snapshot.data)
                    : Center(child: CircularProgressIndicator());
              }),
          height: statusHeight * 0.4,
        ),
        SizedBox(
          height: statusHeight * 0.1,
        ),
        Text('민원 신고'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Material(
              child: InkWell(
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: Icon(Icons.playlist_add_outlined),
                ),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (ctx) => report_form(
                              img_set: false,
                              imagePath: '',
                            )),
                  );
                },
              ),
            ),
          ],
        ),
        SizedBox(
          height: statusHeight * 0.1,
        ),
      ],
    );
  }
}
