import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/data/models/Forecast.dart';
import 'package:weather_app/utils/consts.dart';

class ForecastWeatherService {
  Future<List<Forecast>?> fetchForecastWeather(
      String latitude, String longitude) async {
    final fullUrl =
        Weather_URL + 'forecast?location=$latitude,$longitude&apikey=$API_Key';

    print("fullUrlForeCast-->" + fullUrl);
    final response = await http.get(Uri.parse(fullUrl));

    List<Forecast> forecasts = [];
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print("response-->" + jsonResponse.toString());
      final data = jsonResponse['timelines']['minutely'];
      print("data-->" + data.toString());
      for (var item in data) {
        final time = item['time'].toString();
        Map<String, dynamic> values = item['values'];


        print("values-->" + values.toString());

        forecasts.add(Forecast(
          time: time,
          values: values,
        ));
      }
      return forecasts;
    } else if (response.statusCode == 429) {
      final jsonResponse = json.decode(response.body);
      final errorMessage = jsonResponse['message'];
      forecasts.add(Forecast(time: "", values: {}, error: errorMessage));
      return forecasts;
    } else {
      return null;
    }
  }
}
