class user_history {
  static List<dynamic> walked_data;
  static List<List> walked_dataset;

  static void set_walked_data(DateTime start, DateTime end, Duration diff) {
    walked_data.add(start);
    walked_data.add(end);
    walked_data.add(diff);

    walked_dataset.add(walked_data);

    walked_data.clear();
  }
}
