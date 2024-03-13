import 'dart:convert';

import 'package:weather_app/data/models/Weather.dart';
import 'package:weather_app/utils/consts.dart';
import 'package:http/http.dart' as http;


class RealTimeWeatherService {
  Future<Weather> fetchRealTimeWeather(String latitude, String longitude) async {
    print("lat-->" + latitude);
    print("long-->" + longitude);

    final fullUrl = Weather_URL+'realtime?location=$latitude,$longitude&apikey=$API_Key';
    final response = await http.get(Uri.parse(fullUrl));
    print("fullUrlRealTime-->" + fullUrl.toString());

    print("response-->" + response.toString());
    if (response.statusCode == 200) {
      print("jsonResponse-->" + response.body.toString());
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse.containsKey('data')) {
        String time = jsonResponse['data']['time'].toString();
        Map<String, dynamic> values = jsonResponse['data']['values'];
        return Weather(
          time: time,
          values: values,
        );
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      String error = "";
      if (jsonResponse.containsKey('message')) {
        error = jsonResponse['message'].toString();
      }
      throw Exception(error);
    }
  }
}
