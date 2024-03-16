class Forecast {
  String time;
  String temperature;

  String? error;

  Forecast({required this.time, required this.temperature, this.error});
}