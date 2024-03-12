import 'package:flutter/material.dart';
import 'package:weather_app/data/models/Weather.dart';
import 'package:weather_app/data/services/RealTimeWeatherService.dart';

class RealTimeWeatherScreen extends StatefulWidget {
  final String latitude;
  final String longitude;

  const RealTimeWeatherScreen(
      {required this.latitude, required this.longitude});

  @override
  State<RealTimeWeatherScreen> createState() => _RealTimeWeatherScreenState();
}

class _RealTimeWeatherScreenState extends State<RealTimeWeatherScreen> {
  final RealTimeWeatherService weatherService = RealTimeWeatherService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Real-time Weather'),
      ),
      body: Center(
        child: FutureBuilder(
          future: weatherService.fetchRealTimeWeather(
              widget.latitude, widget.longitude),
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              print("snapshot-->" + snapshot.data.toString());
              final Weather? weather = snapshot.data;
              if (weather != null) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Cloud Base: ${weather.time}'),
                    Text('Cloud Cover: ${weather.values}'),
                  ],
                );
              } else {
                return Text('No data available');
              }
            }
          },
        ),
      ),
    );
  }
}
