import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'walk_history.dart';

class user_status {
  static bool is_walking = false;
  static String destination = '';
  static DateTime start_time, end_time;
  static Duration walked_duration;
  static LatLng location;

  user_status() {
    is_walking = false;
    start_time = DateTime(0000);
    end_time = DateTime(0000);
  }

  static bool check_status() {
    return is_walking;
  }

  static String get_destination() {
    return destination;
  }

  static void start_walk(String destination_location, LatLng started_location) {
    is_walking = true;
    start_time = DateTime.now();
    end_time = DateTime(0000);
    destination = destination_location;
    location = started_location;
    walked_duration = Duration();
  }

  static void end_walk() {
    is_walking = false;
    end_time = DateTime.now();

    walked_duration = end_time.difference(start_time);

    user_history.set_walked_data(
        start_time, end_time, walked_duration, destination);

    start_time = DateTime(0000);
    end_time = DateTime(0000);
    walked_duration = Duration();
    destination = '';
  }
}
