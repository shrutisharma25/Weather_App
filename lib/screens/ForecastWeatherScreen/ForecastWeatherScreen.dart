import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/data/services/ForecastWeatherService.dart';
import 'package:weather_app/data/models/Forecast.dart';

import '../../utils/Icons.dart';

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
  List<Forecast>? forecastDailyDataList;
  bool isLoading = true;
  GetWeatherImage fetchWeatherImage = GetWeatherImage();
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
        forecastDailyDataList = fetchedDailyData;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  String getWeatherImage(double temperature) {
    if (temperature < 0) {
      return "assets/images/snow.png";
    } else if (temperature >= 0 && temperature < 15) {
      return "assets/images/lightrain.png";
    } else if (temperature >= 15 && temperature < 25) {
      return "assets/images/heavyrain.png";
    } else if (temperature >= 25 && temperature <= 35) {
      return "assets/images/cloudsunny.png";
    } else {
      return "assets/images/clear.png";
    }
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ForeCastHourly(),
        SizedBox(
          height: 10,
        ),
        ForeCastDaily()
      ],
    );
  }

  Widget ForeCastHourly() {
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
                    Forecast forecast = forecastData![index];
                    final weatherImage = fetchWeatherImage.getWeatherImage(double.parse(forecast.temperature));
                    print("weatherImage " +weatherImage.toString());
                    return Row(
                      children: [
                        SizedBox(width: 6),
                        Card(
                          color: Colors.white,
                          clipBehavior: Clip.hardEdge,
                          shadowColor: Colors.orangeAccent[100],
                          child: InkWell(
                            splashColor: Colors.blue.withAlpha(30),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    weatherImage,
                                    width: 70,
                                    height: 27,
                                  ),
                                  Text(
                                    '${DateFormat.jm().format(DateTime.parse(forecast.time))}',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${forecast.temperature}°C',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    );


                  },
                ),
              )
            : Center(
                child: Text('No forecast data available.'),
              );
  }

  Widget ForeCastDaily() {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : forecastData != null
            ? Container(
                child: Card(
                  clipBehavior: Clip.hardEdge,
                  color: Colors.white,
                  child: SizedBox(
                    width: 330,
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          SizedBox(height: 15,),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(6, 5, 6, 5),
                            child: Text(
                              forecastDailyDataList!.length.toString()+" Days Forecast",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: forecastDailyDataList!.length,
                              itemBuilder: (BuildContext context, int index) {
                                Forecast forecastDaily = forecastDailyDataList![index];
                                final weatherImage = fetchWeatherImage.getWeatherImage(
                                    double.parse(forecastDaily.temperature));
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(6, 0, 6, 5),
                                  child: Card(
                                    color: Colors.blue[400],
                                    clipBehavior: Clip.hardEdge,
                                    child: InkWell(
                                      splashColor: Colors.blue[400],
                                      child: SizedBox(
                                        width: 90,
                                        height: 40,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                            child:Row(
                                              children: [
                                                SizedBox(width: 10),
                                                Text(
                                                  '${forecastDaily.time}',style: TextStyle(fontWeight: FontWeight.bold),),
                                                SizedBox(
                                                  width: 85,
                                                ),
                                                Image.asset(
                                                  weatherImage,
                                                  width: 70,
                                                  height: 80,
                                                ),
                                                SizedBox(width:55,),

                                                Text('${forecastDaily.temperature}°C',style: TextStyle(fontWeight: FontWeight.bold),)
                                              ],
                                            )
                                        ),
                                      )
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Center(
                child: Text('No forecast data available.'),
              );
  }

}
