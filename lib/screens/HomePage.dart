import 'package:flutter/material.dart';
import 'package:weather_app/data/models/UserLocation.dart';
import 'package:weather_app/data/services/LocationService.dart';
import 'package:weather_app/screens/RealTimeWeatherScreen/RealTimeWeatherScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserLocation? userLocation;
  bool isLoading = true;
  bool _locationDetermined = false;
  String appBarTitle = 'Weather App';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _askForPermission();
    });
  }

  Future<void> _determineLocation(BuildContext context) async {
    try {
      LocationService locationService = LocationService();
      UserLocation? location = await locationService.fetchLocation(context);
      if (location != null) {
        setState(() {
          userLocation = location;
          isLoading = false;
          _locationDetermined = true;
          appBarTitle = location.name;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching location: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _askForPermission() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Permission'),
          content: Text('Please grant permission to access your location.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  isLoading = false;
                });
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Request location permission
                Navigator.of(context).pop();
                await _determineLocation(context); // Await here
              },
              child: Text('Grant'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isLoading && userLocation != null)
          CircularProgressIndicator(),
        if (_locationDetermined && userLocation != null)
          Expanded(
            child: RealTimeWeatherScreen(
              latitude: userLocation!.latitude,
              longitude: userLocation!.longitude,
            ),
          ),
      ],
    );
  }
}
