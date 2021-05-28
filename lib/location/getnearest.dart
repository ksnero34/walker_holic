import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class getnearestsite {
  LatLng user;
  LatLng simin = LatLng(35.168693, 129.057662);
  LatLng unitedn = LatLng(35.127479, 129.098139);
  LatLng gwang = LatLng(35.140535, 129.117227);
  String site;

  //getnearestsite(double latitude, double longitude);

  double getDistance(LatLng LatLng1, LatLng LatLng2) {
    double distance = Geolocator.distanceBetween(LatLng1.latitude,
        LatLng1.longitude, LatLng2.latitude, LatLng2.longitude);
    return distance;
  }

  setnearest(LatLng location) {
    user = location;
    double dis_simin, dis_unitedn, dis_gwang;
    int val;

    dis_simin = getDistance(user, simin);
    dis_unitedn = getDistance(user, unitedn);
    dis_gwang = getDistance(user, gwang);

    if ((dis_simin < dis_unitedn) && (dis_simin < dis_gwang)) {
      val = 1;
    } else if ((dis_unitedn < dis_simin) && (dis_unitedn < dis_gwang)) {
      val = 2;
    } else {
      val = 3;
    }

    if (val == 1)
      site = '시민공원';
    else if (val == 2)
      site = '유엔공원';
    else
      site = '광안리';
  }

  String getsite() {
    return site;
  }
}
