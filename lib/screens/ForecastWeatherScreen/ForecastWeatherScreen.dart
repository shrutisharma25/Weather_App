import 'package:flutter/material.dart';
import 'package:weather_app/data/services/ForecastWeatherService.dart';
import 'package:weather_app/data/models/Forecast.dart';

class ForecastWeatherScreen extends StatefulWidget {
  const ForecastWeatherScreen({Key? key}) : super(key: key);

  @override
  State<ForecastWeatherScreen> createState() => _ForecastWeatherScreenState();
}

class _ForecastWeatherScreenState extends State<ForecastWeatherScreen> {
  final ForecastWeatherService forecastService = ForecastWeatherService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forecasted Weather'),
      ),
      body: Center(
        child: FutureBuilder<List<Forecast>?>(
          future: forecastService.fetchForecastWeather(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              // If data is available, display it
              if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final forecast = snapshot.data![index];
                    return ListTile(
                      title: Text("hi")
                          // 'Temperature: ${forecast.temperature}°C, Humidity: ${forecast.humidity}%, Wind Speed: ${forecast.windSpeed} m/s, Time: ${forecast.time}'),
                    );
                  },
                );
              } else {
                return Text('No forecast data available.');
              }
            }
          },
        ),
      ),
    );
  }
}
