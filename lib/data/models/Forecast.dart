class Forecast {
  String time;
  String temperature;

  String? error; // Optional error message

  Forecast({required this.time, required this.temperature, this.error});
}