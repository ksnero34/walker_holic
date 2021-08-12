import 'dart:convert';
import 'dart:io';

import 'package:background_location/background_location.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:walkerholic/main.dart';
import 'package:image_picker/image_picker.dart';

class report_form extends StatefulWidget {
  bool img_set;
  String imagePath;
  String title_text;
  String content_text;

  report_form({
    @required this.img_set,
    @required this.imagePath,
    @required this.title_text,
    @required this.content_text,
  });
  @override
  _report_formState createState() => _report_formState(
      imagePath: imagePath, title_text: title_text, content_text: content_text);
}

class _report_formState extends State<report_form> {
  final titletext_cntr = TextEditingController();
  final contenttext_cntr = TextEditingController();
  String title_text;
  String content_text;
  final String imagePath;
  bool img_set = false;
  _report_formState({this.imagePath, this.title_text, this.content_text});
  Image report_img;
  PickedFile _imagee;
  bool upload_ok = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //print(imagePath);

    report_img = Image.asset('assets/loadings.gif');
    upload_ok = false;
    titletext_cntr.text = title_text;
    contenttext_cntr.text = content_text;
  }

  Future<void> upload_server(String title, String content) async {
    try {
      String url = 'http://211.219.250.41/input_report_data';
      var uri = Uri.parse(url);
      //List<int> img_bytes = File(_imagee.path).readAsBytesSync();
      //String base64img = base64Encode(img_bytes);
      // var data = {
      //   "type": "report",
      //   "title": title,
      //   "content": content,
      //   "image": base64img,
      //   "latitude": userlocation_global.latitude.toString(),
      //   "longitude": userlocation_global.longitude.toString(),
      //   "date": DateTime.now().toString(),
      // };
      // var body = json.encode(data);
      // http.Response response = await http.post(uri, headers: <String, String>{
      //   "Content-Type": "application/x-www-form-urlencoded"
      // }, body: <String, String>{
      //   "type": "report",
      //   "title": title,
      //   "content": content,
      //   "image": base64img,
      //   "latitude": userlocation_global.latitude.toString(),
      //   "longitude": userlocation_global.longitude.toString(),
      //   "date": DateTime.now().toString(),
      // });
      BackgroundLocation.getLocationUpdates((_location) async {
        userlocation_global = LatLng(_location.latitude, _location.longitude);
      });
      var request = new http.MultipartRequest("POST", uri);

      request.fields['type'] = 'report';
      request.fields['title'] = title;
      request.fields['content'] = content;
      request.fields['latitude'] = userlocation_global.latitude.toString();
      request.fields['longitude'] = userlocation_global.longitude.toString();
      request.fields['date'] = DateTime.now().toString();
      //나머지 적기 테슽트후에

      request.files
          .add(await http.MultipartFile.fromPath('image', _imagee.path));

      var response = await request.send();

      //print(body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        setState(() {
          upload_ok = true;
        });
      }
      //print(userlocation_global.latitude);
    } on Exception catch (e) {
      // TODO
      print(e);
    }
  }

  Future getImageFromCam() async {
    // for camera
    var image = await ImagePicker.platform
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _imagee = image;
      report_img = Image.file(File(_imagee.path));
      img_set = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight =
        MediaQuery.of(context).padding.top; //기기의 상태창 크기
    final double statusHeight = (MediaQuery.of(context).size.height -
        statusBarHeight -
        MediaQuery.of(context).padding.bottom); // 기기의 화면크기
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
                      Padding(padding: EdgeInsets.only(top: statusBarHeight)),
                      Container(
                          margin: EdgeInsets.all(5),
                          child: Text(
                            '민원작성',
                            textScaleFactor: 5,
                          )),
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
                        height: 150,
                        child: TextField(
                            controller: contenttext_cntr,
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: null,
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
                      Container(
                        margin: EdgeInsets.all(8),
                        height: 200,
                        child: report_img,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FloatingActionButton(
                              heroTag: null,
                              child: Icon(Icons.camera),
                              onPressed: () {
                                getImageFromCam();
                              }),
                          FloatingActionButton(
                              heroTag: null,
                              child: Icon(Icons.upload_file),
                              onPressed: () async {
                                //필수 내용 들어간지 확인후 처리할 메서드 추가필요.
                                if (!img_set) {
                                  Fluttertoast.showToast(
                                    msg: '제보사진촬영은 필수 입니다!',
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                  );
                                } else if ((contenttext_cntr.text == '') ||
                                    (titletext_cntr.text == '')) {
                                  Fluttertoast.showToast(
                                    msg: '제목과 내용은 필수 입력사항입니다!',
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                  );
                                } else {
                                  //
                                  await upload_server(titletext_cntr.text,
                                      contenttext_cntr.text);
                                  if (upload_ok) {
                                    Fluttertoast.showToast(
                                      msg: '제보를 완료하였습니다!',
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                    );
                                    Navigator.popUntil(
                                        context, ModalRoute.withName('/'));
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: '서버와의 통신에 실패햐였습니다.',
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                    );
                                  }
                                }
                              }),
                        ],
                      ),
                    ],
                  ),
                ))));
  }
}
