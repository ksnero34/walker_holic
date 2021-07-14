import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:walkerholic/camera.dart';

class report_form extends StatefulWidget {
  @override
  _report_formState createState() => _report_formState();
}

class _report_formState extends State<report_form> {
  final titletext_cntr = TextEditingController();
  final contenttext_cntr = TextEditingController();
  String title_text = '';
  String content_text = '';
  Image report_img;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(8),
                        child: TextField(
                            controller: titletext_cntr,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: '민원 제목',
                            ),
                            onChanged: (title_text) {
                              setState(() {
                                title_text = titletext_cntr.text;
                              });
                            }),
                      ),
                      Container(
                        margin: EdgeInsets.all(8),
                        child: TextField(
                            controller: contenttext_cntr,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: '민원 내용',
                            ),
                            onChanged: (content_text) {
                              setState(() {
                                content_text = contenttext_cntr.text;
                              });
                            }),
                      ),
                      FloatingActionButton(
                          child: Icon(Icons.upload_file),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (ctx) => Camera()));
                          }),
                      FloatingActionButton(
                          child: Icon(Icons.upload_file),
                          onPressed: () {
                            //필수 내용 들어간지 확인후 처리할 메서드 추가필요.

                            Fluttertoast.showToast(
                              msg: '제보를 완료하였습니다!',
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                            );
                            Navigator.popUntil(
                                context, ModalRoute.withName('/'));
                          }),
                    ],
                  ),
                ))));
  }
}
