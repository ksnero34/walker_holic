import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<issue>> fetchissues(http.Client client) async {
  String url = 'http://211.219.250.41/notice';
  final response = await client.get(Uri.parse(url));
  print(response.body);
  final utfdata = utf8.decode(response.bodyBytes);
  return compute(parseissues, utfdata);
}

List<issue> parseissues(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<issue>((json) => issue.fromJson(json)).toList();
}

class issue {
  final int id;
  final String title;
  final String body;

  issue({this.id, this.title, this.body});

  factory issue.fromJson(Map<String, dynamic> json) {
    return issue(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['url'] as String,
    );
  }
}

Widget issue_pressed(BuildContext context, String title, String subject) {
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

class issueList extends StatelessWidget {
  List<issue> issues;

  issueList({Key key, this.issues}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // return ListTile(
    //   leading: Icon(Icons.notifications_active),
    //   title : Text(notices[index]),
    // );
    return ListView.builder(
        itemCount: issues.length,
        itemBuilder: (context, index) {
          return Material(
            child: ListTile(
              leading: Icon(Icons.warning),
              title: Text(issues[index].title),
              subtitle: Text(issues[index].body),
              //trailing: Text(notices[index].body),
              onTap: () {
                showDialog(
                  context: context,
                  //barrierDismissible: false,
                  builder: (BuildContext context) {
                    return issue_pressed(
                        context, issues[index].title, issues[index].body);
                  },
                );
              },
              isThreeLine: true,
            ),
          );
        });
  }
}
