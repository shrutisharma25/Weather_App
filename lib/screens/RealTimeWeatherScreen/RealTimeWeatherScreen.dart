import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:weather_app/data/models/Weather.dart';
import 'package:weather_app/data/services/RealTimeWeatherService.dart';
import 'package:weather_app/screens/ForecastWeatherScreen/ForecastWeatherScreen.dart';
import 'package:weather_app/utils/Icons.dart';

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
  GetWeatherImage fetchWeatherImage = GetWeatherImage();


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
      backgroundColor: Colors.blue[400],
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: Center(child: Text('Real Time Weather',style: TextStyle(fontWeight: FontWeight.bold),),),
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
              String? temp = valuesMap?['temperature'].toString();
              weatherImage = fetchWeatherImage.getWeatherImage(double.parse(temp!));
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 7),
                    child: Text(
                      '$locationName',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Opacity(
                      opacity: 0.8,
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
                        color: Colors.white.withOpacity(0.7),
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
                  SizedBox(height: 5,),
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
