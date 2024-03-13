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
  List<Forecast>? forecastData;

  @override
  void initState() {
    super.initState();
    _fetchForecastData();
  }

  Future<void> _fetchForecastData() async {
    final fetchedData = await forecastService.fetchForecastWeather(widget.latitude, widget.longitude);
    print("forecastData-->"+fetchedData.toString());
    setState(() {
      forecastData = fetchedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return forecastData != null
        ? ListView.builder(
      itemCount: forecastData!.length,
      itemBuilder: (context, index) {
        Forecast forecast = forecastData![index];
        return Card(
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            child: SizedBox(
              width: 300,
              height: 100,
              child: Row(
                children: [
                  Text('Time: ${DateFormat.jm().format(DateTime.parse(forecast.time))}'),
                  Text('Temperature: ${forecast.temperature}°C')
                ],
              ),
            ),
          ),
        );
      },
    )
        : Center(
      child: CircularProgressIndicator(),
    );
  }
}
