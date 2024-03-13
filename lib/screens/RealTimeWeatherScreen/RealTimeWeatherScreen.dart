import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:weather_app/data/models/Weather.dart';
import 'package:weather_app/data/services/RealTimeWeatherService.dart';
import 'package:weather_app/screens/ForecastWeatherScreen/ForecastWeatherScreen.dart';

class RealTimeWeatherScreen extends StatefulWidget {
  final String latitude;
  final String longitude;

  const RealTimeWeatherScreen({required this.latitude, required this.longitude});

  @override
  State<RealTimeWeatherScreen> createState() => _RealTimeWeatherScreenState();
}

class _RealTimeWeatherScreenState extends State<RealTimeWeatherScreen> {
  final RealTimeWeatherService weatherService = RealTimeWeatherService();
  String locationName = '';

  @override
  void initState() {
    super.initState();
    getLocationName();
  }

  Future<void> getLocationName() async {
    try {
      List<Placemark> placeMarks = await placemarkFromCoordinates(
          double.parse(widget.latitude), double.parse(widget.longitude));
      setState(() {
        locationName = placeMarks[0].locality ?? '';
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(child: Text('Real Time Weather'),),
      ),
      body: FutureBuilder<Weather>(
        future: weatherService.fetchRealTimeWeather(
            widget.latitude, widget.longitude),
        builder: (context, AsyncSnapshot<Weather> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Container(
              padding: EdgeInsets.all(20.0),
              color: Colors.red,
              child: Center(
                child: Text(
                  '${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ),
            );
          } else {
            final Weather? weather = snapshot.data;
            if (weather != null) {
              String weatherImage = '';
              Map<String, dynamic>? valuesMap;
              try {
                valuesMap = weather.values;
              } catch (e) {
                print('Error decoding JSON: $e');
              }
              if (valuesMap != null && valuesMap['cloudCover'] != null && valuesMap['cloudCover'] > 50) {
                weatherImage = "assets/images/cloudy.png";
              } else {
                weatherImage = "assets/images/clear.png";
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      '$locationName',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Opacity(
                      opacity: 0.5, // Set opacity for the cloud base text
                      child: Text(
                        '${DateFormat('MMM dd, yyyy').format(DateTime.parse(weather.time))}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 100,
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                weatherImage,
                                width: 80,
                                height: 60,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 100,
                        width: 1,
                        color: Colors.grey.withOpacity(0.5), // Dimmed vertical line
                      ),
                      Expanded(
                        child: Container(
                          height: 100,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${valuesMap?['temperature']}°C',
                                style: TextStyle(fontSize: 35),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  ForecastWeatherScreen(latitude:widget.latitude,longitude:widget.longitude),
                ],
              );
            } else {
              return Text('No data available');
            }
          }
        },
      ),
    );
  }
}
