class user_status {
  bool is_walking;
  DateTime start_time, end_time;
  Duration walked_duration;

  user_status() {
    is_walking = false;
    start_time = DateTime(0000);
    end_time = DateTime(0000);
  }

  bool check_status() {
    return is_walking;
  }

  void start_walk() {
    is_walking = true;
    start_time = DateTime.now();
    end_time = DateTime(0000);
    walked_duration = Duration();
  }

  void end_walk() {
    is_walking = false;
    end_time = DateTime.now();

    walked_duration = end_time.difference(start_time);

    start_time = DateTime(0000);
    end_time = DateTime(0000);
    walked_duration = Duration();
  }
}
