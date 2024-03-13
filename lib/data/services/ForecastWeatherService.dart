import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_app/data/models/Forecast.dart';
import 'package:weather_app/utils/consts.dart';

class ForecastWeatherService {
  Future<List<Forecast>?> fetchForecastWeather(
      String latitude, String longitude) async {
    final fullUrl =
        Weather_URL + 'forecast?location=$latitude,$longitude&apikey=$API_Key';

    print("fullUrlForeCast-->" + fullUrl);
    final response = await http.get(Uri.parse(fullUrl));
    print("response2-->" + response.toString());

    List<Forecast> forecasts = [];
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print("jsonResponse-->" + jsonResponse.toString());
      final data = jsonResponse['timelines']['hourly'];
      print("data2-->" + data.toString());
      for (var item in data) {
        final time = item['time'].toString();
        String temperature = item['values']['temperature'].toString();
        print("temperature-->" + temperature.toString());

        DateTime dateTime = DateTime.parse(time);
        String todaysDate = DateFormat('yyyy-MM-dd').format(dateTime);
        int hour = dateTime.hour;

// Check if the hour is a multiple of 3
        if (hour % 3 == 0) {
          print("todaysDate-->" + todaysDate.toString());
          print("time-->" + time);
          print("check-->" + time.contains(todaysDate).toString());

          if (time.contains(todaysDate)) {
            forecasts.add(Forecast(
              time: time,
              temperature: temperature,
            ));
          }
        }


      }
      return forecasts;
    } else if (response.statusCode == 429) {
      final jsonResponse = json.decode(response.body);
      final errorMessage = jsonResponse['message'];
      forecasts.add(Forecast(time: "", temperature: "", error: errorMessage));
      return forecasts;
    } else {
      return null;
    }
  }
}
