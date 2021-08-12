import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../main.dart';

class user_history {
  static List<dynamic> walked_data = [];
  static List<List> walked_dataset = [];

  static void set_walked_data(
      DateTime start, DateTime end, Duration diff, String destination) {
    // String start_time = DateFormat('yy/mm/dd Hm').format(start);
    // String end_time = DateFormat('yy/mm/dd Hm').format(end);
    // print('산책 시작시간 : $start');
    // print('산책 끝난시간 : $end');
    // print('산책 한시간  : $diff');

    walked_data.add(start);
    walked_data.add(end);
    walked_data.add(diff);
    walked_data.add(destination);

    upload_server_walk(walked_data);

    //TODO : 지역당 총 산책시간은 shared에 저장 산책데이터는 추후 json으로 파싱해서 데베로 넣어주기
    walked_dataset.add(walked_data);

    DateTime amount_walk =
        DateTime.parse(key_val.getString(destination)).add(diff);

    key_val.setString(destination, amount_walk.toString());
    walked_data.clear();
  }

  static Future<void> upload_server_walk(List<dynamic> input_data) async {
    try {
      String url = 'http://211.219.250.41/input_walk_log';
      //print(input_data);
      var uri = Uri.parse(url);
      var data = {
        "type": "walk",
        "start": input_data[0].toString(),
        "end": input_data[1].toString(),
        "diff": input_data[2].toString(),
        "destination": input_data[3],
      };
      var body = json.encode(data);
      http.Response response = await http.post(uri,
          headers: <String, String>{"Content-Type": "application/json"},
          body: body);
      print(response.statusCode);

      //print(body);
      //print(userlocation_global.latitude);
    } on Exception catch (e) {
      // TODO
      print(e);
    }
  }
}
