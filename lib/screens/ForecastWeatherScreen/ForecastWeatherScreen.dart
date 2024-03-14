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
  List<Forecast>? forecastDailyData;
  bool isLoading = true;
  String todaysDate =
  DateFormat('yyyy-MM-dd', 'en_US').format(DateTime.now().toUtc());

  @override
  void initState() {
    super.initState();
    _fetchHourlyData();
  }

  Future<void> _fetchHourlyData() async {
    try {
      final fetchedData = await forecastService.fetchHourlyWeather(
          widget.latitude, widget.longitude, todaysDate);
      final fetchedDailyData = await forecastService.fetchDailyWeather(
          widget.latitude, widget.longitude);
      print("fetchedData-->" + fetchedData.toString());
      print("fetchedDailyData-->" + fetchedDailyData.toString());
      setState(() {
        forecastData = fetchedData;
        forecastDailyData = fetchedDailyData;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  String getWeatherImage(double temperature) {
    if (temperature > 25) {
      return "assets/images/hot.png"; // Image file name for hot weather
    } else {
      return "assets/images/cold.png"; // Image file name for cold weather
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ForeCastHourly(),
        SizedBox(height: 10,),
        ForeCastDaily()
      ],
    );
  }

  Widget ForeCastHourly(){
    return isLoading
        ? Center(
      child: CircularProgressIndicator(),
    )
        : forecastData != null
        ? Container(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: forecastData!.length,
        itemBuilder: (BuildContext context, int index) {
          final forecast = forecastData![index];
          final weatherImage =
          getWeatherImage(double.parse(forecast.temperature));
          return Padding(
            padding: const EdgeInsets.all(8.0), // Adjust padding as needed
            child: Card(
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                child: SizedBox(
                  width: 100,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Image.asset(
                          //   weatherImage,
                          //   width: 10, // Adjust width as needed
                          //   height: 5, // Adjust height as needed
                          // ),
                          // SizedBox(height: 10,),
                          Text(
                              '${DateFormat.jm().format(DateTime.parse(forecast.time))}'),
                          Text('${forecast.temperature}°C')
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    )
        : Center(
      child: Text('No forecast data available.'),
    );
  }

  Widget ForeCastDaily(){
    return isLoading
        ? Center(
      child: CircularProgressIndicator(),
    )
        : forecastData != null
        ? Container(
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: 350,
          height: 300,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: forecastData!.length,
            itemBuilder: (BuildContext context, int index) {
              final forecast = forecastData![index];
              final weatherImage =
              getWeatherImage(double.parse(forecast.temperature));
              return Padding(
                padding: const EdgeInsets.fromLTRB(6, 0, 6, 5), // Adjust padding as needed
                child: Card(
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    child: SizedBox(
                      width: 90,
                      height: 40,
                      child: Row(
                        children: [
                          // Image.asset(
                          //   weatherImage,
                          //   width: 10, // Adjust width as needed
                          //   height: 5, // Adjust height as needed
                          // ),
                          // SizedBox(height: 10,),
                          Text(
                              '${DateFormat.jm().format(DateTime.parse(forecast.time))}'),
                          Text('${forecast.temperature}°C')
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        )
      )
    )
        : Center(
      child: Text('No forecast data available.'),
    );
  }

}
