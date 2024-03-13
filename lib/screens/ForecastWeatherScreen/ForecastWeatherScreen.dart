import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/data/services/ForecastWeatherService.dart';
import 'package:weather_app/data/models/Forecast.dart';

class ForecastWeatherScreen extends StatefulWidget {
  final String latitude;
  final String longitude;

  const ForecastWeatherScreen(
      {Key? key, required this.latitude, required this.longitude})
      : super(key: key);

  @override
  State<ForecastWeatherScreen> createState() => _ForecastWeatherScreenState();
}

class _ForecastWeatherScreenState extends State<ForecastWeatherScreen> {
  final ForecastWeatherService forecastService = ForecastWeatherService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Forecast>?>(
      future: forecastService.fetchForecastWeather(
          widget.latitude, widget.longitude),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          if (snapshot.data != null && snapshot.data!.isNotEmpty) {
            return Center(
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final forecast = snapshot.data![index];
                  return Card(
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      child: SizedBox(
                        width: 300,
                        height: 100,
                        child: Row(
                          children: [
                            Text('Temperature: ${DateFormat.jm().format(DateTime.parse(forecast.time))}°C')
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return Text('No forecast data available.');
          }
        }
      },
    );
  }

  Widget TodayTemperature() {
    return Text("hi");
  }
}
