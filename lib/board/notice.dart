import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<notice>> fetchnotice(http.Client client) async {
  String url = 'http://211.219.250.41/notice';
  final response = await client.get(Uri.parse(url));
  //print(response.body);
  final utfdata = utf8.decode(response.bodyBytes);
  return compute(parsenotices, utfdata);
}

List<notice> parsenotices(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  //print(parsed);
  return parsed.map<notice>((json) => notice.fromJson(json)).toList();
}

class notice {
  final int id;
  final String title;
  final String body;
  bool is_handled;

  notice({this.id, this.title, this.body});

  factory notice.fromJson(Map<String, dynamic> json) {
    return notice(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['content'] as String,
    );
  }
}

class noticeList extends StatelessWidget {
  List<notice> notices;

  noticeList({Key key, this.notices}) : super(key: key);

  Widget notice_pressed(BuildContext context, String title, String subject) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      title: Text(title),
      content: SingleChildScrollView(child: Text(subject)),
      actions: <Widget>[
        new TextButton(
          child: Text("Close"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // return ListTile(
    //   leading: Icon(Icons.notifications_active),
    //   title : Text(notices[index]),
    // );
    return ListView.builder(
      itemCount: notices.length,
      itemBuilder: (context, index) {
        return Material(
          child: ListTile(
            leading: Icon(Icons.notifications_active),
            title: Text(notices[notices.length - 1 - index].title),
            subtitle: Text(notices[notices.length - 1 - index].body),
            //trailing: Icon(Icons.alternate_email),
            onTap: () {
              showDialog(
                context: context,
                //barrierDismissible: false,
                builder: (BuildContext context) {
                  return notice_pressed(
                      context, notices[index].title, notices[index].body);
                },
              );
            },
            isThreeLine: true,
          ),
        );
      },
    );
  }
}
