import 'package:intl/intl.dart';

class user_history {
  static List<dynamic> walked_data = [];
  static List<List> walked_dataset = [];

  static void set_walked_data(
      DateTime start, DateTime end, Duration diff, String destination) {
    String start_time = DateFormat('yy/mm/dd Hm').format(start);
    String end_time = DateFormat('yy/mm/dd Hm').format(end);
    print(start);
    print(end);
    print(diff);
    walked_data.add(start);
    walked_data.add(end);
    walked_data.add(diff);
    walked_data.add(destination);

    walked_dataset.add(walked_data);

    walked_data.clear();
  }
}
