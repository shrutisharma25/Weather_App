import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/data/models/UserLocation.dart';

class LocationService {
  Future<UserLocation> fetchLocation(BuildContext context) async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );
    String lat = position.latitude.toString();
    String long = position.longitude.toString();
    UserLocation userLocation = UserLocation(latitude: lat, longitude: long, name: '');
    print("userLocation-->" + userLocation.toString());
    return userLocation;
  }
}